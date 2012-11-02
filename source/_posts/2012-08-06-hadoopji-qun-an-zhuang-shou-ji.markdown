---
layout: post
title: "hadoop集群安装手记"
date: 2012-08-06 16:43
comments: true
categories: 
- 技术
- 云计算
---

ssh的使用公钥登录配置

```bash
ssh-keygen
ssh-copy-id -i ~/.ssh/id_rsa.pub 192.168.203.198
```


=======
**数据源的输入才是Hadoop方便地方**

定义一个数据源，可以是数据库也可以是文件夹，当然最好是hadoop的分布式文件夹  
读取数据的划分是hadoop自动进行的，开发只需要定义要数据源就行  
比如一个10000行的记录，如果有10个计算进程去做的话，hadoop会自动把数据切成1000行  
然后你写的代码就是读入一行数据后要做些什么操作。比如说算总值或者平均值的话，就把数字全加起来，这个过程叫Map  
然后10个计算进程都算出来了，需要汇总结果，汇总的进程就叫reduce  
map/reduce之间传输的内容就是map的输出，一般也是一个key value，但是这里面具体赛什么是随意的  



# 文献

[创建一个节点](http://www.michael-noll.com/tutorials/running-hadoop-on-ubuntu-linux-single-node-cluster/)  
[创建集群](http://www.michael-noll.com/tutorials/running-hadoop-on-ubuntu-linux-multi-node-cluster/)  

