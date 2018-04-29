# Swap the configuration

## Description

This directory demonstrates how to swap the json configuration of BMv2 simple\_switch. 

### Running the demo

To run the demo:
- start the switch with `./run_switch.sh`;
- populate the data plane with the commands of counter.p4: `./simple_switch_CLI --thrift-port 9090 < counter_commands.txt`;
- start `simple_switch_CLI`: `./simple_switch_CLI --thrift-port 9090`;
- use `load_new_config_file` to load the new configuration `meter.json`: `RuntimeCmd: load_new_config_file meter.json`;
- use `swap_configs` to swap the configuration of s1 to `meter.json`: `RuntimeCmd: swap_configs meter.json`;
- exit the `simple_switch_CLI`: `RuntimeCmd: EOF`;
- populate the new commands of meter.p4: `./simple_switch_CLI --thrift-port 9090 < meter_commands.txt`.
