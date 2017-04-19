# Barefoot Network - McKeown: OpenFlow, P4 以及可编程网络

### 译者注：

本文译自2016年6月17号SDxCentral的编辑[Craig Matsumoto](https://www.sdxcentral.com/author/craig-matsumoto/)对Nick McKeown教授的采访。

Craig Matsumoto：SDxCentral.com的主编，负责该站点的内容及新闻。在SDN方面久经沙场，2010年开始对SDN领域进行相关的报道，从事新闻报道行业已有23余年。Craig生活在硅谷，可以通过他的个人邮箱与他取得联系：craig@sdxcentral.com 

Nick McKeown：Barefoot Networks首席科学家和合伙创办人, 斯坦福大学计算机科学教授, 在学术/工业界25年经验。SDN的共同发明人，P4、ONF、ON.Lab的共同创办人;曾创办三个成功的新创公司Nicira、 Abrizio、Nemo。

### 原文

- [Barefoot Networks’ McKeown: On OpenFlow, P4 & the Programmable Network](https://www.sdxcentral.com/articles/interview/mckeown-barefoot-networks-openflow-p4/2016/06/)

- [Barefoot Networks’ McKeown: Part 2](https://www.sdxcentral.com/articles/interview/barefoot-networks-mckeown-part-2/2016/06/)

# 译文

## 概要

离我们采访[Barefoot Networks公司](https://www.sdxcentral.com/listings/barefoot-networks/)的首席科学家Nick McKeown教授已经过去了一段时间了。

经常访问[SDxCentral](https://www.sdxcentral.com/cloud/definitions/software-defined-everything-sdx-part-1-definition/)和[SDNLAB](http://www.sdnlab.com/)的读者们都知道接下来的内容是什么：McKeown教授和加州大学伯克利分校的Scott Shenker教授的研究发明了[软件定义网络(SDN)](https://www.sdxcentral.com/sdn/)与[OpenFlow协议](https://www.sdxcentral.com/sdn/definitions/what-is-openflow/)；他们与Martin Casado一起创立了[Nicira Networks](https://www.sdxcentral.com/listings/nicira-acquired-by-vmware/)公司。

Nicira现在是VMware公司的一部分，这意味着McKeown教授已经品尝过三次(Nicira、 Abrizio以及Nemo)看着自己创立的公司被收购的滋味了。

现在，他正在站在第四次的征程上。在本周Barefoot Networks披露了他们的计划(开发一种可编程的交换机芯片，以及推动P4语言的发展)的同时，SDxCentral迅速前往了Palo Alto(美国加州帕罗奥图市，Barefoot Networks公司和Stanford University所在地)。Barefoot的办公楼坐落于毗邻斯坦福大学的一条住宅区的街道上，楼前悬挂着他们的标识，门前的牌子上写着：“Come in: We’re OPEN and awesome!”

继续往下读吧，你会了解到McKeown教授的创业经历，他对P4的构想，以及由他负责的OpenFlow的现状。

## 采访

- 采访者：你一定很喜欢创业的感觉。

**McKeown：**你懂得😉，这是件很有意思的事情。我们的每一次创业要么放手不做了(被收购了)要么我们的技术过时了。

我们认为我们的工作只比现有的水平略高一些，结果它们在几年后变得十分关键，这使创业变成了一种智力游戏。我发现了从研究到提升实践的途径，并且不断参与到提升实践的尝试中去，试一试再放手。

但这些尝试总是变的不对劲，换个角度来说，工业界对它们其实并不感冒。这就是SDN和OpenFlow的故事，人们都认为我们疯了，但我们已经被它们的魅力深深吸引住了。倘若你拥有坚定你自己看法的勇气，那么你的工作会变的更有意思，因为没人和你做相同的事情。

事实上，大家都认为没有办法做一个性能和固定功能的交换机一样好的可编程交换机，这儿的可编程是我们想要的可编程。

我非常喜欢这些约定俗成，有些时候大家的看法是正确的，但剩下的情况你才是对的。“我感觉到了不对劲。”

摩尔定律使硬件逻辑变的越来越小，我认为在技术不断发展的情况下，可编程交换机和固定功能的交换机之间的性能鸿沟逐渐消失了，几乎可以忽略不计。大家都能够看见“忽略不计”这一点，但就目前交换机的性能、可编程性、及相关领域而言，我们并不认为现在可编程交换机比固定功能的交换机具备了有意义的优势。

- 采访者：因此，我们现在有了了Barefoot公司，旨在通过新提出的P4语言使芯片可编程。P4编程转发平面的能力听起来像是超能力。它使OpenFlow看起来已经过时了。

**McKeown：**哈哈，这可是你说的，我可没这样说。

- 采访者：但是，OpenFlow接下去会怎么样呢？它死了吗？

**McKeown：**我不这样想。目前已经有许多的应用来满足用户的一些非常简单的需求，有可能除了以太网和IPv4方面就没其他的内容了，同时一定需要部署到固定功能的ASIC硬件 - 好吧，OpenFlow的设计允许他们这样干。

所以它并不会很快消失，有可能OpenFlow的兼容性会提升。但是你能够通过P4告诉Tofino(由Barefoot研发，支持P4的可编程芯片)或者其他任意的可编程芯片去支持OpenFlow1.3协议或者其他协议，可编程芯片就能够依照我们的指令要求改变其运行状态，并且和其他的设备进行交互。

我们为Open vSwitch开发了非商业目的的P4前端编译器。Ben Pfaff在VMware做Open vSwitch的相关工作，大约在一年前他在第一次P4会议上探讨过这个问题，他想弄清楚这个玩意怎么实现，此后便一发不可收拾(taken on a life of its own)。现在有相当多的文章描述我们的工作。后来Ben与普林斯顿大学的Jen Rexford教授的一名PhD学生一同开发了一款编译器，并把他们的项目称为Pisces。它目前还不是Open vSwitch的主要分支，不过我想这是早晚的事情。(UPDATE：这位学生的名字是[Muhammad Shahbaz](http://www.cs.princeton.edu/~mshahbaz/)，虽然那时他和Rexford教授一起工作，但是他在普林斯顿的导师是Nick Feamster。)

P4有一点好：你可以从一个P4程序着手或者将其视作一种潜在的能力，将一个描述交换机行为的P4程序编译至装有Tofino的交换机、hypervisor交换机或者其他种类的交换机，这些交换机就会以不同的性能做相同的事情。设备间的协同工作也是一种迫切需要的能力。倘若你想改变这些交换机的行为，那么只要改一下P4程序再重新编译即可。

- 采访者：这就是“一次写入，多次配置”的原则。

**McKeown：**是的，我们在今年的SIGCOMM上发表了一篇论文，讲的是：为什么要做这个？为什么要为Open vSwitch做一个P4的前端编译器？

如今，如果你想改动Open vSwitch的行为，首先你得精通网络协议，其次你还得对内核很熟悉。这个世界上同时具备上述两项的人很少。当然Ben Pfaffs他这样做了，但是并没有多少人把网络协议与内核知识相结合：你必须得去接触多种多样的内核模型，上千行的内核代码，这是非常吓人的工程。

P4是一种浓缩体，在用P4进行开发的时候，你仅需了解网络协议的相关知识，并通过很短的代码 - 有可能是50多行或者几百行 - 一次性描述你想要的东西，并由编译器来操心剩下的事情。只要编译器正常工作，代码中对协议的描述是正确的，那么实现就应该是正确的。所以使用P4来进行开发能够大幅缩短往hypervisor交换机中添加新功能的时间。

甚至你也可以写一个P4程序来实现Middlebox的功能(比如说 四到七层的网络功能)，我认为随着时间的推移这种关键的事情早晚会发生。

我们不一定会把所有的Middlebox的功能都实现一遍，这是想在网络中仿真middlebox的、有强烈目的性的人要干的事情。“我花了好多钱买了一台Middlebox设备，但我只用了它百分之一的功能，哦，为什么我不写一个P4程序呢？”如果我自己有能力写一个P4程序，那么我不仅省了钱还省了管理Middlebox的时间。对于P4来说，这只是它的一部分优势。

四层负载均衡(LB)无疑是一种Middlebox的功能，因为四层LB只是一种稍微聪明些的路由方式，虽然功能很简单但middlebox也实现了它，那么就得在数据平面做这个事情。如今有了Tofino之后，在无需额外开销的情况下就能很轻松的实现各种Middlebox功能，同时还保证了线速处理，从而淘汰掉了所有的Middlebox设备。

人们会认同其他我们没有加以考虑的内容，这很正常。和Intel不会考虑程序员们根据他们的CPU写的Java程序一样，我们不会考虑所有的情况。

- 采访者：那么你认为这几年ONF的角色是什么呢？它的任务是传播SDN，但是这个任务几乎已经完成了。那现在呢？ - ONF是否成为了一个软件组织呢？

**McKeown：**不见得会成为一个软件组织。

首先分辨控制平面和转发平面的意义是非常重要的。就像你所说，大家都已经很清楚SDN了，它已经不再是什么新闻了。

第二件事情是开发可用的开源软件以帮助人们入门。所以大家可以看到ONF越来越频繁地参与到开源的项目中，它能够弥补一些工作并将人们所做的不同的东西结合在一起 - 就像[CORD和ONOS](https://www.sdxcentral.com/articles/news/cord-onos-att/2015/06/)。怎么样才能使所有的组件一起工作呢？如何让事情变得更加简单，以至于如果我是一位网络工程师或者是一名操作员，坐在办公室里就能轻松下载并尝试这些组件？

这些事情一件都还没有发生，我们正在为之努力。目前就像处在Linux开始发展的头三年，这段时间对Linux来说并不完美。所以ONF仍然扮演一个指路人的角色，有无限的工作等着它去做。

- 采访者：突然间确实冒出了好多网络领域的开源软件啊。

**McKeown：**如果只考虑已经发布的开源软件的数量的话(是这样的) - 

- 采访者：这个是开源的缺点，(开源项目的)数量太多了 - 但你得到了你想要的东西！

**McKeown：**没错，但是如果你在十年前把开源和网络结合在一起，人们会说：“哈？这是啥？”

- 采访者：是的，五年前也是这样。

McKeown：现在 - 我维护了一个开源的网络项目的图谱，这个图谱的大小是不断增长的。先是Open vSwitch和其它的一些东西，接着在去年，我观察了所有的开源网络操作系统，[SONiC](https://www.sdxcentral.com/articles/news/microsofts-sonic-may-spell-disaster-switch-makers-not/2016/03/)、[FBoss](https://www.sdxcentral.com/articles/news/big-switch-facebook-ntt-to-demo-an-open-source-switch-os/2015/10/)以及HPE [OpenSwitch](https://www.sdxcentral.com/articles/news/hpes-openswitch-network-os-new-home-linux-foundation/2016/06/) - 这些项目都是从无到有的。

目前有一些工作得到了人们的关注，这是好事。当Linux受到重视的时候，有很多公司投入了大量的工程师做相关的工作。现在，有很多人关注和参与进ODL(The OpenDayLight Project)和ONOS项目中 - 这些项目被逐渐重视了起来。

现在这些项目都能一起跑吗？啊不，还不完美。不过现在人们往这个领域中投入了大量的金钱来实现这个目标。

这个工作很关键但不受待见。就像Linux，每个人都需要一个操作系统，但没人想自己开发。

### 译者信息

译者：福州大学，陈翔。Github：https://github.com/Wasdns

2017年4月19日。
