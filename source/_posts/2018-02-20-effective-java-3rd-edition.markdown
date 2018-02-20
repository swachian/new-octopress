---
layout: post
title: "Effective Java 3rd Edition"
date: 2018-02-20 23:01
comments: true
categories: 
- 技术
- java
---

「Effective Java」第三版在过年期间出版了，对比第二版主要补充了`lambda`和`stream`的内容，序列化方面
则希望大家不要再使用java原生的内容，其他变化不大。但是，和第一版比较起来，变化就很大了。除上述内容外，
第二版较第一版增加了`autoboxing/autounboxing`，`enum`, `annotation`,`generic programming`, 整个的编程建议也从57条增长到78条再到第三版的90条。

借用作者在第三版的前言，在1997年，Java的创始者Gosling描述java是一种“蓝领语言”（blue collar language），意味着当时的java相当简单（pretty simple）。与此同时，C++的创始人Stroustrup则警告所谓java的简单和其他很多新语言一样，只是误解以及功能上的不完善，随着时间的流逝，Java在尺寸和复杂性上都将大规模成长。不得不说，三者都是大师，而Java虽然依旧还是工业级的语言，但复杂度和规模已经较我十几年前初学时多了许多。或许，也因此大学里正在寻求一门其他语言来取代Java的教学地位吧。

此书非常经典，虽然作者说不用从头到尾通读，但是，建议还是全部都读一遍，甚至可能需要反复阅读并加以实践。比如其中的primitives和boxed primitives，即`int`和`Integer`，其间的坑在新项目中就踩过，而之前阅读后只是尽量不去用Integer这些boxed的类型，而这个新项目中由于前后交互的需要必须使用了Integer，于是就把`==`, 内容为`null`的坑都踩到了。

开卷有益，何况经典！
