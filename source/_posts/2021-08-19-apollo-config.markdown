---
layout: post
title: "Apollo Config"
date: 2021-08-19 17:30
comments: true
categories: 
- 技术
- Java
---


配置项的管理始终是一个很头疼的问题。虽然磕磕绊绊总能凑合着过，但确实一直不太优雅，甚至容易出错。
人多的情况下，优雅是很难的，还是考虑怎么能减少损耗吧。所以抽空看了看Apollo的东西。

> Apollo（阿波罗）是携程框架部门研发的开源配置管理中心，能够集中化管理应用不同环境、不同集群的配置，配置修改后能够实时推送到应用端，并且具备规范的权限、流程治理等特性。

也支持热更新、版本控制、分组等比较实用的特性，据说还能适应复杂的流程治理要求。简单适用了一下，确实不负盛名。

### 一. 安装并启动Apollo

因为是试用，目前使用的是单机版的Apollo，后续可能会进一步调研一下高可用版的发布。

下载 `https://github.com/apolloconfig/apollo-build-scripts.git` ,  修改`demo.sh`里面的数据库配置信息和config server信息: 

```
 apollo_config_db_url="jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai"
-apollo_config_db_username=root
-apollo_config_db_password=

 # apollo portal db info
 apollo_portal_db_url="jdbc:mysql://localhost:3306/ApolloPortalDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai"
-apollo_portal_db_username=root
-apollo_portal_db_password=

-config_server_url=http://localhost:8080
-admin_server_url=http://localhost:8090
 eureka_service_url=$config_server_url/eureka/
-portal_url=http://localhost:8070
```

config server就是未来的meta server，portal就是管理界面。

### 二. Java端的配置

对于基于Sprint Boot的应用而言，最简单和顺利的方式是在bootstrap.yml里面。操作步骤如下

1. 加入依赖 `    implementation group: 'com.ctrip.framework.apollo', name: 'apollo-client', version: '1.8.0'`   
2. 除去原先对config的依赖 `compile('org.springframework.cloud:spring-cloud-starter-config')`, 删除整个application.yml文件  
3. 删除application.yml文件，并把内容转移到apollo里面  
4. 在bootstart.yml里面替换下面的文件

```
apollo:
  bootstrap:
    enabled: true
    namespaces: application,application.yml
  meta: http://xxxx:8080
app:
  id: xxxxxx-compare-monit

```

enabled表示启用apollo读取配置，namespaces是给出了需要拉取的namespace，默认只有application一个，如果是自己添加的yml，则需要按上面的配置加一个。
meta就是config server的地址。app.id表示了应用的身份，需要和apollo的对应起来。

如果再portal侧重新发布配置项，可以看见下面的日志

```
INFO 69947 --- [Apollo-Config-1] c.f.a.s.p.AutoUpdateConfigChangeListener : Auto update apollo changed value successfully, new value: 222222, key: bcmonit.xxxxxKey, beanName: xxxxxxProperties, field: com.xxxxx.address.util.xxxxxProperties.xxxxxKey

```

更多的内容可以参考51cto上面的这篇文章，对apollo架构的介绍非常到位。

https://blog.51cto.com/u_14643435/2866187