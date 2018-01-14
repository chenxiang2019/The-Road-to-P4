header_type flow_t {
    fields {
        // Tunnel metadata.
	tun_id : 64;
	tun_ip_src : 32;
	tun_ip_dst : 32;
	tun_flags : 16; // host
	tun_ip_tos : 8;
	tun_ip_ttl : 8;
	tun_tp_src : 16;
	tun_tp_dst : 16;
	tun_gbp_id : 16;
	tun_gbp_flags : 8;
	tun_pad1 : 40;

	// Other metadata.
	metadata : 64;
	reg0 : 32; // host
	reg1 : 32; // host
	reg2 : 32; // host
	reg3 : 32; // host
	reg4 : 32; // host
	reg5 : 32; // host
	reg6 : 32; // host
	reg7 : 32; // host
	skb_priority : 32; // host
	pkt_mark : 32; // host
	dp_hash : 32; // host
	in_port : 32; // host
	recirc_id : 32; // host
	conj_id : 32; // host
	actset_output : 16; // host
	pad1 : 48;

	// L2
	dl_dst : 48;
	dl_src : 48;
	dl_type : 16;
	vlan_pcp : 3;
	vlan_present : 1;
	vlan_vid : 12;
        mpls_label0 : 20;
	mpls_tc0 : 3;
	mpls_bos0 : 1;
	mpls_ttl0 : 8;
        mpls_label1 : 20;
	mpls_tc1 : 3;
	mpls_bos1 : 1;
	mpls_ttl1 : 8;
        mpls_label2 : 20;
	mpls_tc2 : 3;
	mpls_bos2 : 1;
	mpls_ttl2 : 8;
	mpls_pad : 32;

	// L3
	nw_src : 32;
	nw_dst : 32;
	ipv6_src : 128;
	ipv6_dst : 128;
	ipv6_label : 32;
	nw_frag : 8;
	nw_tos : 8;
	nw_ttl : 8;
	nw_proto : 8;
	nd_target : 128;
	arp_sha : 48;
	arp_tha : 48;
        tcp_flags_pad : 4;
	tcp_flags : 12;
	pad2 : 16;

	// L4
	tp_src : 16;
	tp_dst : 16;
	igmp_group_ip4 : 32;
    }
}

metadata flow_t flow;
parser start {
    return l2_eth;
}

header_type l2_eth_t {
    fields {
        eth_dst : 48;
	eth_src : 48;
    }
}
header l2_eth_t l2_eth;
parser l2_eth {
    extract(l2_eth);
    set_metadata(flow.dl_dst, latest.eth_dst);
    set_metadata(flow.dl_src, latest.eth_src);
    return select(current(0, 16)) {
        0x8100: l2_vlan;
	default: l2_ethertype;
    }
}

header_type l2_vlan_t {
    fields {
        vlan_tpid : 16;
	vlan_pcp : 3;
	vlan_cfi : 1;
	vlan_vid : 12;
    }
}
header l2_vlan_t l2_vlan;
parser l2_vlan {
    extract(l2_vlan);
    set_metadata(flow.vlan_pcp, l2_vlan.vlan_pcp);
    set_metadata(flow.vlan_present, 1);
    set_metadata(flow.vlan_vid, l2_vlan.vlan_vid);
    return l2_ethertype;
}

header_type l2_ethertype_t {
    fields {
        eth_type : 16;
    }
}
header l2_ethertype_t l2_ethertype;
parser l2_ethertype {
    extract(l2_ethertype);

    // XXX What about the distinction between Ethertypes and packet lengths?
    set_metadata(flow.dl_type, l2_ethertype.eth_type);

    return select (l2_ethertype.eth_type) {
        0x8847: l2_5_mpls0;
	0x8848: l2_5_mpls0;
	0x0800: l3_ipv4;
	//0x86dd: l3_ipv6;
	0x0806: l3_arp;
	0x8035: l3_arp;
	default: ingress;
    }
}

header_type l2_5_mpls_t {
    fields {
        mpls_label : 20;
	mpls_tc : 3;
	mpls_bos : 1;
	mpls_ttl : 8;
    }
}
header l2_5_mpls_t l2_5_mpls0;
header l2_5_mpls_t l2_5_mpls1;
header l2_5_mpls_t l2_5_mpls2;
parser l2_5_mpls0 {
    extract(l2_5_mpls0);
    set_metadata(flow.mpls_label0, latest.mpls_label);
    set_metadata(flow.mpls_tc0, latest.mpls_tc);
    set_metadata(flow.mpls_bos0, latest.mpls_bos);
    set_metadata(flow.mpls_ttl0, latest.mpls_ttl);
    return select(latest.mpls_bos) {
        0: l2_5_mpls1;
	default: ingress;
    }
}
parser l2_5_mpls1 {
    extract(l2_5_mpls1);
    set_metadata(flow.mpls_label1, latest.mpls_label);
    set_metadata(flow.mpls_tc1, latest.mpls_tc);
    set_metadata(flow.mpls_bos1, latest.mpls_bos);
    set_metadata(flow.mpls_ttl1, latest.mpls_ttl);
    return select(latest.mpls_bos) {
        0: l2_5_mpls2;
	default: ingress;
    }
}
parser l2_5_mpls2 {
    extract(l2_5_mpls2);
    set_metadata(flow.mpls_label2, latest.mpls_label);
    set_metadata(flow.mpls_tc2, latest.mpls_tc);
    set_metadata(flow.mpls_bos2, latest.mpls_bos);
    set_metadata(flow.mpls_ttl2, latest.mpls_ttl);
    return ingress;
}

