/*
Copyright 2013-present Barefoot Networks, Inc. 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

#include "includes/headers.p4"
#include "includes/parser.p4"
#include "includes/intrinsic.p4"

#define FLOWLET_MAP_BITS 13
#define FLOWLET_MAP_SIZE 8192  // 2^13
#define FLOWLET_INACTIVE_TOUT 50000 // usec -> 50ms

header_type ingress_metadata_t {
    fields {
        flow_ipg : 48; // inter-packet gap
        flowlet_map_index : FLOWLET_MAP_BITS; // flowlet map index
        flowlet_id : 16; // flowlet id
        flowlet_lasttime : 48; // flowlet's last reference time

        ecmp_offset : 14; // offset into the ecmp table

        nhop_ipv4 : 32;
    }
}

metadata ingress_metadata_t ingress_metadata;

action _drop() {
    drop();
}

action nop() {}

field_list l3_hash_fields {
    ipv4.srcAddr;
    ipv4.dstAddr;
    ipv4.protocol;
    tcp.srcPort;
    tcp.dstPort;
}

field_list_calculation flowlet_map_hash {
    input {
        l3_hash_fields;
    }
    algorithm : crc16;
    output_width : FLOWLET_MAP_BITS;
}

register flowlet_lasttime {
    width : 48;
    instance_count : 8192;
}

register flowlet_id {
    width : 16;
    instance_count : 8192;
}

action set_nhop(port) {
    modify_field(standard_metadata.egress_spec, port);
    add_to_field(ipv4.ttl, -1);
}

action lookup_flowlet_map() {
    modify_field_with_hash_based_offset(ingress_metadata.flowlet_map_index, 0,
                                        flowlet_map_hash, FLOWLET_MAP_SIZE);

    register_read(ingress_metadata.flowlet_id,
                  flowlet_id, ingress_metadata.flowlet_map_index);

    modify_field(ingress_metadata.flow_ipg,
                 intrinsic_metadata.ingress_global_timestamp);
    register_read(ingress_metadata.flowlet_lasttime,
    flowlet_lasttime, ingress_metadata.flowlet_map_index);
    subtract_from_field(ingress_metadata.flow_ipg,
                        ingress_metadata.flowlet_lasttime);

    register_write(flowlet_lasttime, ingress_metadata.flowlet_map_index,
                   intrinsic_metadata.ingress_global_timestamp);
}

table flowlet {
    actions { lookup_flowlet_map; nop; }
}

action update_flowlet_id() {
    add_to_field(ingress_metadata.flowlet_id, 1);
    register_write(flowlet_id, ingress_metadata.flowlet_map_index,
                   ingress_metadata.flowlet_id);
}

table new_flowlet {
    actions { update_flowlet_id; nop; }
}

field_list flowlet_l3_hash_fields {
    ipv4.srcAddr;
    ipv4.dstAddr;
    ipv4.protocol;
    tcp.srcPort;
    tcp.dstPort;
    ingress_metadata.flowlet_id;
}

#define ECMP_BIT_WIDTH 10
#define ECMP_GROUP_TABLE_SIZE 1024
#define ECMP_NHOP_TABLE_SIZE 16384

field_list_calculation flowlet_ecmp_hash {
    input {
        flowlet_l3_hash_fields;
    }
    algorithm : crc16;
    output_width : ECMP_BIT_WIDTH;
}

action set_ecmp_select(ecmp_base, ecmp_count) {
    modify_field_with_hash_based_offset(ingress_metadata.ecmp_offset, ecmp_base,
                                        flowlet_ecmp_hash, ecmp_count);
}

table ecmp_group {
    reads {
        ipv4.dstAddr : lpm;
    }
    actions {
        _drop;
        set_ecmp_select;
        nop;
    }
    size : ECMP_GROUP_TABLE_SIZE;
}

table ecmp_nhop {
    reads {
        ingress_metadata.ecmp_offset : exact;
    }
    actions {
        _drop;
        set_nhop;
        nop;
    }
    size : ECMP_NHOP_TABLE_SIZE;
}

table forward {
    reads {
        ipv4.dstAddr : exact;
    }
    actions {
        set_nhop;
        _drop;
    }
    size: 512;
}

control ingress {
	apply(flowlet);
    if (ingress_metadata.flow_ipg > FLOWLET_INACTIVE_TOUT) {
        apply(new_flowlet);
    }
    apply(ecmp_group);
    apply(ecmp_nhop);
    apply(forward);
}

control egress {
}
