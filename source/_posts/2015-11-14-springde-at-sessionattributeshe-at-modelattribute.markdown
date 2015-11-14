---
layout: post
title: "Spring的@SessionAttributes和@ModelAttribute在Redirect时的特殊表现"
date: 2015-11-14 22:50
comments: true
categories:
- java
- spring
- 技术
---

`@ModelAttribute` 在Spring中有两个地方可以填写：

1. Controller的Action method的参数前标注，提示需要设置该值  
2. Controller中单独的方法前标注，改方法通常不是action，但加注`@ModelAttribute`后会在Action method执行前被调用  

使用效果来讲就是确保第一种情况下，action method的参数会被设置，而设置的根据主要是以下4种：

1. 来自`@SessionAttributes`使用中被设置在session中的`ModelAttribute`  
2. 上面提到的第二个使用的方法中产生的对象  
3. 基于URI的模板变量+type converter  
4. 直接new的，即默认的构建方法
