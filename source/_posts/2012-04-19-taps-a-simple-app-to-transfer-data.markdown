---
layout: post
title: "Taps： 一个导数据的工具 "
date: 2012-04-19 10:21
comments: true
categories: 
- 神器
---


在railscast上看到了一个介绍导入导出数据的工具[taps](https://github.com/ricardochimal/taps).

最大的亮点在于:

1. 是用起服务的方式来完成。先针对一个数据库启动一个server监听在5000端口，随后在它处启动一个脚本导数据；
2. 可以跨数据库导入导出。实际上中间是用到了[sequel](sequel.rubyforge.org/)这个ruby的Orm框架，所以理论上应该是只要有adapter的数据库就都能被匹配。

使用也非常之简单与直接

```sh
$ gem install taps
$ taps server postgres://localdbuser:localdbpass@localhost/dbname httpuser httppassword
$ taps pull postgres://dbuser:dbpassword@localhost/dbname http://httpuser:httppassword@example.com:5000
```
