---
layout: post
title: "Inside Github"
date: 2012-05-29 11:18
comments: true
categories: 
- 笔记
- 神器
---

关于[Inside Github](http://www.slideshare.net/rubymeetup/inside-github-with-chris-wanstrath)
的笔记。讲了整个stack里用到的东西，以及‘胶水’。 @defunkt

创设的初衷： A git hub - learning, code hosting, etc. 最早只是让代码和评论浏览器化。

Kyle Neath ， 让页面漂亮的家伙，应该是视觉设计师。

web站点实质上是一系列不同的组件。有些是产生和提交HTML，但更多的部分则不是。GitHub由
4四大**frameworks**组成。

* rails
  Github.com, Gist, ...
* resque
  Background processing, G大约有50个不同的类型
* chimney
  All git calls happen over the write
* utils
   意外日志，统计，辅助应用等

### rails
  
  他们使用Rails 2.2.2作为web框架，采用补丁的方式解决安全、乐意接受的新特性，但拒绝对站点做整体迁移。
GitHub的Rails 代码量仅仅是20,000行，这个真的很短。用到了27个插件，50个gem。主要的插件包括：

* [shopify/active_merchant](https://github.com/Shopify/active_merchant)  
  支付的抽象库。有中国人给家里alipay的补丁  
* [lgn21st/s3_swf_upload](https://github.com/lgn21st/s3_swf_upload)  a flash base upload component  
* [technoweenie/serialized_attributes](https://github.com/technoweenie/serialized_attributes)  
* [query_trace](https://github.com/ntalbott/query_trace) 告诉你query究竟发生在哪里，比如哪个rhtml，哪个controller  
* [query_analyzer](https://github.com/jeberly/query-analyzer)  
除了第一个，后面4个都已经不怎么更新。实际上后面3个是已经纳入到Rails 3.2里面了。

Gems:

* [albino](https://github.com/github/albino) 标记高亮  
* [ar-extensions]() 主要是用于提高使用ar导入的效率，而且又一些增强的特性，主要还是效率。Rails3的已经改成[activerecord-import](https://github.com/zdennis/activerecord-import/wiki)  
* [aws-s3]()
* [faker](https://github.com/EmmanuelOga/ffaker) 造数据的  
* [faraday](https://github.com/technoweenie/faraday) HTTP的客户端，依旧**活跃**，值得细细研究  
* [github/markup](https://github.com/github/markup)  
* [jekyll]
* [gollum](https://github.com/github/gollum) 和jekyll差不多，是产生wiki的引擎  
* [redis-rb](https://github.com/redis/redis-rb) redis的客户端  
* [unicorn] 16 workers

Rack:

* Rack::Bug  
Coderack  
* nerdEd/rack-validate  
* webficient/rack-tidy  
* talison/rack-mobile-detect  

Nginx当然不让 :  
* Limit Zone  
* Limit Request: Anti-DDOS
* memcached support  
* Push Module: comet!  

Git: 
* [grit](https://github.com/mojombo/grit) 通过ruby直接对git库使用read/write，是一个Ruby对Git的实现  
 
### chimney(smoke) 

这应该是指一种通信方式，smoke意味硝烟、烽火  
Smoke calls  

* BERT-RPC 
  另有[Introducing BERT and BERT-RPC](https://github.com/blog/531-introducing-bert-and-bert-rpc)，主要优势似乎是利用erlang，对大二进制处理的更好    
 [xdite的笔记](http://blog.xdite.net/posts/2011/12/10/github-flavored-ruby/)  
* [mojombo/bertrpc](https://github.com/mojombo/bertrpc)  
* [chimney] 
  proprietary 的库，怀疑是erlang写的  
  让RPC clients知道如何找到server，路由内容存放在Redis中  
* proxymachine 
  有点类似nodeload替换的功能，不过这个也用于git clone  
  能用来作为所有tcp链接的代理  
* JSON-RPC 
* node.js  
  downloads  
  event streams  
* hubot  

### resque

* [resque](https://github.com/defunkt/resque)  
  Resque is a Redis-backed Ruby library for creating background jobs, placing them on multiple queues, and processing them later

* 优先等级
  - 严重
  - 高
  - 低

* 队列任务  
  - page 产生页面  
  - archive 打包tar  
  - search  
    * 使用[solr](https://github.com/apache/solr) 基于Lucene的HTTP接口，所以使用简单  

* 数据库是MySql 5

### utils  

 * comet loading  
 * nagios 负责监控
 * resque 的web  
 * collectd 用于手机负载、RAM等的信息  
 * pingdom 短信系统  
 * tender 一个客服系统  

测试仅仅是使用 test/unit, machinist当做fixtures的工具，  ci joe做push后的自动测试工具  
 

而他的CTO Tom 则给了[这些[(https://speakerdeck.com/u/mojombo/p/github-flavored-ruby)  

里面提到了**RDD**的概念:  
readme driven development 
先把README叫做SPEC，完成一点，就把内容移到README中。

先写TomDOC再写代码则是在code层面这种编码思想的体现。这是写给未来的自己看的。不然很多东西就会归时间的魔鬼所有。






  


