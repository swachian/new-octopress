---
layout: post
title: "Spring 4 中的新东西"
date: 2015-05-04 14:30
comments: true
categories: 
- java
- spring
---

Spring还在继续提高与演进中。

### 3.1中的新东西

- environment profiles，支持development、test和production等条件下独特的配置
- 增加enable annotations，在Java文件配置中
- Declarative caching support，像支持事务一样支持缓存
- 支持Servlet 3.0，包括在java文件中声明servlets和filters，而不仅仅是在web.xml中
- JPA支持的提升，可以不再需要persistence.xml
- 自动绑定路径便利给model属性
- 支持对Accept和Content-Type消息头的匹配，通过@RequestMappingproduces
- 绑定部分二进制表单请求给方法参数，通过@RequestPart，比@RequestParam更强大（只能对请求参数数据绑定，key-alue格式），而@RequestPart支持如JSON、XML内容区数据的绑定
- flash属性的支持
- JpaTemplate和JpaDaoSupport让位于EntityManager

### 3.2中的新东西

- 支持servlet 3中的异步请求，使得一个请求可以在独立的线程中被处理，让servlet线程可以处理更多的请求
- Spring MVC的test框架，包括RestTemplate的测试支持
- @controllerAdvice使得@ModelAttributes等控制器的方法可以在单个类中重新组织
- ContentNegotiatingViewResolver
- @MatrixVariable
- Rest方面的改进与支持

### 4.0中的新东西

- WebSocket的支持，包括JSR-356中Java API对WebSocket的支持
- SockJS/STOMP对WebSocket和消息模块的封装
- Java 8 特性的应用，比如lambda。callback interface的使用变简单了，如RowMapper和JdbcTemplate
- Java 8中的时间日期api
- RestTemplate的一个异步版实现
- 新增对JMS 2.0 JTA 1.2， JPA 2.1的支持

