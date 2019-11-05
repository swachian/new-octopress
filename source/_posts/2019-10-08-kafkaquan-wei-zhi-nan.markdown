---
layout: post
title: "Kafka权威指南"
date: 2019-10-08 11:07
comments: true
categories: 
- 技术
- 笔记
---
`default.replication.factor ` : 分区的复制系数  
`unclean.leader.election` : 
简而言之，如果我们允许不同步的副本成为首领，那么就要承担丢失数据和出现数据不一
致的风险。如果不允许它们成为首领，那么就要接受较低的可用性，因为我们必须等待原
先的首领恢复到可用状态。
如果把 unclean.leader.election.enable 设为 true，就是允许不同步的副本成为首领（也
就是“不完全的选举”），那么我们将面临丢失消息的风险。如果把这个参数设为 false，
就要等待原先的首领重新上线，从而降低了可用性。  
`min.insync.replicas` : 最少同步副本  

上述对broker的配置以外，生产者也要注意配置好`acks`的值，以及在代码里正确处理错误。

ETL 表示提取—转换—加载（ Extract-Transform-Load）

kafka的消息是可以在客户端进行压缩的

事件流是可重播的，借助kafka，可以重播几个月甚至几年前的原始事件流

时间窗口是否对齐？

中间结果可以作为流写入kafka中


flink手工启动命令
/opt/flink-1.8.1/bin/flink run /opt/flink-1.8.1/jars/ssss-1.0.0-SNAPSHOT-TEST2-cron-4d8e317-all.jar
启动命令：/opt/flink-1.8.1/bin/flink run -d /opt/flink-1.8.1/jars/Hastur-*.jar

罗列任务的命令：
/opt/flink-1.8.1/bin/flink list -r | grep ssss | cut -d " " -f 4

停止任务的命令：
/opt/flink-1.8.1/bin/flink cancel 6b338726460bcb8fe95bad883ca9f5b2


taskmanager.heap.size跟着yarn的container size走
taskmanager.numberOfTaskSlots 可设置多条
