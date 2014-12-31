---
layout: post
title: "Mac 上折腾Ruby 2.2"
date: 2014-12-31 21:23
comments: true
categories:
- ruby
- mac
---

**节日驱动开发**再次发生作用，圣诞前夕，Rails和Ruby分布发布了新版本，4.2.0和2.2.0.
为此又开始了折腾。

先是在Ubuntu上安装了Ruby 2.2.0，一切都很顺利。Rails因为之前已升级到rc3的版本，所以再升上去就很容易了。

然后在mac上从源码安装新版ruby到rbenv下面。一开始也比较顺利，但安装完毕后执行`gem install bundle`报了
SSL的错误。Google一番，结论是OpenSSL需要升级，而`brew` 下面已经是最新的OpenSSL版本了，于是又说要更新brew。

```bash
brew update # 更新brew
brew install openssl # 安装最新的ssl
brew link openssl --force #建立关联
brew install curl-ca-bundle # 这个执行是失败的，原因似乎是在2014年去除了
```

然后再次运行，问题照旧。后来发现是因为brew安装的ssl位于`/usr/local/opt/openssl`
下，而mac自带的有一个系统本身的ssl，ruby编译时会始终使用默认的ssl。
解决办法是建立link或者索性在configure时指定

```bash
./configure --with-openssl-dir=`brew --prefix openssl` --disable-install-doc --prefix=/Users/me/.rbenv/versions/ruby-2.2

```

其中，`brew --prefix openssl`可以得到通过brew安装的openssl的具体位置。

虽然不是什么高深的东西，但折腾起来还是挺麻烦的。也难怪现在Ruby on Rails的入门门槛越来越高，而且
很多都是被挡在配置环境这第一道关口。
