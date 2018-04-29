THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $THIS_DIR/../env.sh

P4C_BM_SCRIPT=$P4C_BM_PATH/p4c_bm/__main__.py

SWITCH_PATH=$BMV2_PATH/targets/simple_switch/simple_switch

CLI_PATH=$BMV2_PATH/targets/simple_switch/sswitch_CLI

# Probably not very elegant but it works nice here: we enable interactive mode
# to be able to use fg. We start the switch in the background, sleep for 2
# minutes to give it time to start, then add the entries and put the switch
# process back in the foreground
set -m
$P4C_BM_SCRIPT p4src/counter.p4 --json counter.json
$P4C_BM_SCRIPT p4src/meter.p4 --json meter.json
# This gets root permissions, and gives libtool the opportunity to "warm-up"
#sudo $SWITCH_PATH >/dev/null 2>&1
sudo $SWITCH_PATH counter.json -i 0@veth0 -i 1@veth2 -i 2@veth4 -i 3@veth6 -i 4@veth8 --nanolog ipc:///tmp/bm-0-log.ipc --pcap -- --enable-swap
echo " Exit the simple_switch"
