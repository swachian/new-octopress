---
layout: post
title: "StringHttpMessageConverter的头属性"
date: 2016-05-19 17:22
comments: true
categories: 
- java
- spring
---

使用Spring MVC中的`@ResponseBody`或者`@RestController`产生的json消息格式会产生一个很大的响应头。
其主要内容就是`Accept-Charset`会罗列几乎所有的charset变量，从utf到gbk再到iso等等。而这很大程度上是无谓的开销。

要解决可以在xml的配置中设置

```xml

  <mvc:annotation-driven>
    <mvc:message-converters register-defaults="true">
      <!-- 将StringHttpMessageConverter的默认编码设为UTF-8 -->
      <bean class="org.springframework.http.converter.StringHttpMessageConverter">
        <constructor-arg value="UTF-8" />
        <property name="writeAcceptCharset" value="false" />
      </bean>
    </mvc:message-converters>
  </mvc:annotation-driven>
```

注意给`StringHttpMessageConverter`的属性`writeAcceptCharset`设置成`false`

---- update on 2016.10.17

`RestTemplate`作为客户端发送请求时也有类似的问题，会带出一串过长的Charset。解决办法如下:

```java
static RestTemplate restTemplate = new RestTemplate();
  static {
    List<HttpMessageConverter<?>> converts = restTemplate.getMessageConverters();
    for (HttpMessageConverter<?> convert : converts) {
      if (convert.getClass() == StringHttpMessageConverter.class) {
        ((StringHttpMessageConverter) convert).setWriteAcceptCharset(false);
      }
    }
  }
```

获得converts，然后对String的Convert进行设置
