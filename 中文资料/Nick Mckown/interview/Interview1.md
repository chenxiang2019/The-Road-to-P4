# Barefoot Network - McKeown: OpenFlow, P4 以及可编程网络（一）

## 摘要

离我们采访[Barefoot Networks公司](https://www.sdxcentral.com/listings/barefoot-networks/)的首席科学家Nick McKeown教授已经过去了一段时间了。

经常访问[SDxCentral](https://www.sdxcentral.com/cloud/definitions/software-defined-everything-sdx-part-1-definition/)和[SDNLAB](http://www.sdnlab.com/)的读者们都知道接下来摘要的内容是什么：McKeown教授和加州大学伯克利分校的Scott Shenker教授的研究创造了[软件定义网络(SDN)](https://www.sdxcentral.com/sdn/)与[OpenFlow协议](https://www.sdxcentral.com/sdn/definitions/what-is-openflow/)；他们与Martin Casado一起创立了[Nicira Networks](https://www.sdxcentral.com/listings/nicira-acquired-by-vmware/)公司。

Nicira现在是VMware公司的一部分，这意味着McKeown教授已经品尝过三次看着由自己创立的公司被收购的滋味了。

现在，他正在站在第四次的征程上。在本周Barefoot Networks披露了他们的计划(开发一种可编程的交换机芯片，以及推动P4语言的发展)，与此同时，SDxCentral迅速前往了Palo Alto(美国加州帕罗奥图市，Barefoot Networks公司和Stanford University所在地)。Barefoot的办公楼坐落于毗邻斯坦福大学的一条住宅区的街道上，楼前悬挂着他们的标识，门上写着：“请进：一群非常棒的人正在里头工作。”

继续往下读吧，你将会了解到McKeown教授的创业经历，他对P4的构想，以及由他负责的OpenFlow的现状。

## 采访

- 你一定很喜欢创业的感觉。

McKeown：你懂得😉，这是件很有意思的事情。我们在开始经营每一家创业公司的时候要么放弃要么假定该技术将会被放弃[?]。

我们在工作的时候认为我们只是比Horizon稍微先进一些，结果在几年后就变成了大麻烦。这变成了很有意思的智力游戏，我逐渐掌握了从研究中提升实践能力的方法，并不断参与到提升实践能力的尝试中去。

但这些尝试总是变的不太对劲，换个角度来说，事实上工业界对它们并不感冒。这是SDN和OpenFlow的故事，人们都认为我们疯了，但我们已经被SDN和OpenFlow的魅力所深深吸引。倘若你拥有坚定你自己看法的勇气，那么它会使你的工作更有意思，因为这意味着没人和你做相同的事情。

事实上，大家都认为没有办法做一个性能和固定功能的交换机一样好的可编程交换机，这儿的可编程是真的我们想要的可编程。

我很喜欢这些约定俗成，有些时候大家的看法是正确的，而剩下的情况你的看法才是对的。“我感觉不对劲。”

摩尔定律使硬件逻辑变的越来越小，我认为在技术不断发展的情况下，可编程交换机和固定功能的交换机之间的性能鸿沟逐渐消失了，几乎可以忽略不计。大家都能够看见“忽略不计”这一点，但就目前交换机的性能、可编程性、及相关领域而言，我们并不认为现在在可编程交换机与固定功能的交换机之间已经具备很有意义的差别。

- 因此，我们现在有了了Barefoot公司，旨在通过新提出的P4语言使芯片可编程。P4编程转发平面的能力听起来像是超能力。它使OpenFlow看起来非常古怪。

哈哈，这可是你说的，我可没这样说。

- 但是，OpenFlow接下去会怎么样呢？它死了吗？

我不这样想。目前已经有许多的应用来满足用户的一些非常简单的需求，有可能除了以太网和IPv4方面就没其他的内容了，同时一定需要部署到固定功能的ASIC硬件 - 好吧，OpenFlow的设计允许他们这样干。

所以它并不会很快消失，有可能OpenFlow的兼容性会提升。但是你能够通过P4告诉Tofino(由Barefoot研发，支持P4的可编程芯片)或者其他任意的可编程芯片去支持OpenFlow1.3协议或者其他协议，可编程芯片就能够依照我们的指令要求改变其运行状态，并且和其他的设备进行交互。

我们为Open vSwitch开发了非商业目的的P4前端编译器。Ben Pfaff在VMware做Open vSwitch的相关工作，大约在一年前他在第一次P4会议上探讨过这个问题，他想弄清楚这个玩意怎么实现，此后便一发不可收拾(taken on a life of its own)。现在有相当多的文章描述我们的工作。后来Ben与普林斯顿大学的Jen Rexford教授的一名PhD学生一同开发了一款编译器，称为Pisces。它目前还不是Open vSwitch的主要分支，不过我想这是早晚的事情。(UPDATE：这位学生的名字是[Muhammad Shahbaz](http://www.cs.princeton.edu/~mshahbaz/))，虽然那时他和Rexford教授一起工作，但是他在普林斯顿的导师是Nick Feamster。)

P4有一点好：你可以从一个P4程序着手或者将其视作一种潜在的能力，将一个描述交换机行为的P4程序编译至装有Tofino的交换机、hypervisor交换机或者其他种类的交换机，这些交换机就会以不同的性能做相同的事情。设备间的协同工作也是一种迫切需要的能力。倘若你想改变这些交换机的行为，那么只要改一下P4程序再重新编译即可。
