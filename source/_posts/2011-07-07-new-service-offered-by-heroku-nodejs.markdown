---
layout: post
title: "Heroku的新服务"
date: 2011-07-07 18:48
comments: true
categories: 
- 技术
- 云计算
- heroku
---

Heroku发表了一系列介绍自己内部升级的文章。最重要的变化是开始支持除ruby/rack以外的语言和框架。起先加入了node.js，然后又加入了Clojure. Clojure是跑在jvm上面的一种语言，对这块没研究。

在heroku看来，ruby的高动态性和强调美感使她天生适合面向用户的web应用。Node.js的基于事件的搞并发使得它适合实时web。 Clojure使得需要correctness,performance,composability, optionally的组件成为可能，并且触及java的生态圈。

heroku开始支持Java. [heroku for java](http://blog.heroku.com/archives/2011/8/25/java/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+heroku+%28Heroku+News%29)
不支持war包比较让人痛苦。试着发布一个应用玩玩吧。

Real apps come from real developers Real developers wanted to use their own tools
