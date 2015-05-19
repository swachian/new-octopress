---
layout: post
title: "HttpSession在Spring中的配法和问题"
date: 2015-05-19 17:22
comments: true
categories: 
- 技术
- java 
- spring
---

最早出于使用struts2的习惯，在Spring中如果需要使用`HttpSession`，做法是把这个对象作为整个类的一个实例对象。

1 

```java
public class TestController {

  private static final Log logger = LogFactory.getLog(TestController.class);
  
  @Autowired
  HttpSession session;

  ...
}
```

后来因为担心Controller在Spring中是单例的（在struts2中是多例的），怕引出线程安全问题，于是把`session`放入了method中进行注入。

2 

```java
@ResponseBody
  @RequestMapping(method = RequestMethod.GET,  produces = MediaTypes.TEXT_HTML_UTF_8)
  public String testSession(HttpServletRequest request, HttpServletResponse response, Model model, HttpSession session) {
    int hashCode = session.hashCode();
    
    int i = 0  ;
    if (session.getAttribute("val")!=null) {
      i = (int)session.getAttribute("val");
      i++;
    } 
    
    session.setAttribute("val", i%3);

    logger.info("hashCode: " + hashCode);

    return ""+hashCode + ": " + i;
  }
```

近日在学习Spring in Action的过程中，发现其实第一种方式下使用了`proxy 模式`, 实际被注入的类是`session  $Proxy38 `这样的代理类，
类似于避免反复调用`createEntityManager`的做法，该代理类会寻找实际对应的session并进行操作,只是给controller注入了一个壳。

而第2种方法中，注入的则是标准的容器session: `org.apache.catalina.session.StandardSessionFacade`

3 

此外，受到推崇的是第三种写法，

```java
@Component
@Scope(proxyMode=ScopedProxyMode.TARGET_CLASS, value="session")
public class ShoppingCart implements Serializable{
}
```

这种写法将整个购物车变成一个scope属于session的bean，由spring注入并负责保存。

但这种写法我个人感觉有点过于抛离了web开发。尽管Spring的一大好处是取消对容器的依赖，从而做到测试的方便。但完全和Web容器隔离，变得不像Web开发也不是什么好的策略。
毕竟Session的概念几乎每个Web开发者都有，而scope=session则反而会增加沟通的难度。
