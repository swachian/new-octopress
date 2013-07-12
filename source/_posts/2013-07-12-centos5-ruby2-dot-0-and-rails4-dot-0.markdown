---
layout: post
title: "CentOS5 Ruby2.0 and Rails4.0"
date: 2013-07-12 12:55
comments: true
categories: 
- ruby
- linux
- rails
---

升级了一个很小的rails应用到4.0，原先使用的版本ree1.8.7 + rails3.1 。因为应用很小，也没使用很多插件，所以git checkout一个branch之后，用rails new生成新的目录完全替换掉老的文件。然后用`git diff`对一个一个目录或者文件进行比对与合并。整个过程下来，发现rails默认生成的文件，3.1和4.0的区别并非很大。

这个过程也就是只有几个小时，半天不到的时间就让应用可以跑起来了。本地测试了一下，写入数据库、查询、写入文件等都没什么问题。随后自然就是部署。

但此时，问题来了. 本地开发的环境是这样的：

* Ubuntu 12.04
* gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) 
* ruby 2.0.0p195 (2013-05-14 revision 40734) [x86_64-linux]
* rails 4

而部署环境是这样的：

* CentOS release 5.4
* gcc 版本 4.1.2 20080704
* ruby 2.0.0p247 (2013-06-27) [i686-linux]
* rails 4

在本地运作良好的rails4应用，部署到生产环境后发生下面两个异常：

1 `rake db:migrate`每次只能成功一个migrate，但经反复执行后，能够migrate完整
```
SQLite3::SQLException: SQL logic error or missing database: INSERT INTO "schema_migrations" ("version") VALUES (?)
```
2 开发环境下正常，生产环境下会报告`nil?`在某个object上不存在。



为此，则折腾掉了很多的业余时间。

怀疑过是Gem的版本问题，怀疑过是ruby版本的问题,也怀疑过是ruby编译问题。

针对第一种可能，重新生成了一个rails应用，执行的结果照旧。  
为了第二种可能，使用了ruby2.0.0p195，异常依旧；换成ruby1.9.3，但发现有个atom的gem都不能bundle上去。  
随后，针对第三个可能，不惜**升级的了CentOS到5.9**(`yum upgrade`),为此下载了600MB的更新包。   
又重新编译安装了ruby2.0.0p0, 哦?!，世界太平了。虽然第一个异常依然，但第二个异常没了，应用是能够跑的起来了。
之后，再重新编译另外两个ruby版本就都可以正常工作了（第一个问题还是在的）。

由此可见，这是一个和gcc版本、os版本及ruby版本都相关的bug。

### 教训

新版的ruby或Rails同CentOS接触的并不好，如果要少麻烦的话，APP的OS还是应该选择Ubuntu。从生态的情况来看，这个责任只能怨CentOS支持的内核、gcc、lib库都过于老旧了。  
之所以这么说，不单单是因为在ruby上碰到这种要比在ubuntu上麻烦的多的情形。从七周七语言的情况看，CentOS即使是CentOS6，也不支持对Haskell的安装，在安装其他语言时，多多少少都会遇到编译麻烦的问题。  
CentOS是基于Redhat的，以稳定（老旧）为荣。而APP则是迅速发展的，因此二者极其容易脱节。所以，APP服务器首选Ubuntu。

### 题外话

从对OS的依赖少这点来看，Java确实做了件很漂亮的事情。一个编译好的jdk文件，可以在几乎全部的主流linux下解压，然后即可使用。部署时也不用担心底层OS是什么实现。所以，如果是Java的应用，继续用CentOS也是不会有很多坑的。
