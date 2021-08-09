---
layout: post
title: "Tomcat7 采用 Redis作为session Store - 2"
date: 2014-11-19 15:57
comments: true
categories: 
- java
- 技术
---

在[Tomcat7 采用 Redis作为session Store](/blog/2014/07/14/tomcat7-cai-yong-rediszuo-wei-session-store/)中，使用了redis作为tomcat的session共享。
在打过几个补丁后，基本也算运作正常。只是偶尔总是有些null的session需要定期清理。而当时的作者已经近2年没再处理相关的pull request，所以我提交到了另外一个库中。

上个月发现作者又回来了，接受处理了一系列的pull request并且还增加了一些新的配置。于是做了一下更新。

原本提过需要3个包：

1. ~~tomcat-redis-session-manager-1.2-tomcat-7.jar~~
2. ~~jedis-2.0.0.jar~~
3. ~~commons-pool-1.3.jar~~

这次作者终于在readme中也加以了描述，并且更新了版本：

1. tomcat-redis-session-manager-VERSION.jar
2. jedis-2.5.2.jar
3. commons-pool2-2.2.jar

在context.xml中的配法也做了一些调整，主要是类名发生了变化，
```xml
<Valve className="com.orangefunction.tomcat.redissessions.RedisSessionHandlerValve" />
<Manager className="com.orangefunction.tomcat.redissessions.RedisSessionManager"
         host="localhost" <!-- optional: defaults to "localhost" -->
         port="6379" <!-- optional: defaults to "6379" -->
         database="0" <!-- optional: defaults to "0" -->
         maxInactiveInterval="60" <!-- optional: defaults to "60" (in seconds) -->
         sessionPersistPolicy="ALWAYS" <!-- optional: defaults to "DEFAULT" --> />
         sessionPersistPolicies="PERSIST_POLICY_1,PERSIST_POLICY_2,.." <!-- optional -->
         sentinelMaster="SentinelMasterName" <!-- optional -->
         sentinels="sentinel-host-1:port,sentinel-host-2:port,.." <!-- optional -->
        connectionPoolMaxIdle="20"
         connectionPoolMaxTotal="500" 
 />

```

另外就是增加了sessionPersistPolicies，建议选择`SAVE_ON_CHANGE`，如果选择`ALWAYS_SAVE_AFTER_REQUEST`，更容易诱发写竞争。而且有些场合，如果在request结束之后再写入，
中间的状态可能时间会拖得太长。如果真的对竞争情况很敏感的场合，就需要自己手动设置锁。

### github上把原作者的提交合并到自己的库中

同把自己的修改贡献给对方类似，只不过这种pull request需要换成base是自己的库，而head则是原作者库，然后新建pull request，github就会列出发生过的变化。
这时候又会产生两种结局，其一是github可以自动合并，则再点击按钮即可，另一种是自动合并失败，会提示在本机先建分支，再pull原作者的分支，冲突解决（修改完毕）后合并回自己的主分支，
然后再push到github。push成功后，github会自动关闭这个pull request。
