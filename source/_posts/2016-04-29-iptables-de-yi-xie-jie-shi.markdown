---
layout: post
title: "iptables 的一些解释"
date: 2016-04-29 09:45
comments: true
categories: 
- linux
---

在**物理机**部署的年代里，组网通常是分层而建。例如所有的服务器都接到二层交换机组成**内网**，随后交换机上联三层交换机及防火墙。彼时，防火墙通常由专用
的设备承担。所有的路由规则、端口开放等也均在网络设备上进行配置。对于服务器而言，通常最简单的做法就是关闭iptables，在内部实现完全互通，而把防护任务交给专用设备。

然而转到**云部署**的年代，专用的网络设备大都收归云所有，此时虽然还有内网的概念，但已经模糊，从而要求把防火墙建在主机上。做到几个域的隔离。

iptables的配法有命令行和配置文件，此处以配置文件`/etc/sysconfig/iptables`为例，说明一些概念。

对于安全类的防护,集中在`*filter`上，nat 等是管映射和路由的

```
*filter
:INPUT ACCEPT [1194191:146127015]
:FORWARD ACCEPT [159938:8304428]
:OUTPUT ACCEPT [1044829:126818322]
```

上面这段代码表示对三种包的处理状态及已处理的包和字节数量。
`INPUT`就是输入的包，`ACCEPT`表示默认都可以进入，如果设置成`DROP`就是都废弃输入包了。如果主要以开白名单的方式，`INPUT后`可以接`DROP`。中括号里面的数字，冒号前是包数量统计，冒号后是字节数统计。  
`FORWARD`表示转发，`OUTPUT`表示输出访问，通常这两个可以设置成`ACCEPT`即表示允许。  
这3个表示的是基础的规则，类似默认路由，优先级是最低的。

```
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

随后就是很重要的这一段。这段的含义表示对连接状态是`ESTABLISHED`, `RELATED`的链接全部放行。iptables中的链接共有4种，`established`表示链接已建立，`related`的含义是由已建立的链接产生的链接，此外还有`new`和`invalid`两种链接状态，
其实这段话的含义也可以理解成`invalid`链接放弃，`new`状态之外的连接则允许通过。
这个指示关键的原因在于，比如本机设置了禁止外网访问本机的各个端口，同时本机作为客户端访问了另一个外网服务，那么外网服务的响应信息允许被接收。否则，就会面临只有一个单工链路的情况。


```
-A INPUT -d 192.168.1.202 -p tcp -m tcp --dport 80 -j ACCEPT
-A INPUT -d 192.168.1.202 -p tcp -m tcp --dport 8080 -j ACCEPT
-A INPUT -d 192.168.1.202 -p tcp -m tcp --dport 8081 -j ACCEPT
-A INPUT -d 192.168.1.202 -p tcp -m tcp --dport 22 -j ACCEPT
-A INPUT -d 192.168.1.202 -p tcp -m tcp --dport 21 -j ACCEPT
-A INPUT -d 192.168.1.202 -p tcp -m tcp --dport 20 -j ACCEPT
-A INPUT -d 192.168.1.202 -s 10.3.1.0/24 -j ACCEPT
-A INPUT -d 192.168.1.202 -j DROP

-A INPUT -d 10.10.10.222 -j DROP
```

这个机器有两块网卡，分别有两个地址`192.168.1.202`和`10.10.10.222`,对于后者，只允许从这个口子发出包以及收入已建立连接的包（通过上面的 `-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT`)。  
而对于前一个地址，则打开了http相关的80 8080 8081端口，开放了ssh和ftp端口，并对来自10.3.1.0网段的全部IP开放访问权限。

对于包的动作有ACCEPT DROP 和REJECT，后两个都表示拒绝，只是REJECT是明确拒绝，DROP只是沉默不答。

对于iptables，简单的用用，安全防护做到这样也就够了。








