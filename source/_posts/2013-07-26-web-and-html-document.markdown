---
layout: post
title: "Web and HTML Document"
date: 2013-07-26 09:07
comments: true
categories: 
---

DHH在2013年的rails conf上做了关于类37signals web应用发展方向的报告。听了之后，还是解除了很大的迷茫。

工作十余年，开发Web应用也八九年了。期间研究过Flex，也写过不少ajax。但到今天却觉得Web的form提交然后出结果才是真正最有用的。
我们的下单，填填表格，登录等等，讲到底需要的只是一个让人知道怎么填的form，然后简单的提交就足够了。其余的东西再花哨，很多时候对解决问题并没有实质性的帮助。  
然而，富客户端应用也是客观存在的，甚至有js重度客户端应用将取代HTML应用的论调甚嚣尘上。以我的感觉判断，这是不太会发生的。原因在于js的开发很麻烦，工作量其实是很大的，而且也限制死了可以使用的工具。要取得一个简单的页面所达到的效果，完全采用js会产生巨大的工作量。而Web应用至今而且也将继续是大量表单类的应用。只要客户端的开发难度、工作量依然如此同服务端不成比例，那么就很难成为主流，更别提替换HTML了。  
所以，在这一点上毫无疑问我赞同D大神的，重客户端应用不可能取代Web HTML应用。

DHH陈述的突破之处在于提出这种HTML应用为 **document-based** Web ，以同google 地图这种应用区分开来。Web由于其简单或者说简陋，想要丰富它或者取代它的技术一直没中断过。从Java Applet开始，到flash，Siverlight等等，都曾经让Web的效果不堪一击。然而，20年来的现实情况是，不拥抱Document的技术最终都在HTML之前走了下坡路。D大神把从90年代中期至今的挑战HTML技术串联起来说，体现了磅礴的气势和全面的大局观。

与此同时，他也认为Document需要继续发展，这就是他说的再Basecamp，其实也就是Rails4中增加的新技术，其实本质就是caching。具体包括：

* key-based cache (generational caching)  
* Russian Doll nested caching, 4 level, touch: true, partial md5  
* Turbolinks process persistence, (pajx)  
* Polling for js updates(类似rjs)  

核心内容就是提高HTML在浏览器上的速度。而Caching能大规模流行的基础是**内存红利**.

<table>
<tr><td>  2003年  </td><td>  512MB </td><td>  $49  </td></tr>
<tr><td>  2013年  </td><td>  8GB   </td><td>  $29  </td></tr>
</table>

不过此次Web面临的挑战和多年来历次遇到的还是有很大不同的。不管是flash还是applet，他们都是想作为整体的HTML+CSS+Javascript发起挑战。而这次却是原来Web整体中的Javascript和HTML谁唱主角之争。区别在于JS和HTML所占比例及所显示页面数量的巨大区别。  

但是，只要Web还够简单，只要js的开发工作量还很繁重，那么产生HTML依然还是主要的Web应用模式。
