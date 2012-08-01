---
layout: post
title: "Heroku's Buildpacks and Redeploy for jekyll and octopress"
date: 2012-07-21 09:46
comments: true
categories: 
- 神器
- heroku
---

Heroku是永远能给人带来惊喜的厂商，[Builpacks](http://blog.heroku.com/archives/2012/7/17/buildpacks/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+heroku+%28Heroku+News%29)
只得好好研究一下。从模式上来说，其实就是利用了adapter+template的方式，把变化的部分提取出来变成**buildpack**。
难能可贵的是，heroku是允许定制化对这部分内容进行操作和配置的。

试了一下，jekyll的是完全可以产生的。但是对octopress并非完全适用。
首先，对heroku而言，默认有一个`.slugignore`文件中会把source等3个文件排除在外，而没有这3个文件无法generate。但有了这3个文件，slug的体积就变大。

其次，有个gem需要使用python的库，无法在heroku上直接运行。

而作为苦逼的中国用户，还会碰到编码问题。

合在一起，其实原因可归结为一个，即如果generate牵涉的东西太多则不适合在heroku这样的平台按照 build/run的方式使用，毕竟环境不是完全能模拟本机的，
也不是自己的服务器环境可以自己装。

所以，在浪费了无数的时间之后，决定还是先用略显不舒服的办法继续运行。


