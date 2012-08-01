---
layout: post
title: "Learning Mongodb (1)"
date: 2012-03-29 15:59
comments: true
categories: 
- 技术
- nosql数据库
- 读书笔记
---

一个不错的mongodb[入门游戏](http://tutorial.mongly.com/tutorial/index). 一共二十课，介绍了基本的内容。通常20-60分钟可以通关。  
下面是同一个作者给mongodb写的[小书](https://github.com/karlseguin/the-little-mongodb-book).  
需要执行的脚本可以这样输入 `./mongo server:27017/dbname --quiet my_commands.js`  

table - collection  
row - document  
column - field  
最核心最本质的突破点在于，将定义字段 从table级别  **下放** 到了document的级别，因而起了不同的名字以示区别。

### selector
``` js
{filed, value}
$lt, $gt, $lte, $gte, $ne
$or
  db.unicorns.find({gender: 'f', $or: [{loves: 'apple'}, {weight: {$lt: 500}}]})
```

### replace 和$set及modifier

mongodb的update至少跟两个参数：  

- selector  
- **replace**的值  
 
  这点区别于sql，他会对document的值做全部更新

如果只是部分更新，请用`$set`, `db.unicorns.update({name: "ooo"}, {$set: {name: 'dddd'}})`

`$inc`: `db.unicorns.update({name: 'dddd'}, {$inc: {vampires: -2}})`  
`$push`: `db.unicorns.update({name: 'ddd'}, {$push: {loves: 'sugar'}})`  
$inc主要用于整型数据，push主要用于数组等类型。  

- upserts  
  第3个参数决定是否upserts，即不存在的时候就插入一笔新的数据, 默认为false不开启。
- multiple update
  第4个参数决定是否批量更新。 默认情况下，只会更新一笔数据，而不是所有满足条件的数据。

upserts搭配$inc的威力还是巨大的。

### find进一步

`find()`返回的仅仅是`cursors`，以此实现链式反应。  

`find()`还有一个参数，就是指定列名。 `db.unicorns.find(null, {name:1, _id: 0})`.  
  0表示隐藏不要，只有_id能和显示或隐藏混合使用，否则只能使用0或者1

`sort`等于sql里面的order，`db.unicorns.find().sort({weight: -1})`，1表示升序，-1表示降序。  
对于没有索引的排序，mongodb有最大尺寸的限制，这可以认为是一个瑕疵，但对避免很次的数据库设计有好处。  

**paging**通过`skip()`和`limit()`来配合实现。limit表示返回几条，skip表示略过前面多少个。

`count()`其实也是cursor方法，只不过shell实现了简写。下面两个是等效的：  
`db.unicorns.find({vampires: {$gt: 50}}).count` <=> `db.unicorns.count({vampires: {$gt: 500}})`

### Data模型设计区别

- No Joins, 替代品是在client多做一次查询，该查询通常是针对已加索引的字段。

- Arrays 和 Embedded Documents
  * arrays适合处理用于many-to-many的关联，在mongodb中，array的等级很高，使用很多  
  * embedded的doc是的可以进一步反范式化，查询可以用面向对象的方式`.`进行链式表达.`db.employees.find({'family.mother': 'Chani'})`
  * 上面两个均可选择，当前的限制是一条doc最大的尺寸是4mB

- DBRef  
  等同于外键，是在服务器端支持，但还需客户端支持。

- collection数量考虑  
  以schemaless的角度考虑，一个collection实际上可以支持全部的应用。但是，实际上使用时还是会按照sql数据库表格的设计方式进行区分。
当然，many_to_many的表格基本是不存在了。而设计时，可以多考虑使用**embedded**的方式。

### 何时使用MongoDB

- 大部分数据其实也是结构化的，所以schemaless实际上并未受到重视。但是在开发流程方面则发生了很大的变化，而这一点对于从java .net过来的程序员是震撼性的。  
 
- Writes，也就是logging  
  * 是因为mongodb的写性能很高。因为它允许写命令即可返回而不用等待真实的写。类似non-block。  
  * 1.8以后也增加了safe的模式 ，确保写是成功的； 对于违反约束的写，比如唯一索引，不safe的写也不会返回错误   
  * `capped collection`使得文件尺寸可以设置最大值，或条数设置最大值，有利于反复循环利用现有的空间。 `db.createCollection('logs', {capped: true, size: 1048576, max: 10000})`
  * schemaless对日志来说，也可以较易地做修改
  * `journal=true`位于`mongodb.config`中有利于提高durability（耐久性）  

- 事务性   
  这并非mongodb的强项。经过有atomic的操作和两段提交的例子。前者用的还是比较多的，如`$inc`, $`set`

- 数据处理  
  * 内建的js的MapReduce，但是js是单线程的  
  * 可以使用Hadoop，也存在MongoDB adapter for Hadoop  

- 地图应用  
  内建有$near $within 的操作符

### MapReduce

尽管 Mongodb 内建 MapReduce 计算模型，自己只要写 hook，然后使用 `db.hits.mapReduce(map, reduce, {out: {inline: 1}})` 来调用。但是，本质上这其实一种存储过程的写法，用来弥补group计算
功能的不够强大。毕竟js是 **单线程**，所以这里的MapReduce有点鸡肋，聊胜于无。如果真的大数据量处理，还是用Hadoop等吧。  
毕竟MapReduce是一种模式，而各语言实际上有各自的实现。  

### 性能及其他

- 索引  
  * 普通索引 `db.unicorns.ensureIndex({name: 1})`, 1表示升序  
  * unique `db.unicorns.ensureIndex({name: 1}, {unique: true})`  
  * 复合 `db.unicorns.ensureIndex({name:1, vampires: -1})`, -1表示降序，在复合索引中，有意义  
  * explain: 可以查看查询使用的索引状况; `db.unicorns.find().explain()`, 例如`BasiceCursor`, `BtreeCursor`  
  
- Sharding  
  MongoDB支持自动partition  
  Sharding可以和**Replication**合在一起做，比如每个shard由主从两个mongo组成，中间其实还有一个arbiter  
  
- 性能信息 
  * `stats()`可以看状态，主要是size方面的信息  
  * web的接口除了浏览器终端，还有restful的接口  
  * `db.system.profile.find()` 可以分析性能  

- 备份及恢复
  `mongodump --db tutorial --out backup` 可把一个schema导入到backup这个目录下，里面的内容是相应的 **bson** 文件  
  `mongorestore --collection pcmds backup/tutorial/pcmds.bson` 可以把数据复原  
  `mongoexport` 和 `mongoimport` 可以导入导出json和csv文件  

### 下一步计划

1. [尝试分布式及复制  （sharding and replication)](/blog/2012/03/30/learning-mongodb-2/)
2. [部署和管理](/blog/2012/04/17/deployment-and-administration-for-mongod/) 
2. GridFS
3. Hadoop 的 MapReduce 学习及引用  

