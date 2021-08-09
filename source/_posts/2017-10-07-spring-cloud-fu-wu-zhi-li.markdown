---
layout: post
title: "spring cloud 服务治理"
date: 2017-10-07 13:54
comments: true
categories:
- 技术
- java
- spring
---

服务治理是近年来架构中的热点部分，尽管比照ICE这些内容其实十几年前就已经有了，
只是五六年前伴随着系统越做越庞大，才变得必要起来。

简单理解一下，其主要内容基本是：

* 要有一个服务中心，服务中心最好是集群的  
* 要能向中心注册服务，服务的地址用名称而不是ip硬绑  
* 要能发现一个服务，其实就是用名称通过服务中心找到服务的ip和端口  
* 要一个可以轮流访问服务集群的客户端  
* 此外再配合上消息总线等内容

有了这些，基本一个服务治理的框架就基本形成了。

《Spring Cloud 微服务实战》是一本很不错的书，有动手的介绍，有源码的分析，写的也算精炼。  

### Eureka 服务治理中心

启动服务中心后，配置客户端主要包含两部分：

* 服务注册相关信息： 包括服务中心地址、服务获取间隔时间、可用区域，以`eureka.client`为前缀  
* 服务实例相关的配置信息： 包括实例的名称、IP地址、端口号、健康检查路径等，以`eureka.instance`为前缀  


### Ribbon

Spring Cloud的负载均衡是在客户端实现的。
`WeightedResponseTimeRule`是个比较复杂的实现。

### Hystrix

这是一个容错断路器，当出现超时等状况时直接调用指定的回掉函数。使用了RxJava库的异步操作模式，
实现了发送+观察的效果，所以可以中断请求。

### Feign

在RestTemplate上进一步抽象，实现和Spring MVC对等的method封装。因为要组client，所以`@RequestParam`
中的value不能少。

```java
@FeignClient("Hello-Service")
public interface HelloService {
  @RequestMapping(value="/hello1", method=RequestMethod.GET) //指明要访问的路径和方法
  User hello(@RequestParam("name") String name, @RequestHeader("age") Integer age); //指明构造请求是的参数名称
}

//调用方式
helloService.hello("DiDi", 30);
```

### Zuul Api 网关

网关的事情就两条：  
1. 路由
2. 过滤

Zuul的路由结合了治理服务，下面就把一个路径全部转发去了一个服务

```
zuul.routes.service-a.path=/aaa/**
zuul.routes.service-a.serviceId=Hello-Service
```
过滤器则可以通过继承一个抽象类`ZuulFilter`并实现4个方法来实现。

```java
public class AccessFilter extends ZuulFilter {
  ....
}

@EnableZuulProxy
@SpringCloudApplication
public class Application {
  public static void main(String[] args) {
    new SpringApplicationBuilder(Application.class).web(true).run(args);
  }

  @Bean
  public AccessFilter accessFilter() {
    return new AccessFilter();
  }
}
```

### Spring Cloud Config

基于git（也可以是svn或本地目录）的配置中心，其实就是一个可以保存各种配置信息，然后由其他微服务读取后拉起应用。

### Bus 和 Stream 消息总线和消息流

目前只支持RabbitMQ和kafka两种队列，kafka更多的好像和实时日志处理流相关
