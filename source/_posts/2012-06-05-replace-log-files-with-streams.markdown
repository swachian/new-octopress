---
layout: post
title: "Replace log Files with Streams"
date: 2012-06-05 12:16
comments: true
categories: 
- 技术
- 云计算
---

早前读过adam的[Logs Are Stream, Not Files](http://adam.heroku.com/past/2011/4/1/logs_are_streams_not_files/), 但当时是阅读
整个博客，所以对细节不甚了了。今天为了写另一片关于计算模型的文章，顺便又看了一下此文，有新的收获。

日志是无穷无尽的流，而不是文件。文件只是流的某种最终形式。因为流是可以很容易的被其他程序继续利用（作为输入），而文件相对就困难一些。
总之，流更适合对分布式系统的集中处理。

### 站在开发的角度  
以开发的角度来看，输出的内容无非就是stdout stderr，以及日志文件。但实际上文件和std很容易引起混淆。个人一直认为最直接最有用的
莫过于`puts` `cout` `System.out` `printf` ，logger.info logger.debug我并没有发现到底有多少作用。对于运行在服务端的程序，这
实在显得不是很有必要。stderr和stdout就足够用来区分了。

### 站在部署的角度
以部署的角度来看，全部当做stream自然好处很多。可以统一的重定向到文件或者syslog，或者其他更现代化的日志系统。只要这个系统能接受
一个input stream。

结论就是，能用流就用流吧，日志文件实在是很靠后的选择。

### 几种技巧和工具  
1. [syslog](http://www.cyberciti.biz/tips/howto-linux-unix-write-to-syslog.html)   
  syslog是要搭配bash的命令`logger`使用的。
  ```sh
    mydaemon | tee /var/log/mydaemon.log | logger
  ```
tee是让流再复制一份，logger则是linux自带的网syslog发消息的程序。发的目的地可以是远端的也可以是本地的，基于UDP协议。

2. [Scribe](https://github.com/facebook/scribe/wiki)  
  则是facebook开源的日志工具，用法类似syslog，只是可以更多的组装，而且也提供了可以写日志的HTTP接口。

3. [Logplex](https://github.com/heroku/logplex)  
  这是heroku的日志系统。基于erlang编写。顺便说一句，erlang和js都是很好的在语言级别实现了对Event-Driven I/O的深度整合。
 存放库是Redis这个NoSQL数据库。根据heroku的架构，个人猜测是在启动dyno时，将日志信息重定向了给Logplex的客户端，客户端
再将内容加上app_id等信息后发给Logplex的服务。这是使用这项服务一个[帮助](https://devcenter.heroku.com/articles/scaling#process_formation).

4. Upstart launchd  Systemd 
  这是Ubuntu OSX 下替换传统的linux的init.d，负责启动服务的后台库。
  