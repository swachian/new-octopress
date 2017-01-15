---
layout: post
title: "zookeeper"
date: 2017-01-15 10:27
comments: true
categories:
- 技术
- java
---

用于协作的服务，提供目录树的结构。基本可以认为是Yahoo出品。

data registers - called znodes, file
parlance - directory

数据全部保存在内存中。

优势：
1. 性能好，可在大规模的分布式系统里使用
2. 可靠性高，可防止单点故障
3. 严格的顺序性，可满足复杂的、高精的客户端同步实现要求


znode的读写有acl控制以及版本号

leader nodes负责接受写的请求，follower nodes负责被同步和读取

配置示例

```
tickTime=2000
dataDir=/var/lib/zookeeper
clientPort=2181
initLimit=5
syncLimit=2
server.1=zoo1:2888:3888
server.2=zoo2:2888:3888
server.3=zoo3:2888:3888
```

tickTime是一个即使单元，单位是毫秒，2000表示2秒。  
dataDir是存放数据文件的物理位置。  
initLimit表示n个tickTime，上面这个就是10秒的意思，表示连接上leader nodes需要的时间单元数量。  
syncLimit表示山离皇帝能有多远过期  
server.1中的1的服务器内部的`myid`，zoo1是服务器地址，第二个port即2888用于follewer连接leader，
第三更port 3888用于选举leader。  


基本上，zookeeper可以理解成一个分布式系统里，用于进程间通信的中间件，所以剩下的就是客户端调用了。
项目本身提供了C和Java的binding，具体实现时每个客户端会分为IO线程和watch线程两个。而Netflix在此基础上，
构造了wrapper: `curator`，以方便开发。

首先，引入maven依赖:

```
<dependency>  
    <groupId>org.apache.curator</groupId>  
    <artifactId>curator-recipes</artifactId>  
    <version>3.2.1</version>  
</dependency>
```

然后，在代码中可如下调用：

```java
package zookeepertest;

import org.apache.curator.RetryPolicy;
import org.apache.curator.framework.CuratorFramework;
import org.apache.curator.framework.CuratorFrameworkFactory;
import org.apache.curator.retry.ExponentialBackoffRetry;

public class CuratorTest {

	public void set() {
		String zookeeperConnectionString="127.0.0.1:2181";
		RetryPolicy retryPolicy = new ExponentialBackoffRetry(1000, 3);
				CuratorFramework client = CuratorFrameworkFactory.newClient(zookeeperConnectionString, retryPolicy);


				client.start();

				try {
					client.create().forPath("/my", "555".getBytes());

					client.getData().forPath("/my");
					Thread.sleep(1000);

					client.setData().forPath("/my", "666".getBytes());

				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	}

	public static void main(String[] args) {
		CuratorTest test = new CuratorTest();
		test.set();
	}
}

```

这种调用方式是比较原始的进程间通信，以此为基础，recipes已经实现了一系列通信的高级语意，
如lock、semaphore、确认leader等，可以直接使用。
