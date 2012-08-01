---
layout: post
title: "NoSql databases notes"
date: 2012-03-20 21:35
comments: true
categories: 
- 技术
- nosql数据库
---

部门决定在一个日志数据分析系统中不使用oracle或者mysql，于是开始寻找非关系型数据库的替代品。核心需求有以下几个：  

* 大数据量写入，一小时10G
* 数据量极大的查询
* 并发数不大，即写入和读取都不是高并发的

发现此类数据库普遍从3年前开始流行，主要实现这些数据库的编程语言是下面这些，其实从中也可以看出各种库所擅长的内容，有些强项在存储，有些在路由，即分布式。

* C 
  * MongoDB　 (文档存储)
  * Redis (key-value)
* Erlang & C （erlang管路由，c管数据存储的结构）
  * Riak (key-value)
  * CouchDB (文档存储)
  * Membase
* java (分布式为主，路由功能和存储均不错)
  * Cassandra [kə'sændrə]
  * HBase
  * Neo4j
  * SenseiDB (from [LinkedIn](http://www.infoq.com/cn/news/2012/03/senseidb-1-0-0?utm_source=bshare&utm_campaign=bshare&utm_medium=sinaminiblog&bsh_bid=85617203))




 
参考资料:  
<http://blog.serverdensity.com/2011/07/21/mongodb-vs-cassandra>  
<http://kkovacs.eu/cassandra-vs-mongodb-vs-couchdb-vs-redis>  
<http://blog.evanweaver.com/2009/07/06/up-and-running-with-cassandra>      
<http://articles.businessinsider.com/2009-11-06/tech/30063107_1_database-stores-documents-hot-backup/2>  

[Mongodb](http://www.mongodb.org/)
===


保证海量数据存储的同时，具有良好的查询性能。  
Schema Free

Mongodb总体介绍
<div style="width:425px" id="__ss_9209804"> <strong style="display:block;margin:12px 0 4px"><a href="http://www.slideshare.net/ChrisEdwards357/introduction-to-mongodb-9209804" title="Introduction to MongoDB - Austin Code Camp 2011" target="_blank">Introduction to MongoDB - Austin Code Camp 2011</a></strong> <iframe src="http://www.slideshare.net/slideshow/embed_code/9209804" width="425" height="355" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe> <div style="padding:5px 0 12px"> View more <a href="http://www.slideshare.net/" target="_blank">presentations</a> from <a href="http://www.slideshare.net/ChrisEdwards357" target="_blank">Chris Edwards</a> </div> </div>

### 安装、建库、索引与备份

``` bash
# 下载解压
wget http://downloads.mongodb.org/src/mongodb-linux-x86_64-2.0.4.tgz
tar xzf mongodb-src-r2.0.4.tar.gz

# 创建数据目录
mkdir -p /data/db

#启动
./mongodb-xxxxxxx/bin/mongod

#shell访问
./mongodb-xxxxxxx/bin/mongo
```

mongodb可以不事先建schema和表，会在第一次插入数据时自动创建

mongodump 用于备份  

### 开发工具及使用方式
mongodb shell是基于js的语法  
``` bash
> use mydb
> show dbs
```

* [Java](http://www.mongodb.org/display/DOCS/Java+Tutorial)  
  <div style="width:425px" id="__ss_3924691"> <strong style="display:block;margin:12px 0 4px"><a href="http://www.slideshare.net/ecspike/java-development-with-mongodb" title="Java development with MongoDB" target="_blank">Java development with MongoDB</a></strong> <iframe src="http://www.slideshare.net/slideshow/embed_code/3924691" width="425" height="355" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe> <div style="padding:5px 0 12px"> Mophia( a lightweight type-safe library for mapping Java objects to/from MongoDB)值得使用</div> </div>
* [Ruby](http://www.mongodb.org/display/DOCS/Ruby+Language+Center)  
* [C](http://www.mongodb.org/display/DOCS/C+Language+Center)

### 数据模型

* database
* collection = table
* document = row
* field = column
* index

### 生产环境配置要点(部署)

* Linux File Systems

MongoDB uses large files for storing data, and preallocates these. These filesystems seem to work well:

ext4 ( kernel version >= 2.6.23 )
xfs ( kernel version >= 2.6.25 )

* NUMA (一种多核cpu的内存绑定结构，同mongodb和mysql的兼容都不好)
``` bash
numactl --interleave=all /home/mongodb/mongodb-linux-x86_64-2.0.4/bin/mongod --fork --logpath=/data/log/log
echo 0 > /proc/sys/vm/zone_reclaim_mode

kill -2 {proccess_id} # kill -2 = ^C
```

### 监控

[Cassandra](http://cassandra.apache.org/)
===


###开发工具的支持

使用[Thrift](http://thrift.apache.org/)作为支持多语言的开发工具。它本身也是facebook开源出来的东西。

###安装与教程

1. [安装GettingStarted](http://wiki.apache.org/cassandra/GettingStarted)，是安装、配置、启动的上手指南，类似启动一个tomcat；
2. [command line 基础](http://wiki.apache.org/cassandra/CassandraCli), 包含了基本的建表、索引等实例；
3. [Cassandra for Rails的ppt](http://pablete.org/2009/11/cassandra-and-ruby/)  
  <div style="width:480px;text-align:left" id="__ss_2834738">
    <a style="font:14px Helvetica,Arial,Sans-serif;display:block;margin:12px 0 3px 0;text-decoration:underline;" href="http://www.slideshare.net/pablete/cassandra-for-rails" title="Cassandra for Rails">Cassandra for Rails</a>
    <object style="margin:0px" width="480" height="355">
      <param name="movie" value="http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=cassandrarails2009-100105132552-phpapp01&stripped_title=cassandra-for-rails" />
      <param name="allowFullScreen" value="true"/>
      <param name="allowScriptAccess" value="always"/>
      <embed src="http://static.slidesharecdn.com/swf/ssplayer2.swf?doc=cassandrarails2009-100105132552-phpapp01&stripped_title=cassandra-for-rails" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="355"></embed>
    </object>
  </div>

###其他优秀特性：


* 比key-value多，比Mongodb做的少。  
* Range queries
* List datastructures , for per-user indexex
* Distributed writes 
* cluster里可以指定写的node的数量W，和读的node数量R，以此来实现整个node

###生产cluster搭配要点:

* 硬件
   * 不需要raid，可以多个节点，即便在同一台机器上，同时运行。
   * 16GB的内存
* 配置
  * 16GB的内存下，配3个节点，Jvm heap使用4GB


在/var/lib 下存放data， log， 和  saved_caches

### 数据模型的概念

* keyspace = schema;  
  keyspace仅仅是用来决定replication的次数，而不要求所有的内容都关联在一个schema中。 
* column family = table  
    由row key +　Columns组成，key可以是自然key也可以是uuid之类的key  
  column 由name, value 和timstamp组成，其中value可以为空
  key默认就有primary index
* 特殊的column  
  Expiring 可以写入过期时间，用于消息失效之类的应用  
  Count 技术的事务性有Cassandra自己保持  
  Super  其value是(super) columns的集合，但是该value的全部内容要序列化  
* 对value索引  
     即二级索引，主要起类似位图索引的作用
 
[一个Twissandra 使用cassandra的例子](http://www.datastax.com/docs/0.7/data_model/twissandra)

### Cassandra 小结

目前分析下来，倾向于使用Cassandra. 理由是，极致的可扩展性，是可以水平扩展的数据库；Java编写，利于改造利用；开发者在去facebook前，也是Amazon Dynamo的开发者；
已知的已经有300TB使用400台服务器的案例。  
twitter的人写的架设材料 http://blog.evanweaver.com/2009/07/06/up-and-running-with-cassandra/  
但其缺点是过于虚拟化以及理想化，所以实际应用中并不是很稳定，digg和twitter都面临骑虎难下的局面。

 