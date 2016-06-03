---
layout: post
title: "禁用http的一些方法"
date: 2016-06-03 14:24
comments: true
categories: 
- java
---

本来是挺正常的HTTP方法，现在变成了安全隐患。当然，也不能说不合理，毕竟基于能关的都关掉的思路，不使用的东西是可以禁掉。

Nginx的配法

```
if ($request_method !~* GET|HEAD|POST) {
            return 403;
}
```
对于请求方法不是GET HEAD和POST的都返回403.


Tomcat的配法

```
<security-constraint>
        <web-resource-collection>
                <web-resource-name>fortune</web-resource-name>
                <url-pattern>/*</url-pattern>
                <http-method>PUT</http-method>
                <http-method>DELETE</http-method>
                <http-method>OPTIONS</http-method>
                <http-method>TRACE</http-method>
        </web-resource-collection>
        <auth-constraint></auth-constraint>
</security-constraint>
<login-config>
        <auth-method>BASIC</auth-method>
</login-config>
```

这里面login-config可以不配，也不会影响效果。auth-constraint一定要配，如果不出现（即值为null），则全部的限制将不起作用。
元素出现而值不填，则所有的这种请求都会被拒绝。

