---
layout: post
title: "Arp 绑定"
date: 2012-04-23 11:46
comments: true
categories: 
- linux
---

通过ftp备份老是报告登录失败。检查过后，网管告知我们是ip被抢。照理是需要网管执行纪律的，但是这个我就不越俎代庖，反正
解决问题为主。而且即便执行纪律也不保证下次就不会发生。于是想起来直接绑定arp和ip，这样可以**根除**此类问题。

主要参考了[Linux下绑定IP和MAC地址，防止ARP欺骗](http://www.xxlinux.com/linux/article/network/security/20070809/9234.html).

1.检查当前arp

```bash
[root@ngntest ~]# arp -a
? (192.168.203.22) at 00:A0:D1:E5:D1:A9 [ether] on eth0
```

2.建立一个mac->ip的对应文件： ip-mac, 将IP和MAC写入才文件

```bash
echo '192.168.202.19 00:26:b9:4c:8d:af' > /etc/ip-mac
```

3.手动执行绑定

```bash
[root@ngntest ~]# arp -f /etc/ip-mac
``` 

上面的内容也可以存入`/etc/rc.d/rc.local` ,这样可以实现开机自动绑定。
