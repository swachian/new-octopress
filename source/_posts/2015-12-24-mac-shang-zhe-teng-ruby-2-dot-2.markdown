---
layout: post
title: "Mac 上折腾Ruby 2.2(续)"
date: 2015-12-24 21:24
comments: true
categories:
- mac
- ruby
---

又是一年圣诞了，继去年[Mac上折腾Ruby](http://octopresszhangyu.herokuapp.com/blog/2014/12/31/mac-shang-zhe-teng-ruby-2-dot-2/)之后，这次继续折腾。只是版本换成了~~2.2.4~~ 2.3 以及
是为了解决readline的问题。

按 https://github.com/guard/guard/wiki/Add-Readline-support-to-Ruby-on-Mac-OS-X  
的说法:

> If you are on Mac OS X and have problems with either Guard not reacting to file changes or Pry behaving strangely, then you probably suffer under a Ruby build that uses libedit instead of readline.

所以在前次的基础上，要进一步增加编译选项。

```bash
./configure --with-openssl-dir=`brew --prefix openssl` --disable-install-doc --prefix=/Users/me/.rbenv/versions/ruby-2.3  --with-readline-dir=`brew --prefix readline`
```

其中
```bash
--with-readline-dir=`brew --prefix readline`
```
 就是针对readline增加的选项。

加上之后，irb支持中文了，pry也支持历史记录浏览了。

./configure --with-openssl-dir=`brew --prefix openssl@1.1` --disable-install-doc --prefix=/Users/yuzhang/.rbenv/versions/ruby-2.6.9  --with-readline-dir=`brew --prefix readline`

rbenv install 2.7.1

brew install shared-mime-info