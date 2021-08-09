---
layout: post
title: "Learning Mongodb (3) 部署和管理"
date: 2012-04-17 11:07
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


### 部署环境要求

- 架构
  * **64-bit** , mongo会把所有的文件都map成虚拟地址空间，32位至多只能利用2GB内存空间  
  * little-endian , 不适合SPARC, PowerPC, PA-RISC，客户端（驱动）无所谓运行环境  

- CPU
  * 非cpu密集型应用   
  * I/O瓶颈远比CPU瓶颈出现的可能性多   
  * 多客户端同时读时，多核会被利用   
  * 写操作还是单核  

- RAM
  * 越多越好  
  * working set， index size， ram总数  

- Disk
  * IOPS 优先  
  * _background flush_ 60s sync到磁盘一次  
  * ssd可以优化速度（solid state drive）  
  * RAID 10 组成 LVM

- 文件系统
  * ext4 或者 xfs，快速、连续的磁盘分配  
  * 禁用access time(atime)更新

```sh
# 禁用 atime更新
sudo mv /etc/fstab /etc/fstab.bak
sudo vim /etc/fstab
# file-system mount type options dump pass
UUID=8309beda-bf62-43 /ssd ext4 noatime 0 2

改完文件后，可以不用重启
```

- 文件描述符(FD)
  * 默认的1024不够用  `lsof | grep mongo | wc -l ` 可以查看当前mongod打开了多少个文件和连接
  * 调大 `ulimit -Hn` 可以查看 

```sh
vi /etc/security/limits.conf
mongodb hard nofile 10240
下次登录后生效
```

- 时钟
  * ntp协议，在跑shard和replication时候必须启用的东西

- ec2上使用mongodb 
  * ec2易用、地理范围广、价格有竞争力
  * 68GB RAM的限制
  * 使用  EBS 存储， 吞吐性能一般化

### 服务器配置

- 选择拓扑
  * 是否需要shard， 是否需要replica
  * 建议多机  

- 打开journal标志  

### 安全保障

- 环境安全
  * 防火墙  
  * 数据的传输是不加密的

- 授权
  * 给admin区增加用户`use admin; db.addUser("boss", "supersecret")`
  * 启动时带上选项 `mongod --auth`
  * 使用admin然后再授权 `use admin; db.auth("boss", "supersecret")`
  * 给其他库，如stock，创建用户 `use stocks; db.addUser("trader", "moneyfornuthin")`
  * 查找用户 `db.system.users.find()`

- keyFile
  * cluster 和 sharding 的时候需要制定keyFile，mongos实例也要具备这个密钥文件



* 日志记录
  - 运行时--logpath指定

### 监控工具
  
- serverStatus  
  `use admin; db.runCommand({serverStatus: 1})`  
  **globalLock** 表示等待写锁的时间。ratio过高意味着需要优化调整  
  **mem** 段的单位是MB

- mongostat
  * 类似 iostat 运行的效果

- web console
  * --rest 标志打开的话，可以从web处得到更多的运行信息


### 备份与压缩

mongodump 和 mongorestroe两个组合，也可以直接拷贝文件。不过后者要求lock数据库，即要求mongod停止往磁盘同步。