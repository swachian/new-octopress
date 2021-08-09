---
layout: post
title: "openwrt n56u 和iptv"
date: 2016-04-05 12:14
comments: true
categories:
- 技术
- 生活 
---

四年以前写的[上海电信IPTV的VLAN ID和通过交换机连接两路IPTV](/blog/2012/02/20/the-way-to-link-to-iptv-in-shanghai-through-vlan/)，而由于4k高清IPTV机顶盒的推广，
当时的内容已经有些不合时宜。尽管，用一个交换机还是可以实现连接两路iptv。

区别主要在于新的4k高清机顶盒同小红等盒子一样，需要双平面才能跑得起来。所谓双平面就是在专网之外机顶盒也要能够连接公网。
这个变化其实是带来一大好处的，即通过一个路由设备接光猫的一个口子，也可以让iptv和公网业务同时跑起来。下面记录一下操作过程。

### openwrt

首先，这么灵活的配法，当前asus netgear等原厂的固件是不支持此种功能的，所以需要第三方固件，如openwrt dd-wrt。我选择了openwrt，是因为其官网支持asus-n56u路由器。
[官方链接](https://wiki.openwrt.org/toh/asus/rt-n56u) ，可以从前面这个链接获得操作过程和固件。注意下载`squashfs-factory.bin `，不要下载chaos版。我就误下了chaos版，导致只能采用reset的办法重新装回了华硕的固件。openwrt很贴心的一点就是在网页里提供了恢复固件的操作步骤

```sh
Download & Install the asus "Firmware Restoration" from asus website
Download the factory image from asus
Enter Recovery Mode
Unplug Router
Hold Reset Button and Plug in Router
Release button when front LED flashes slowly
Use the following to set up your TCP/IP settings:IP address: 192.168.1.x Subnet mask: 255.255.255.0
Select firmware *.trx and upload
```

要点是把本机的ip设置成192.168.1.2,而且如果本机有多块网卡（包括虚拟网卡）则只保留一个连接路由器lan口的网口活跃。这样华硕的固件才
明确会打开这个网口并同已进入恢复模式的路由器相连。有了这个恢复模式存在，意味着asus的这款路由器基本是刷不死的。

安装完openwrt，设置好基本的wan口，我是采用的dhcp方式获取wan地址，就可以进入配置iptv vlan的过程了。

### 关于4k高清机顶盒获取公网和专网IP的流程

参考[上海电信光猫一体机配合Openwrt拨号正常使用OTT 4K IPTV](https://www.ydkfblog.com/?m=201602)，
找到了iptv dhcp的流程
![image](/images/openwrt/4kiptvdhcp.png)

看清流程后，就可以知道：
1. 要先让4k iptv机顶盒接入公网  
2. 路由器要支持DHCP-Option：125  
3. 路由器要支持vlan 85的进出

公网配置是基础，剩余两点的配置可以归纳为

> 1. 接在自备路由器上时，将路由器WAN口、CPU口、接IPTV的口 一起新建一个VLAN 85，3个端口全部为tagged

> 2. `/etc/dnsmasq.conf`中要加入`dhcp-option-force=125,00:00:00:00:1b:02:06:48:47:57:2d:43:54:03:05:48:47:32:32:31:0a:02:20:00:0b:02:00:55:0d:02:00:2e` ,即对Option 125的支持

做完这些之后，至少目前中兴的机顶盒是全面支持了。

配置附录

/etc/config/network
```
config switch                                                                                                                                                                        
        option name 'switch0'                                                                                                                                                        
        option reset '1'                                                                                                                                                             
        option enable_vlan '1'                                                                                                                                                       
        option enable_vlan4k '1'                                                                                                                                                     
                                                                                                                                                                                     
config switch_vlan                                                                                                                                                                   
        option device 'switch0'                                                                                                                                                      
        option vlan '1'                                                                                                                                                              
        option ports '0 1 2 3 8t'                                                                                                                                                    
                                                                                                                                                                                     
config switch_vlan                                                                                                                                                                   
        option device 'switch0'                                                                                                                                                      
        option vlan '2'                                                                                                                                                              
        option ports '4 8t'                                                                                                                                                          
                                                                                                                                                                                     
config switch_vlan                                                                                                                                                                   
        option device 'switch0'                                                                                                                                                      
        option vlan '85'                                                                                                                                                             
        option vid '85'                                                                                                                                                              
        option ports '1t 2t 4t 8t'    
```

/etc/dnsmasq.conf
```
#cname=bertand,bert
dhcp-option-force=125,00:00:00:00:1b:02:06:48:47:57:2d:43:54:03:05:48:47:32:32:31:0a:02:20:00:0b:02:00:55:0d:02:00:2e
```
