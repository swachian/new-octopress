---
layout: post
title: "The difference between MapReduce and Hadoop"
date: 2012-03-27 12:42
comments: true
categories: 
- 技术
- 云计算
---

简单地说，MapReduce是一种计算模型，也就是一种设计；而Hadoop则是这种模式的Java实现，由Apache发行。
2004年的时候，google发布了MapReduce的论文，并给出了一个C++的实现。此后，很多种语言都实现了MapReduce模式，比较有名的有，
Hadoop(java), Skynet(ruby)等。  
而Hadoop除了这个计算模型外，还包括分布式数据库和分布式内存存储两大部分内容。

MapReduce实际上是切分+管道技术。可以表述称 Map | Reduce。
通过Map，将要处理的数据转换成[key, value], 再管道给Reduce继续进行处理。 
