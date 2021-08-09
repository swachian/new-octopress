---
layout: post
title: "Where to Use NODEJS"
date: 2012-05-22 09:27
comments: true
categories: 
- 技术
---


近期打算用nodejs做个东西，个人感觉它承担这个任务是相当合适的。  
今天又读到一篇讲[为什么从NodeJS迁移到RoR](http://blog.targeterapp.com/post/22984987832/why-we-moved-from-nodejs-to-ror)。
作者列举的主要理由如下：

1. NodeJS适合 **short lived requests**。 并不是很明确这里的request是指什么，似乎就是异步先返回的意思，但这样的体验应该不会好。
2. 框架很年轻，变动很大。这个经历过Rails的人都明白，估计NodeJS的变动更大，因为js本身就很bt。
3. Testing的表现一般，比Django RoR的测试平台还是差距很大。
4. 他需要Cache所有的东西。Node的强项是每秒千万次点击承受力，对cache似乎并不擅长。1000 RPS的访问压力，对Rails+Nginx已经是小菜一碟。

然后作者又推荐了一篇[Guide](http://nodeguide.com/convincing_the_boss.html)
里面提到的了node.js适合与不适合的。

Bad Use Cases:

* CPU重度使用  
  js适合高I/O的，而不适合重CPU的。视频编码解码、人工智能等CPU hungry的软件还是用C吧。有提到js写C的addons是挺方便的  
* 简单的CRUD / HTML apps  
  js下的是不如Rails，CakePHP或者Django那样强有力的  
* 再搭配其他新技术  
  比如NoSQL，这样会让技术风险做乘法，毕竟两样都不熟的东西组合在一起，会提出更多的挑战。而这些可能对你做出吸引人的业务没有magically的提高  

Good Use Cases:

* JSON APIs  
  对包装数据资源，比如数据库和web services，然后将他们转换成JSON接口暴露给外部使用  
* Sigle page apps  
  指那些富客户端的页面应用，如Gmail。好处是可以在客户端和服务端共享很多代码，比如验证确认类的。同时，也给处理多请求的能力有了用武之地  
* 利用现有软件  
  可以fork多个子进程并对这些进程的输出当做一个stream来处理，使得node成为一个很好的杠杆现存软件的选择。  
* Streaming data  
  http实质上是streams，只是多年来都被当成atomic events来处理了。但js可以利用这一点。在诸如实时分析文件上传、多数据层间的proxy搭建等一显身手
* Soft Realtime Applications  
  但有gc的存在，所以不适合作为hard realtime的实现，对允许不要求始终如一的响应时间的系统还是合适的。Hard方面的更好的选择是Erlang。


我打算做的东西不在bad case之类，和good case 基本沾边。目前的结论是值得一试。
  

