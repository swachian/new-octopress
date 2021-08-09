---
layout: post
title: "JSP中的EL表达式和Helper"
date: 2014-06-12 19:05
comments: true
categories: 
- 技术
- java 
- spring
---

## JSP中的代码

### 传统的老三样

长久以来的Java Web开发，在jsp层面进行读取或逻辑控制等行为时主要有**Scriptlet**、**Helper**和**标签**三种方式。

其中，Scriptlet是最不受推荐的方式，最为推荐的是用 **标签** 的方式，而Helper因为免不了会使用Scriptlet，所以流传的也不广。而标签方式中，不单有相对通用的JSTL（JSP Standard Tag Library，JSP标准标签库)，每个框架往往还有自己的标签库。

如struts1的：

`<bean:write name="spRinglib" property="down_cnt"/>`

struts2的：

`<s:property value="r.department" />`

jstl的：

`<c:out value="${user.company}" escapeXml=="false"/>`

这种方式的一大特点就是冗长和啰嗦。信息的表达力很差。上述还只是用于输出的，一旦碰到条件判断等，标签的表现更是只能用拙劣二字来加以形容。同时，每个框架各搞一套，给程序员也会带来很大的负担，对项目维护也带来更多的成本。

然而，对于程序员而言，输出内容、流程控制等原本有着更直接和通用的描述方式： 编写代码。比如Java程序员自然用Java编写代码，Ruby的则自然用Ruby。
如果这些重新发明的标签，具有比语言更好的表达和组织能力，那么显然大家应该放弃语言本身，比如不使用java，而在MVC的各个部分都
使用标签。但既然这个没有发生，说明标签在大部分时候并不合适。

### 新的变化-EL表达式的出现

好在随着EL表达式的推出，情况逐步有所改观。比如同样是上面的输出，EL的写法可以是 `${r.department}`，调用数组也可以是`${list[0].name}` 。不过EL目前还没有支持逻辑控制，所以逻辑控制还是要用jstl的标签。

但至少在老三样之外提供了新的一种方式，并且使得使用**Helper**模式可以不需要必须用Scriptlet。

## EL中使用Helper

说的简单点，其实就是在jsp页面中，通过EL表达式可以调用Java实现的方法。获得类似`${helper.getflow(userInfo.bendiAndNationFlux[2][0])}` 。 其中，getflow是一个用Java写的静态方法。

而使用Scriptlet配合helper，则会出现下面的代码：

```java
<%
UserInfo userInfo = (UserInfo) request.getAttribute("userInfo");
long flow = (long[] )(userInfo.getBendiAndNationFlux().get(2))[0];
SheetAttendAction helper = (com.sanss.richtone.web.action.request.SheetAttendAction )request.getAttribute("helper");
%>

<%=  helper.cpSelectHelper(requestSheetForm.getManager(), spInfo.getCpCode(), spInfo.getCpName()) %>
```

光写出来的代码方面，不使用EL时已经要长很多了，明明只是一个调用取值显示的操作，却要先声明一系列的东西。同时，这些类型还要在jsp
的头上import进来。而IDE对jsp的import Class支持的并不好。所以确实相当麻烦。

对比一下可以发现，EL能够调用方法的话，可以带来多大的方便。使用Helper方法时，无论是Scriptlet还是EL表达式，在Controller层面，做
的事情都是类似的。

```java
//在controller里定义方法
  public static String getflow(long flow) {
    DecimalFormat format = new DecimalFormat("###0.0");
    long tmpFlow = flow / 1024;
    double df = 0;
    if (tmpFlow < 1) {
      return flow + "K";
    } else if (tmpFlow < 1024.0) {
      df = flow / 1024.0;

      return format.format(df) + "M";
    } else {
      df = flow / 1024.0 / 1024;
      return format.format(df) + "G";
    }

  }
  
  //在action中，注入属性
  @RequestMapping(value = "myflow", method = RequestMethod.GET)
  public String myflow(Model model, @ModelAttribute("mdn") String mdn, @ModelAttribute("userInfo") UserInfo userInfo) {

    model.addAttribute("helper", this);
    return "nubia/myflow";
  }
```

这样一来，定义自己的方法和使用这个方法就极为简便了。需要指出的是，EL表达式里面可以调用方法，即支持el里面带()调用，是**直到
servlet3.0标**准出现才成形的，只有在tomcat7使用，即便是~~tomcat6也不支持~~这种调用方式。从中，可以看出EL越来越强大趋势。
但也反过来可以证明过去方法之错误。

### el使用的进阶

在部分场合，可能不太好把helper变成attribute放在request中，此时另一种办法是直接在jsp中进行set.

```
<c:set var="UsermainHelper"
value="<%=new com.xxxx.helper.UsermainHelper()%>" scope="session" />

${UsermainHelper.getPassAndOtherNameLink(loginform) }
```
set之后就可以在el中用`${}`访问了。

更优化一点，在使用spring的情况下，可以用静态方法得到这个bean，此时可以这么写

```
<c:set var="UsermainHelper"
value='<%=com.xxxx.util.MyApplicationContextUtil.getBean("usermainHelper")%>' />
```

需要注意的是，因为getBean里面给入了字符串参数，所以value的引号**不能使用双引号，而要改用单引号**, 此时这个scope可以去掉也可以不去掉



## EL难道就不是Scriptlet？

如果使用过其他Web开发语言的话，可以发现EL表达式和在页面模板里写脚本语言很类似。比如 `${r.department}` 和 `<%= r.department%>` 
除了把${}换成了<%=%>实在没有其他区别， `${helper.getflow(userInfo.bendiAndNationFlux[2][0])}` 可能是写成了 `<%= getflow(userInfo.bendiAndNationFlux[2][0])%>` 。

实际上，目前的EL，除了没有逻辑判断的能力之外，已经具备了很多Scriptlet的特性。那么区别在哪里呢？

我觉得最关键的区别在于语言本身。所谓Scriptlet其实是Java Scriptlet，需要一系列的声明才能使用。强类型编译语言有很多的好处，但在页面
显示方面，并非其所长。所以，不得不发明一套新语言来走Scriptlet的路子。 而对于另外一些本身就是脚本的语言，重新发明一套EL就显得没有必要了。 

EL的Scriptlet和Java的Scriptlet完全是两码事情，倒是和ruby的Scriptlet几乎没有区别。
EL的支持来的有点慢，但好歹还是来了！

### 对EL未来的期盼

作为一个开发者，十分期望未来的EL能够再走一步，增加对 `if` `for`的原生支持，而不再需要使用麻烦的标签。能否发生这样的变化，就只有
再看发展了。


### 标签适用的情况

标签其实也有其存在的价值，至少包括：

1. 分页等相对组件化的元素；
2. 风格一致的表单。

对于那些有组件化特征的东西，标签还是很适用的。


而在EL有了调用method的能力后，helper模式可以做的更多，很多页面逻辑可以放到helper中去完成，即把`if` `for`封装在helper里面。
这应该是目前最值得推崇的一种页面代码模式了。



