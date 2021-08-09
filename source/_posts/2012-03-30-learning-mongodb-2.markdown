---
layout: post
title: "Learning Mongodb (2)"
date: 2012-03-30 17:03
comments: true
categories: 
- 技术
- nosql数据库
- 读书笔记
---

系列链接：  

1. [mongodb基础](/blog/2012/03/29/learning-mongodb-1/)
1. [尝试分布式及复制  （sharding and replication)](/blog/2012/03/30/learning-mongodb-2/)
2. [部署和管理](/blog/2012/04/17/deployment-and-administration-for-mongod/) 

**Replica sets** vs **Master-Slave**  
目前已全面倒向支持前者。  前者是后者的加强，但限制是最大的1个set集群只有**12**个节点。

### Replica sets

由3个nodes组成：  

1. mongod
2. mongod
3. arbiter（仲裁者）
4. 其实未必需要arbiter，只是要求至少3个mongod的节点，arbiter只是不用写数据

架设代码：  
``` bash
mkdir /data/node1
mkdir /data/node2
mkdir /data/arbiter 

numactl --interleave=all mongod --replSet pcdm --dbpath /data/node1 --port 40000 --oplogSize 5000
numactl --interleave=all mongod --replSet pcdm --dbpath /data/node2 --port 40001 --oplogSize 5000
numactl --interleave=all mongod --replSet pcdm --dbpath /data/arbiter --port 40002 --oplogSize 5000

./bin/mongo ngntest:40000
> rs.initiate()
> config =  {_id: 'pcdm', members: [
                          {_id: 0, host: 'localhost:40000'},
                          {_id: 1, host: 'localhost:40001'},
                          {_id: 2, host: 'localhost:40002'}]
           }
> rs.initiate(config)
``` 

- oplog and oplogSize

`oplogSize` 是replica里面同步日志的大小，默认是空闲磁盘的5%, 增加限制有利于磁盘空间的实际使用率，这其实是一个capped collection, 存放在叫 **local** 的空间中 ,会重复使用。  
基本机制是这样的，主节点不停的往oplog里面写，从节点会去获取并写入本地的oplog，然后再‘应用'.

- heartbeat

各节点之间会定期进行心跳交流， _如果primary发现四处都不通，则会自动降级为secondary_ 。 也因此， 整个set需要3个来起步。另外一个其实起的就是检测的作用。

- driver  
  driver 和 replica set之间的通信是通过 `db.isMaster()` . 以此确定向哪一个db写数据。根据调试经验，向secondary写的数据实际都不会入库。  

```ruby
   Mongo::RepelSetConnection.new(['localhost', 40000], ['localhost', 40001], :read => :secondary)
   # **secondary** 实现了对读的scale 
```

### Sharding 

- 几时shard
  * disk activity
  * system load
  * ratio of working set size to available RAM.

- shards  
  一个shard其实就是一个replica set，或者mongod

- mongos router  
   访问整个cluster的入口  
  将整个系统粘连在一起   
  轻量级的，驻留在内存中的，不写硬盘的   

- config server  
  处理存储的可靠性，实现两阶段提交  
 mongos 的 config 数据是问 config server 获取  
 需要3个独立的机器运行才能保证冗余性  

要 shard 则要去确定 **shard key**, key可以是组合的fields。 随后确定key上的值，值之间的区域构成了 **chunk** .

### 配置shard的步骤  

启动shard
```bash
#起shard
mkdir -p /data/rs-a-1
mkdir -p /data/rs-a-2
mkdir -p /data/rs-a-3

mkdir -p /data/rs-b-1
mkdir -p /data/rs-b-2
mkdir -p /data/rs-b-3

numactl --interleave=all mongod --shardsvr  --dbpath /data/rs-a-1 --port 30000 --logpath /data/rs-a-1.log --fork --nojournal
#numactl --interleave=all mongod --shardsvr --replSet shard-a --dbpath /data/rs-a-2 --port 30001 --logpath /data/rs-a-2.log --fork --nojournal
#numactl --interleave=all mongod --shardsvr --replSet shard-a --dbpath /data/rs-a-3 --port 30002 --logpath /data/rs-a-3.log --fork --nojournal

numactl --interleave=all mongod --shardsvr  --dbpath /data/rs-b-1 --port 30100 --logpath /data/rs-b-1.log --fork --nojournal
#numactl --interleave=all mongod --shardsvr --replSet shard-b --dbpath /data/rs-b-2 --port 30101 --logpath /data/rs-b-2.log --fork --nojournal
#numactl --interleave=all mongod --shardsvr --replSet shard-b --dbpath /data/rs-b-3 --port 30102 --logpath /data/rs-b-3.log --fork --nojournal

#起config server，至少3个，可以和数据库节点的mongod运行在一台服务器上
mkdir -p /data/config-1
mkdir -p /data/config-2
mkdir -p /data/config-3
numactl --interleave=all mongod --configsvr --dbpath /data/config-1 --port 27019 --logpath /data/config-1.log --fork --nojournal
numactl --interleave=all mongod --configsvr --dbpath /data/config-2 --port 27020 --logpath /data/config-2.log --fork --nojournal
numactl --interleave=all mongod --configsvr --dbpath /data/config-3 --port 27021 --logpath /data/config-3.log --fork --nojournal

sleep 2
#起mongos，os可以在应用服务器上一台装一个
mongos --configdb localhost:27019,localhost:27020,localhost:27021 --logpath /data/mongos.log --fork --port 40000

```

使用js设置shard
```js
mongo localhost:40000 
mongos> sh.addShard("localhost:30000")
mongos> sh.addShard("localhost:30100")
mongos> db.getSiblingDB("config").shards.find()
{ "_id" : "shard0000", "host" : "localhost:30000" }
{ "_id" : "shard0001", "host" : "localhost:30100" }

mongos> sh.enableSharding("myapp")
mongos> sh.status()

# 选择好的sharding key，是设计时的重要考虑对象
mongos> sh.shardCollection("myapp.pcmds", {c4:1, _id: 1})
mongos> db.getSiblingDB("config").collections.find()
```

观察状态
```js
use config
mongos> db.chunks.count()
1
mongos> db.chunks.find()
{ "_id" : "myapp.pcmds-c4_MinKey_id_MinKey", "lastmod" : { "t" : 1000, "i" : 0 }, "ns" : "myapp.pcmds", "min" : { "c4" : { $minKey : 1 }, "_id" : { $minKey : 1 } }, "max" : { "c4" : { $maxKey : 1 }, "_id" : { $maxKey : 1 } }, "shard" : "shard0000" }

mongos> db.chunks.count({"shard": "shard0001"})
```

实际**写**操作时分为 **routed** 或 **scattered** 两种模式。  
**读**操作则有 routed / scattered gather / distibuted merge sort.  

尽管里面的mongodb进程很多，但是真正数据量大的还是节点本身。config server占用的资源并不多，可以和数据节点共用一台服务器。  

