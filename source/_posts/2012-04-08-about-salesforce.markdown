---
layout: post
title: "About Salesforce"
date: 2012-04-08 13:41
comments: true
categories: 
- 笔记
---

Salesforce.com在1999年由前甲骨文高管 Marc Benioff 创立，他创办Salesforce的核心理念就是"No Software（消灭软件）". 指消灭安装在企业内部的软件，
转而使用互联网上的服务。

Salesforce的主要产品包括Sales Cloud（CRM）、Service Cloud、Chatter和Force.com等。下面是它的主要发展史：

* 1999年，Salesforce在美国旧金山成立。
* 2001年，推出了第一款SaaS应用CRM，同时也受到众多厂商和客户的热议。
* 2004年，Sunguard成为Salesforce第1000位用户。
* 2005年，推出了名为"AppExchange"的程序商店，以丰富用户选择。
* 2006年，推出了首个运行在云计算平台的语言Apex，并在语法上类似Java。
* 2007年，推出了它的PaaS平台Force.com，来让用户更方便地在Saleforce平台上开发在线应用，同时Salesforce凭借Force.com得到了华尔街日报的科技创新奖（Technology Innovation Award）。
* 2009年，Salesforce成为首家年收入达到10亿美元的云计算公司，并在年初推出了名为"Service Cloud"在线客户服务应用。
* 2010年，Salesforce将推出名为"Chatter"的企业级在线SNS服务，类似于企业内部的"LinkedIn"，同时其CRM应用已更名为"Sales Cloud"。

实现了多租户的模型，即每个用户享有一个虚拟出的应用实例，背后的数据库设计是关键。

Salesforce 团队不仅做了优化，
而且凭借着其很多核心成员来自于 Oracle 的背景，在数据库端做了很多高水平的优化，比如添加了很多貌似累赘的 Pivot 表来加快部分常用数据的读取。

salesforce的核心竞争力在于他们的数据库优化。  
他的s云就跑在他们的p云上面，他们的p云叫做force。有一套类似java的语言，允许他人作二次开发后进行部署。



