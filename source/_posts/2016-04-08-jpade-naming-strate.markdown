---
layout: post
title: "JPA的naming strategy"
date: 2016-04-08 17:08
comments: true
categories:
- java
---

JPA的配置通常如下即可：

```
  <!-- Jpa Entity Manager 配置 -->
  <bean id="entityManagerFactory"
    class="org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean">
    <property name="dataSource" ref="dataSource" />
    <property name="jpaVendorAdapter" ref="hibernateJpaVendorAdapter" />
    <property name="packagesToScan" value="com.sanss." />
    <property name="jpaProperties">
      <props>
        <!-- 命名规则 My_NAME->MyName -->
        <prop key="hibernate.ejb.naming_strategy">org.hibernate.cfg.DefaultComponentSafeNamingStrategy</prop>
        <prop key="hibernate.show_sql">true</prop>
      </props>
    </property>
  </bean>
```

其中值得注意的是Resposity的生成其实依赖于里面的`packagesToScan`，而表名、表字段和对象之间的映射转换则依赖于`hibernate.ejb.naming_strategy`

此属性共有四个选项：

```
org.hibernate.cfg.DefaultComponentSafeNamingStrategy
org.hibernate.cfg.DefaultNamingStrategy
org.hibernate.cfg.EJB3NamingStrategy
org.hibernate.cfg.ImprovedNamingStrategy
```

首两个选项基本就是不做命名的转换，后面两个会把大小写的骆驼写法转换成带下划线的小写字符。同时，这个类可以自己继承并进行扩展定制，如果命名要求实在特殊，可以自行编写。
甚至表名后带日期等均可以自行定制。
