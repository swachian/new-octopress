---
layout: post
title: "rubygems的本地化cache"
date: 2011-06-17 14:48
comments: true
categories: 
- 技术
---

[本地化rubygem cache的git链接](https://github.com/akitaonrails/rubygems_proxy.git)

设计思想是：
1. 将rubygems.com指向本地的地址，例如127.0.0.1;
2. 每次有gem install的请求，先检查本地是否有该gem，已经有了则直接传输回去 ;
3. 如果本地没有，则先从远端下载到本地，然后再传输回去

这样就保证了自己曾经下载过的gem可以在本地有个案底，既节省下次安装的时间，又获得了备份。

update: 2011.6.19
直接用unicorn跑了起来，还是比较简洁的。unicorn中配置一个unicorn.conf.rb文件，直接用

    unicorn -c unicorn.conf.rb 

conf.rb文件的内容

    timeout(2000) #为了避免被reset，调大timeout的时间
    listen 8080


可在Gemfile中设置本地cache的地址,然后bundle install

但bundle 本身可以用下面这个方法来要求通过本地代理来安装

    gem install bundle --source='http://127.0.0.1:3000'