header_type l3_ipv4_t {
    fields {
        ip_ver : 4;
	ip_ihl : 4;
	ip_tos : 8;
	ip_tot_len : 16;
	ip_id : 16;
	ip_resvd : 1;
	ip_df : 1;
	ip_mf : 1;
	ip_frag_off : 13;
	ip_ttl : 8;
	ip_proto : 8;
	ip_csum : 16;
	ip_src : 32;
	ip_dst : 32;
	options : *;
    }
    length : ip_ihl * 4;
    max_length : 60;
}
header l3_ipv4_t l3_ipv4;
parser l3_ipv4 {
    extract(l3_ipv4);
    set_metadata(flow.nw_src, l3_ipv4.ip_src);
    set_metadata(flow.nw_dst, l3_ipv4.ip_dst);
    // XXX nw_frag and fragment handling
    set_metadata(flow.nw_tos, l3_ipv4.ip_tos);
    set_metadata(flow.nw_ttl, l3_ipv4.ip_ttl);
    set_metadata(flow.nw_proto, l3_ipv4.ip_proto);
    return select(latest.ip_proto) {
        6: l4_tcp;
	17: l4_udp;
	132: l4_sctp;
	1: l4_icmp;
	2: l4_igmp;
	default: ingress;
    }
}

header_type l4_tcp_t {
    fields {
        tcp_src : 16;
	tcp_dst : 16;
	tcp_seq : 32;
	tcp_ack : 32;
	tcp_data_ofs : 4;
	tcp_flags : 12;
	tcp_winsz : 16;
	tcp_csum : 16;
	tcp_urg : 16;
	options : *;
    }
    length : 4 * tcp_data_ofs;
    max_length : 60;
}
header l4_tcp_t l4_tcp;
parser l4_tcp {
    extract(l4_tcp);
    set_metadata(flow.tcp_flags, l4_tcp.tcp_flags);
    set_metadata(flow.tp_src, l4_tcp.tcp_src);
    set_metadata(flow.tp_dst, l4_tcp.tcp_dst);
    return ingress;
}

header_type l4_udp_t {
    fields {
        udp_src : 16;
	udp_dst : 16;
	udp_len : 16;
	udp_csum : 16;
    }
}
header l4_udp_t l4_udp;
parser l4_udp {
    extract(l4_udp);
    set_metadata(flow.tp_src, l4_udp.udp_src);
    set_metadata(flow.tp_dst, l4_udp.udp_dst);
    return ingress;
}

header_type l4_sctp_t {
    fields {
        sctp_src : 16;
	sctp_dst : 16;
	sctp_vtag : 32;
	sctp_csum : 32;
    }
}
header l4_sctp_t l4_sctp;
parser l4_sctp {
    extract(l4_sctp);
    set_metadata(flow.tp_src, l4_sctp.sctp_src);
    set_metadata(flow.tp_dst, l4_sctp.sctp_dst);
    return ingress;
}

header_type l4_igmp_t {
    fields {
        igmp_type : 8;
	igmp_code : 8;
	igmp_csum : 16;
	igmp_group : 32;
    }
}
header l4_igmp_t l4_igmp;
parser l4_igmp {
    extract(l4_igmp);
    set_metadata(flow.tp_src, l4_igmp.igmp_type);
    set_metadata(flow.tp_dst, l4_igmp.igmp_code);
    set_metadata(flow.igmp_group_ip4, l4_igmp.igmp_group);
    return ingress;
}

header_type l3_arp_t {
    fields {
        ar_hrd : 16;
	ar_pro : 16;
	ar_hln : 8;
	ar_pln : 8;
	ar_op : 16;
	ar_sha : 48;
	ar_spa : 32;
	ar_tha : 48;
	ar_tpa : 32;
    }
}
header l3_arp_t l3_arp;
parser l3_arp {
    extract(l3_arp);
    return select(latest.ar_hrd, latest.ar_pro, latest.ar_hln, latest.ar_pln) {
        1, 0x800, 6, 4: l3_arp2;
	default: ingress;
    }
}
parser l3_arp2 {
    set_metadata(flow.nw_src, l3_arp.ar_spa);
    set_metadata(flow.nw_dst, l3_arp.ar_tpa);
    set_metadata(flow.nw_proto, l3_arp.ar_op);
    set_metadata(flow.arp_sha, l3_arp.ar_sha);
    set_metadata(flow.arp_tha, l3_arp.ar_tha);
    return ingress;
}

header_type l4_icmp_t {
    fields {
        icmp_type : 8;
	icmp_code : 8;
	icmp_csum : 16;
    }
}
header l4_icmp_t l4_icmp;
parser l4_icmp {
    extract(l4_icmp);
    set_metadata(flow.tp_src, l4_icmp.icmp_type);
    set_metadata(flow.tp_dst, l4_icmp.icmp_code);
    return ingress;
}
