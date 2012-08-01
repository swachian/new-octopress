---
layout: post
title: "hubot and socket.io"
date: 2012-06-26 22:05
comments: true
categories: 
- nodejs
---

这几天搭了hubot, 跑起了gtalk,也选了一些script的.这玩意确实挺有趣.本质上是一种命令行,但又增加了新的特色.
最大的突破在于实现了通过IM工具来提交交互命令.与此同时,IM上的命令行不在只有一个人可见,想想console,而是变得一群人可以一起参与,很多乐趣
也就来自其中.而命令行的好处大家都知道,就是快.而结合在im里的命令行比普通的更快,因为不需要登录,不需要启动命令.试想下面的步骤哪个响应更快:

```sh
telnet xxx
coffee
> 3+2=?
```

vs 

```
eval 3+2
```

后者显然便捷许多. 

在研究redis的时候,顺手看了一个chat room的例子, 尽管例子本身有很大的问题,却也由此接触了[socket.io](http://socket.io).
Socket.io确实让人找回了socket编程的感觉, 而且应该说这玩意是通过浏览器进行监控、日志浏览的必备工具.相当有意义的技术.  
而且`socket.io-client`也很有意思. 
