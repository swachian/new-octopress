---
layout: post
title: "自己生产sdoc"
date: 2015-04-09 12:26
comments: true
categories: 
- rails
- ruby
---

很长时间以来，使用ruby rails查api时都喜欢用Searchable API，又称sdoc。
原先都是直接去sdoc维护的站点下载的，只是这个站点的更新频率越来越低，所提供的ruby和rails的版本也略老，于是决定自己使用sdoc的gem来生成一下。

1. 先安装sdoc， `gem install sdoc`, 安装完成后会新增两个可执行文件`sdoc`和`sdoc-merge`

2. 进入自己下载的ruby源代码的父目录，执行
`sdoc --main ruby-2.2.1/README.md  -x test -x example -x bin -N -x lib/rdoc  --title "Ruby 2.2" --op ~/sdocruby-2.2 ruby-2.2.1 ruby-2.2.1/README`

其中，ruby-2.2.1是当前rails的版本，--op指示生成的sdoc所在的目录，-x是不要去解析这些内容，运行几分钟后，文件就生成了。

然后把生成的目录放到自己方便的地方即可。

参考链接：

[1](http://pjkh.com/articles/building-your-own-rails-and-ruby-searchable-api-docs/)
[2 懒人下载](http://pan.baidu.com/s/1i3vgC09)
