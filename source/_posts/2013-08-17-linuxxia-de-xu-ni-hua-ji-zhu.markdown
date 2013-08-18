---
layout: post
title: "Linux下的虚拟化技术"
date: 2013-08-17 20:59
comments: true
categories: 
- 技术
- linux
- 云计算
---

因为要在一台Linux系统中虚拟化一个系统，于是这周接触了一下Linux下虚拟机的内容。  
公司以前一直用的redhat的linux，我所知的虚拟技术仅限于xen和kvm，而且根据一些反馈用的并不是很好。主要体现在资源占用过大，硬盘和内存的消耗都很大，当然公司的服务器硬件配置也有点不够平衡。

然而，在接触了ubuntu的虚拟化后，一下子有茅塞顿开的感觉。首先，windows下我常用的virtualbox就可以在ubuntu下使用。xen和kvm当然ubuntu也是支持的。同时这几种虚拟化技术都可以按命令行的方式使用。其次，ubuntu在安装虚拟化套件方面是十分方便的。主要原因在于它的包要比redhat的时新的多。还有一点，ubuntu比起redhat还是很小巧的。这点在虚拟化的时候显得比较重要。毕竟一台主机的时候，只会安装一个os，如果大2GB那也就只是2GB。一旦云化后，一台主机往往就要4+1个操作系统，在磁盘不富裕的情况下，os的臃肿会成比例的放大。这时候小巧的os就显示出了优势。  
所以我倾向于采用ubuntu server作为云化的主力os。至少应该是虚机的主体。

接下来就是选择何种东西虚拟化了。主要下面3种：

* xen: 国内用的最多，因为历史最长，也有商业化的支持  
* kvm：半虚拟化技术，做在kernel里面，redhat和ubuntu大力支持  
* virtualbox: 是的，其实这可能是最好用的linux虚机软件  

性能方面，根据[kvm vs Virtualbox](http://www.liangsuilong.info/?p=675) 和 [Ubuntu11.10 Xen Kvm Virtualbox比拼](http://server.zol.com.cn/257/2575328.html)，总体而言kvm的性能最佳，大文件比virtualbox有所不如。而且从未来规划来看，redhat和ubuntu普遍倾向于支持kvm。但是，virtualbox有两大优势：1.使用是图形化的界面，很简单； 2.与kvm和xen都专注于cpu性能不同，virtualbox的图形化性能要比另外两个都强许多。不过vbox实际上是基于qemu改进的，kvm-qemu也是一个组合。所以，普通用用的情况下可以直接上virtualbox。

顺手又了解了一些vnc的内容。vnc其实只是一个传送图形界面的协议，经典的client和server端模型，但具体的GUI还需要由其他东西实现。可选的有`xfce4`和`ubuntu-desktop`，前者小巧不少大约200MB，后者如果是server上安装则要1GB以上了。总体而言不如ssh方便，占用资源也多不少，不过在必须使用图形化界面的时候，都还是不错的选择。

