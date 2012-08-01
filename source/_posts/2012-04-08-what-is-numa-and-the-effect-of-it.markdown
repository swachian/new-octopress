---
layout: post
title: "What is Numa and the effect of it"
date: 2012-04-08 22:38
comments: true
categories: 
- 技术
- linux
- nosql数据库
- script
---


研究mongod的时候，知道了一个关于cpu的概念--numa，但又不知道干嘛的。只知道需要在前面加上numactl来执行:

`numactl --interleave=all mongod --dbpath /data/db --fork  --logpath /data/db.log`

而拜读了这篇[mysql 和 numa架构关联](http://blog.jcole.us/2010/09/28/mysql-swap-insanity-and-the-numa-architecture/)
的文章，让人豁然开朗。

实际上，numa的本质就是牵涉到如何对内存进行分配，是一个在多cpu、多核中引入的概念。

比如，一个cpu时，那么全部的内存自然只有这个u可用。 但是，2个时呢? 如果一个u里面又有多个核心时，该怎么处理呢？

简而言之，numa的方法是让内存按cpu所属的node进行隔离，好处是提高了内存分配的公平性。但是对于mongod mysqld这样会
吃尽内存的应用，这种确保公平的分配方案并不好。因为根本没有其他核心需要用内存，但需要用内存的核心却会吃不饱。所以需要加上参数，使得这种公平性被取消，从而提高整体效能，其实就是发挥出mongod和mysqld的能力。因为这些应用都是单进程多线程的应用。


