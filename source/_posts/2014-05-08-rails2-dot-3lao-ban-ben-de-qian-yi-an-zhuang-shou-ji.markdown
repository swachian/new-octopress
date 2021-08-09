---
layout: post
title: "Rails2.3老版本的迁移安装手记"
date: 2014-05-08 22:08
comments: true
categories: 
- rails
---


一个五六年前开发的Rails应用更换主机需要重新部署。这个Rails的版本还是2.3.5，Ruby版本只是1.8.7. 因为是内部的一个小应用，所以一直也没翻新升级。彼时还没有bundle，而现在对版本依赖的管理已经离不开bundle了。
下面就是记录一下如何用bundle来安装Rails 2.3的应用。

### 下载ruby 1.8.7

减少麻烦，还是保持一致的版本迁移。新机器暂时没有安装其他ruby版本的需求，所以暂不考虑rbenv。

```sh
wget http://ruby.taobao.org/mirrors/ruby/ruby-1.8.7-p358.tar.gz
tar -zxvf ruby-1.8.7-p358.tar.gz 
cd ruby-1.8.7-p358
./configure --prefix=/usr/local/ruby187
make
make install
/usr/local/ruby187/bin/ruby -ropenssl -rzlib -rreadline -e "puts :success" 
```

看到输出`success`后，证明ruby各安装库已全部编译进去。主机是一台CentOS 6.4，所以安装1.8.7相当之顺利。
安装完毕后，把ruby的运行路径加到环境变量PATH的最前面。

### 安装rubygems


这个已经很久没有手动安装了，ree和ruby1.9之后rubygems都集成到ruby里面去了，1.8.7还是需要手工安装的。为了减少麻烦，比如能安装thin、能使用bundle、又尽量满足五年前的gem环境，选择了1.4.0.

```sh
wget http://rubyforge.org/frs/download.php/73763/rubygems-1.4.0.tgz
tar -zxvf rubygems-1.4.0.tgz 
cd rubygems-1.4.0
ruby setup.rb 
```

### 安装Oracle即时客户端和ruby-oci8


这个东西现在安装倒比以前简单些了。具体可以参考ruby-oci8的官方帮助，关键是要下载3个instant相关的客户端。其实sdk等两个包是很小的，最后都解压到一个目录下。随后，就是设置`LD_LIBRARY_PATH`的值。关键一点是注意不要配错这个环境变量指向的路径。

```sh
export LD_LIBRARY_PATH=/opt/instantclient_10_2:/usr/local/lib:/usr/lib
wget http://dl.bintray.com/kubo/generic/ruby-oci8-2.0.6.tar.gz
tar -zxvf ruby-oci8-2.0.6.tar.gz 
cd ruby-oci8-2.0.6
make
make install
```

### Gemfile和bundle

```ruby
source "http://ruby.taobao.org"

gem 'rails', '2.3.5'

gem 'activeresource', '2.3.5'
gem 'activesupport', '2.3.5'
gem 'capistrano', '2.5.17'
gem 'fastthread', '1.0.7'
gem 'highline', '1.5.2'
gem 'json_pure', '1.4.3'
gem 'nokogiri', '1.4.1'
gem 'rack', '1.0.1'
gem 'rake', '0.8.7'
gem 'RedCloth', '4.2.0'
gem 'rubyforge', '2.0.4'

gem "haml",  '3.0.12'
gem 'will_paginate', '2.2.2'
gem 'paperclip', '2.3.1'
gem 'formtastic', '0.9.8'
gem 'jintastic', '1.1.0'
gem 'ruby-mp3info', '0.6.13'
gem 'mime-types', '1.16'
gem "authlogic", '2.1.5'
gem "acl9", '0.12.0'
gem "paginator", '1.1.1'
gem "spreadsheet", '0.6.4.1'

gem "thin", "0.5.2"
gem 'activerecord-oracle_enhanced-adapter', '1.2.4'   

gem 'sqlite3-ruby'
gem  'rest-client',  '1.6.7'  
```

然后执行`bundle install` , 相关的Gem就可以安装到位了。 `thin start -e production` ， 通过这个命令应用就能在生产环境下启动了。


