---
layout: post
title: "Safari不支持第三方cookie引起的session改造"
date: 2015-01-21 13:48
comments: true
categories: 
- java
- 技术
---

近日的一个项目中，经常出现部分浏览器的session无法写入的事情。观察一番后，发现这些浏览器大都属于iPhone的Safari浏览器，尤其以iOS7版本居多。
问题本身并不难猜，应该就是cookie无法写入引起的。奇怪的是，部分同版本的Safari又是可以写入session的，所以这个问题很让人困惑。
反复查找，最后明白原因是：首先，对于第三方cookie，Safari升级后确实有禁止写入cookie的特性；其次，但是对于已存在cookie的情况，则尽管是第三方cookie依然还会写入。

就是因为其次这个因素存在，所以之前进行测试的一些手机照样可以写入session了。

问题是找到了，但怎么解决呢？Java中最简单就是让url中带入jsessionid，只是这个方式确实有好多年没有使用过了。虽然是第三方cookie，但因为测试时有过session了，所以还能继续写入。

` response.encodeURL(url)`

-- 查文档，这个api的含义是对于如果是可以用cookie追踪sessionid的则不会在url后加入jsessionid，而对于不支持cookie追踪的则会在url中写入id。  
这引发了我的好奇心，只有response怎么能判断cookie是否能追踪呢？

一看Tomcat的源码，实现倒也简单，就是根据当前session的id是否从cookie中获取的来决定的。如果首次访问网站，此时不会有sessionid，则自然不是从cookie追踪的，于是生成的url都有jsessionid。
二次请求上来，如果是cookie中读取的，则不再写入了。如果不是从cookie中读取的，则继续写入jsessionid。也就是说，**不管是不是支持cookie写入，第一笔encodeURL的调用都会加上jessionid**。

例如，第一次访问都会生成这样的链接 `http://192.168.202.72:8080/toolbar/home/nav;jsessionid=EFC1A53F48CC5BC9BE58F50830296FBB`, 如果再次访问就是`http://192.168.202.72:8080/toolbar/home/nav`.

这个东西的缺点公开的说法有如下两点：

1. sessionid暴露在url链接中并不安全；
2. sessionid这样子会保存在地址栏中，容易引发保存后歧义，因为sessionid其实每一次都会是不一样的。

简而言之就是这样的链接不好看外加安全性有一定的问题。

不过这个安全性问题如果从网络的角度来看有点勉强。因为http头也是明文传输的，只是浏览器中不显示罢了。以机器的角度来看，jsessionid放在header还是uri中的区别并不大。鉴于业务需要，还是采用吧。于是引发这种写法最大的毛病，需要在jsp中每个自己的链接都加上`<%=response.encodeURL(url)%>` 。此时不免想起如果都像`link_to`那样生成链接的话，改起来就方便多了。

Java Web的开发至今没有很方便的helper机制，能用用的还是tags的办法，于是写一个hrefto.tag放到tags下面。

hrefto.tag
```jsp
<%@tag pageEncoding="UTF-8"%>
<%@ attribute name="uri" type="java.lang.String" required="true"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<% String ctx = request.getContextPath(); %>
<%= response.encodeURL(ctx + uri) %>
```

在jsp中的应用主要是两句话，第一是引入，第二是调用

```jsp
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags"%> <!--hrefto.tag存放的位置-->
<a id="help" href='<tags:hrefto uri="/home" />' target="_blank"></a>
```
其中`<tags:hrefto uri="/home" />`就会调用hrefto.tag中的内容，生成链接。
