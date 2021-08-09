---
layout: post
title: "Spring In Action 4"
date: 2015-06-01 10:31
comments: true
categories: 
- spring
- java
- 读书笔记
---


大约两年前，又读了In action的第三版，感觉离实际的开发已经有点远了，里面讲的内容反应不了当时Spring主要的用法。于是换了
《Spring In Practice》学习，比当时的in action贴近实际反应现状多了。  
好在，In action在14年年末又出了新的版本。
经典的Spring系列又出了第4版，这一版是完全跟上了Spring发展的脚步，呈现的也是最新的Spring开发内容，而且聚焦于Spring Web。

内容比较新颖，作者的文章也总喜欢和读者拉拉家常，所以整个书读起来也比较有意思。不过，这本书不适合完全没Java Web开发基础的读者，
其整个书还是写给已经使用Spring进行开发或者至少已经略懂什么是Java Web开发的人，所以，学这本书前必须要有一点基础。

## Spring的基础介绍

这部分也是整个系列一直的拿手好戏，现在总结的是越来越精彩，在Xml配置和Java Config中也完全倒向后者了，不过更多的也是通过这两个配置结合了自动扫描的配置方法，即Annotation。

###Spring 的四大法宝： 
1. PoJo
2. DI（依赖注入，取代各个类之间的内部new）
3. Aspect（Feature），给每个method加上chain，主要用于Transaction、logging、security、cacching这些领域
4. Template（JDBCTemplate等等)，即模板方法，用于减少冗长代码的写入。

而这一切的基础是Java的动态编程，除了Java自带的反射，其实大量使用了CGLib库。

### Profile

通过`@Profile("dev")`来表明在什么情况下使用下面的标注或配置，即激活哪一种配置属性。有两个变量可以指定值

```
spring.profiles.active
spring.profiles.default
```

其中，`default`可以在web.xml中定义，而`active`可以在系统属性、环境变量、JNDI或者@ActiveProfiles中定义，因为`active`的优先级更高。

### 其他一些标注

@Primary 用于消除bean的歧义性（比如有多个同名或同类型、同接口），在声明是可以使用表明这个为主。  
@Qualifier，用于一步一步的Narrow指定匹配，不过似乎耦合了点，个人觉得不推荐使用  
@Scope，这个很关键，指定了生成bean使用的容器, Prototype是每次new一个，大部分默认是单例，还有基于Session和Scope的bean注入，解决了web开发时的有些信息注入的难题。具体可参看[HttpSession在Spring中的配法和问题](/blog/2015/05/19/httpsessionzai-springzhong-de-pei-fa-he-wen-ti/)。

## Aop

Aop 提供了在method的前后增加功能（Feature）的能力，而这些功能往往是针对业务某些统一的能力的，所以称之为切面，意在把日志、事物、安全等功能提取出来，并且Spring配套了一系列术语称呼AOP中的各个角色。
但本质上还是一种定义Hook的模式。

- Advice ， 功能本身
- PointCut，实际需要使用的Join Points
- Joinpoints，在哪些点（方法中插入）

插入的时机有：
1. Before: method调用前
2. After all: method调用后
3. After returning success: method调用成功
4. After throwing: method调用出现例外
5. Around: 写法最复杂，需要把调用的chain写在Advice里面

具体用分为:  
1. Introductions: 给现有的class **加**(新增)方法或属性, 类似加入一个模块
2. weaving（编织、插入）：代理插入，可以在编译时、加载class时以及运行时混入
