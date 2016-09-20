---
layout: post
title: "spring boot in action"
date: 2016-09-19 14:47
comments: true
categories: 
- java
- spring
---

* Auto-Config
* 用starter处理依赖
* CLI 命令行处理启动等
* Actuator 监控组件 , 通过web或者shell

```
spring version 
spring --version
spring shell # windows下打开可以自动补全的功能
```

### 工程初始化
```
spring init -dweb,jpa,security --build gradle -p jar -x //-x表示生成到当前目录
spring init -dweb,jpa,security --build gradle -p war myapp //表示生成工程到myapp目录
```

```
@SpringBootApplication
public class DemoddfApplication {

public static void main(String[] args) {
SpringApplication.run(DemoddfApplication.class, args);
}
}
```

@SpringBootApplication 起到了过去3个标注的作用，打开了自动配置和自动扫描。如果有新的配置要求，@Configuration用在其他配置类中进行配置的扩充。而主class可以不必修改

用starter定义可实现更高度的抽象，也不必给出每个组件的版本号。通过`mvn dependency:tree`可查看实际的包依赖关系.
starter就是普通的maven或gradle依赖，所以可以exclude也可以指定更直接的版本。

### 自动配置定制化的举例

安全是最好的需要自己自行设置的例子，not one--size-fits-all。
这是yml方式
```
server:
port: 8443
ssl:
key-store: file:///path/to/mykeys.jks
key-store-password: letmein
key-password: letmein
```

配置数据源

```
spring:
datasource:
url: jdbc:mysql://localhost/readinglist
username: dbuser
password: dbpass
driver-class-name: com.mysql.jdbc.Driver
```
