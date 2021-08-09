---
layout: post
title: "Deploy a Rails 4 app to Heroku"
date: 2013-03-04 20:03
comments: true
categories: 
- ruby
- rails
- heroku
---

近期从`rvm`切换到了`rbenv`, ruby也全面升级到了2.0.0版本， Rails也装了4.0.0.beta，似乎一切欣欣向荣的样子。  
为了方便测试获取一些设备的浏览器信息，写了一个自动获取并分析`User-Agent`的应用，并确定发布到heroku上。
在发布的过程中，发现还是有一些陷阱，也差不多被折腾了一个来小时,所以决定记录一下。


### 0 事先准备

虽然我用Heroku的时间可以追溯到很久以前，从 scanty 到 octopress，但到这次才发现其实之前我没在heroku上部署过Rails应用。
但这也意味着，第一我很早以前就有了Heroku的帐号，第二我的机器上的ssh-key同heroku都是打通的，第三已经安装了heroku这个gem。

### 1 创建应用

首先执行 
```
heroku apps:create user-agent-show2

```
这样会在heroku处创建一个stack，目前版本是`cedar`. 同时，在.git/config里面会增加一个heroku分支
```
[remote "heroku"]
        url = git@heroku.com:user-agent-show.git
        fetch = +refs/heads/*:refs/remotes/heroku/*
```


### 2 Git push

随后就可以执行
```
git push heroku
```
部署应用了。
但这里就会碰到陷阱。首先，Heroku是支持pg的应用，所以需要在Gemfile里增加`gem 'pg'`，同时也要确保这个gem在本机有依赖的Native包。对于ubuntu，
基本需要安装`apt-get install libpq-dev ` 这个包，不过这个包很小，只有900多KB。

其次，对于assets，可以选择预先执行`rake assets:precompile`，也可也让heroku在部署时执行。但默认情况下生成的js和css文件是访问不到的。
因为rails 4默认生成environments/production.rb中是这样配置的
```
config.serve_static_assets = false
```
这个会导致thin或者unicorn不负责对静态文件的处理。如果是基于Nginx或者Apache之类的部署，这点毫无问题，因为代理在收到请求后就处理掉了，但
对于heroku，则在起初时是必须由thin负责这部分内容的，因此需要把上面的配置改成
```
config.serve_static_assets = true
```
这样才能保证静态文件被正常访问。

### 3 数据库更新

```
heroku run rake db:migrate
```

push成功后，就可以执行迁移了。也能执行`heroku run bash` 等命令去查看云服务器的实际运行情况。