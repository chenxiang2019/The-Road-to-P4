# P4-Related Tools Installation

安装P4相关工具的步骤和说明。

**本说明只适用于 Ubuntu 14.04 系统。**

## 推荐安装的其他工具

- mininet：SDN网络仿真工具

- vim：编辑器

- scapy：Python的一个功能十分强大的库，可以用于生成数据报

- pip：Python包管理工具

## P4Factory

官方README：[P4 Model Repository](https://github.com/p4lang/p4factory#p4-model-repository)

注意：如果你对P4已经很熟悉并且能够独立搭建环境，这个repo已经不大适合现在的P4开发了(使用bmv1软件交换机)，建议是使用bmv2搭建环境并进行相关开发。

1.安装外部引用的库：

```
git submodule update --init --recursive
```

2.安装Ubuntu14.04系统下所需的所有依赖：

```
./install_deps.sh
```

3.在启动模拟器之前，需要创建虚拟的端口：

```
sudo p4factory/tools/veth_setup.sh
```

4.使用autoconf工具生成Makefile，并对工作环境进行配置：

```
cd p4factory
./autogen.sh
./configure
```

5.验证安装是否成功，并测试一个简单的P4程序：

```
cd p4factory/targets/basic_routing/
make bm
sudo ./behavioral-model
```

同时新打开一个终端进行测试：

```
cd p4factory/targets/basic_routing/
sudo python run_tests.py --test-dir tests/ptf-tests/
```

## BMv2

官方README：[BEHAVIORAL MODEL REPOSITORY](https://github.com/p4lang/behavioral-model#behavioral-model-repository)

1.Ubuntu 14.04下要求安装的依赖：

    automake
    cmake
    libjudy-dev
    libgmp-dev
    libpcap-dev
    libboost-dev
    libboost-test-dev
    libboost-program-options-dev
    libboost-system-dev
    libboost-filesystem-dev
    libboost-thread-dev
    libevent-dev
    libtool
    flex
    bison
    pkg-config
    g++
    libssl-dev

2.使用脚本安装外部依赖库，如thrift。

**注意：如果已经安装了P4Factory，请忽略此步，否则会有一系列的版本不匹配问题。**

```
./install_deps.sh
```

3.按照以下步骤安装bmv2：

```
./autogen.sh

./configure

make

[sudo] make install  # if you need to install bmv2
```

4.更新Linux库缓存：

```
sudo ldconfig
```

5.检验：

```
[sudo] make check
```

## P4c-bm

官方README：[p4c-bm](https://github.com/p4lang/p4c-bm#p4c-bm)

1.要求安装好pip;

2.安装步骤：

```
sudo pip install -r requirements.txt

sudo pip install -r requirements_v1_1.txt

sudo python setup.py install
```

## Happy Hacking :)