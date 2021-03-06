---
layout: post
title: "2014 Rails Hosting 调查"
date: 2014-08-16 16:03
comments: true
categories:
- rails
---


2014年是DHH公开Rails的10周年，整个社区范围又进行了一次关于
Rails部署主机的[调查](http://rails-hosting.com/Results/2014/index.html).
参加的人数并不算多，1000+。

一. 人口分布

参加调查的人，普遍拥有3-5年和5-7年的Rails工作经历。
个人差不多是7年了，再早的也确实不多。而小于1年的比例很低，
或许是新手都还不会参与部署的事情吧。

除了Rails之外，使用其他Ruby 框架的用户依然不多。
而且大都只是在一些特定的项目上使用Sinatra Padrino这些更轻量的框架。

参加调研的主要群体还是Web开发者（Web Developer），
以及部分系统管理员和DevOps（含义为开发带运营）。

大部分现在日常维护的Rails应用在5个以内，超过15个的就比较少了。

二. 软件

Ruby的版本，主流已经是2.0和2.1，但还有很大一部分在继续使用1.9.3

Rails的版本，则使用最多的是4.0，3.2和2.3.x。
和我手头的也比较接近吧。

开发环境，这方面当然是Mac占据了75%的优势，剩下20%是Linux，
还有低于3%是Windows。这个毫无疑问，运行Rails至少需要一个
Linux，而最方便和快捷的确实Mac。而部署的话，最后还是绕不开Linux。

有一半以上的人在生产环境也使用了Rvm和Rbenv这些ruby版本管理工具。
不过rvm的占有率还是比rbenv高那么多倒是没有想到。  
30%的人都不跟踪生产环境的运行产生的例外.目前也没有一统江湖的工具选择。
以前的霸主是Airbrake，不知道**HoneyBadger**是什么状态。

Rails不使用监控工具的比例很高，超过一半了，这可能也是一种社区文化吧。
**Pingdom**和Nagios使用的还是挺多的。

Nginx+Unicorn已经取代了Nginx+Passenger，成为最主流的部署方式。
**Puma**也获得了良好的增长。

三. 社区

大部分Rails的软件都是新软件，说不清这点是好是坏。
参加社区大会活动的也是少数。程序员还是宅男居多啊。

有过部署其他语言应用的调查者比例显著下降，看来新人不少。
而且即使部署过其他语言的，也是Php,Node.js，3个js前端框架和Django。

Rails的部署大部分人认为比其他的容易。大部分都认为自己的Linux水平是胜任的、精通的、专家级别的。
是Rails的开发者都那么自信、还是认为这样就算够用了？

性能监控工具的使用比例很高，New Relic是统治者。
Monit是主要的保证程序继续运行的工具。考虑到Unicorn，确实不是必须的了。

**Chef**和**Puppet**是最主要的配置管理工具。

四. 版本控制

不使用版本控制的Rails开发者是不存在的。
毫无疑问，主流是git，大部分svn的用户都迁移了过来。

github bitbucket是最主要的服务托管主机。当然，也有很多是使用
自己的主机。

五. 自动化部署

Capistrano是首要的选择，但Git也变成了一种主要是部署工具。
Heroku是这方面的典型代表吧。

至于对部署过程的满意程度，则是永远没有终点的。

六. 数据库

MySQL 和 PostgreSQL是主要Rails数据库选择。
其实互联网行业去IOE应该是个伪命题，因为互联网企业普遍起步的时候各种资源紧张，
一直是以免费的开源的软件为主，也只有阿里这种以前学银行让IBM Sun
给他们做项目的半路出家的互联网公司，才有去IOE的需求。但反过来对银行、金融界、大国企都带来了冲击。

个人觉得二者之间还是MySQL吧。只是很多托管站点确实不再提供MySQL的选项。

NoSQL里面不出意外，Redis和Mongodb的接触者是较多的。
但是，竟然把**ElasticSearch**也算作一种NoSQL。
HBase CouchDB和Rails社区还是不搭。

七. 主机

Amazon的云服务是国外最流行的。自己的业务，确实还是找个虚拟机就好。

大部分人满意现在的部署选择，而最大的不满还是价格。看来用Rails的普遍喜欢精打细算。
单个应用的月开销集中在25美金一个月以下，但是上万美金一个月的也不少。

大部分在部署和主机上的预算小于月预算的10%。同运营一个公司比较起来，
部署和服务器方面的开销确实只是小头。
