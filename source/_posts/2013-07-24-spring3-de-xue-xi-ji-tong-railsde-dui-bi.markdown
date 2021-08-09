---
layout: post
title: "Spring3 的学习及同Rails的对比"
date: 2013-07-24 23:53
comments: true
categories:
- java
- spring
---

补记，原始记录与[gist](https://gist.github.com/swachian/6070011)上。

用SSH进行开发已经五六年了，这个架构这些年一直没动过。随着Spring的日益兴盛，而Struts2相对停滞沉闷且安全漏洞始终没有很好地解决。
因此决定全面转换到Spring，即采用Spring MVC。下面是一些自己的体会。

## 总体感觉

Spring引以为豪的是依赖注入，其目的是方便组装，更现实的意义应该是方便测试。放在main或者test文件里，就可以调用。这一点确实对
web开发很重要，避免了对容器的过度依赖。

而它的MVC凑合着也能用用。比起Struts2几乎已经不分伯仲了，比Rails那就差的远了。

## 静态资源

静态资源的处理是最大的进入。终于全部放到某个目录下了，这样偏于集中管理和存放规范。配置也比较简单。

## 控制器

MVC中的C，由Mapping选择和交付处理两个模块组成。Mapping基本不需要写什么xml的内容了，改成了在controller的class文件里写annotation。`@RequestMapping`, `@Controller` 虽然还是有点啰嗦，还是可以接受的。引入Restful可以说是一大进步，Java的框架页终于开始支持 **PathParameter** 。这些都是明显受到了Rails的影响，而且也学的相当到位。

```
  @Autowired
	HttpServletRequest request = null;

	@Autowired
    HttpSession session = null;
```

这样写，request和session就可以被注入了，甚至连setter的方法也不用设置，应该是直接类型注入的。查了一下`@Autowired`也确实优先按类的类型注入。

### 参数填写

尤其是依靠 **依赖注入** 在设置参数、设置request等方面有着突出的表现。较之struts2的 `user.name`式命名方式， `name`直接赋值给User类型的参数是更合理些的。这方面做得真的很棒。

### 参数验证

这个就比较差了。写在model里的annotation会一场臃肿，表现力远远还不如直接写java。

### C和V之间的信息传递

Controller和View之间传递主要包含两个部分，一个是渲染的view的类型，另一个就是controller里面参数的数据。这部分也已经做的很不错了。`model.addAttribution()` `return "sss/home` 都已经很简洁。对HTML和JSON的支持也都不错。

## 视图

### 视图的代码

视图层方面又多了很多标签。个人不喜欢标签，标签就是code，表达力还不如java的code制造方式。每个框架还企图再造一套标签，这有什么用的意义呢？

### 布局

视图方面是用的tiles，伴随着struts1出来的东西了，凑合着也能用用，比Rails是差远了。

### 分页

~~这个可能不单单是视图层面的问题，而是属于整个栈的。没有特别简单的整合办法。~~

JpaRepositories, PageRepositories都支持分页和排序了，再加一个绘制的标签或helper，基本也相当凑合了可以。

## 模型

之前认为spring没有自己的模型。但仔细看下来，spring data jpa正是spring的模型层。借用hibernate做provider，可以提供相当优秀的存储层和Pojo模型。加之java spring擅长的事务处理，这部分已经很强悍了。

并且，居然还增加了对动态find方法的支持，进步相当明显。

Spring3已经具备了一个可以独立运作的MVC库，去除Struts2已经水到渠成。模型层和控制层已经很强了。当然，视图层还是比较弱的。
所以，对于没有视图的web应用，比如作为接口机或者配合json的应用，spring已经很不错。性能、事务方面java还是很强悍的。
