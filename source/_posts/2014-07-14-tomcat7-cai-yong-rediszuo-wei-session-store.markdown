---
layout: post
title: "Tomcat7 采用 redis作为session store"
date: 2014-07-14 15:57
comments: true
categories: 
- 技术
- java
---

有个项目部署了几套Tomcat，而前置分发又不是按ip映射的，所以无法象往常一样继续使用内存作为session存放的介质。 
同时，业务主要由使用移动互联网的手机来访问，ip也存在随时切换的可能，所以按ip进行映射在此场景下并不是一个好的办法。因此，最终决定使用redis来作为公共的session存储空间，实现session的共享。

主要用到的工具包:

* [tomcat-redis-session-manager](https://github.com/jcoleman/tomcat-redis-session-manager#readme)  
* jedis
* commons-pool 

需要注意的是，这个session manager已经有挺长时间停止开发了，从issues来看，表现还算基本稳定。目前也已经支持tomcat6和tomcat7，jdk也是6和7均支持。但是，上述几个包却存在着特定的版本依赖。必须为：

1. tomcat-redis-session-manager-1.2-tomcat-7.jar
2. jedis-2.0.0.jar
3. commons-pool-1.3.jar  
尤其是最后一个，千万马虎不得。上述三个包必须放入tomcat的lib目录下。

然后，再在应用的context.xml,可以是应用的该文件也可以是tomcat/conf目录下的该文件，加入下列配置即可：

```xml
<Valve className="com.radiadesign.catalina.session.RedisSessionHandlerValve" />
<Manager className="com.radiadesign.catalina.session.RedisSessionManager" 
         host="192.168.203.198" 
         port="6379" 
         database="1" 
         maxInactiveInterval="600" /> 
```
