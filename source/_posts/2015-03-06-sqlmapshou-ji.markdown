---
layout: post
title: "SQLMAP手记"
date: 2015-03-06 16:37
comments: true
categories: 
- 神器
- 技术
---

[SQLMAP](http://sqlmap.org/)确实是一个神器，而[这篇文章](http://www.binarytides.com/sqlmap-hacking-tutorial/)则从判断是什么库开始，
历经获取dbs，获取单个db中的tables，获取单个table里面的字段，直至获取每个记录每个字段的数据，做了一步一步细致的讲解。

其实SQLMAP的用法真的挺暴力的。基本通过穷举的办法，根据页面返回内容的变与不变来判断输入的条件是否成立，以此来断定某些信息是否存在。
很脏很暴力的做法。

