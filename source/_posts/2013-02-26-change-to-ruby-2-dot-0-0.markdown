
layout: post
title: "Change to Ruby 2.0.0"
date: 2013-02-26 11:30
comments: true
categories:
- ruby
- heroku

---

借着Ruby 2.0.0发布的东风，又加之Rails 也发布了4.0.beta来给献礼，营造了RR24，我也把octopress升级到了ruby 2.0.0.

步骤如下：

1. 在Gemfile中加入 `ruby "2.0.0"`
2. 更新Gemfile中其他的一些gem，把octopress最新版的内容加进来即可，否则可能还是不能和2.0兼容的
3. `bundle intall`, `bundle install --binstubs`
4. `git commit -a`
5. `git push heroku`

```
Counting objects: 119, done.
Compressing objects: 100% (59/59), done.
Writing objects: 100% (60/60), 5.46 KiB, done.
Total 60 (delta 32), reused 0 (delta 0)
-----> Deleting 5 files matching .slugignore patterns.
-----> Ruby/Rack app detected
-----> Using Ruby version: ruby-2.0.0
-----> Installing dependencies using Bundler version 1.3.0.pre.5
       Ruby version change detected. Clearing bundler cache.
       Old: ruby 1.9.2p290 (2011-07-09 revision 32553) [x86_64-linux]
       New: ruby 2.0.0p0 (2013-02-24 revision 39474) [x86_64-linux]
       Running: bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin --deployment
       Fetching gem metadata from http://ruby.taobao.org/.
       Fetching full source index from http://ruby.taobao.org/
       Installing daemons (1.1.8)
       Installing eventmachine (0.12.10)
       Installing rack (1.4.1)
       Installing rack-protection (1.3.2)
       Installing tilt (1.3.3)
       Installing sinatra (1.3.5)
       Installing thin (1.4.1)
       Using bundler (1.3.0.pre.5)
       Your bundle is complete! It was installed into ./vendor/bundle
       Cleaning up the bundler cache.
-----> Discovering process types
       Procfile declares types     -> (none)
       Default types for Ruby/Rack -> console, rake, web

-----> Compiled slug size: 30.5MB
-----> Launching... done, v48
```

但我不太理解slug size为啥变大了。

而且和thin里面的eventmachine配合似乎有问题，可能是版本太老，也可能是别的什么，
于是改用了unicorn，又折腾了Procfile

```
web: bundle exec unicorn -p $PORT
```

```
Total 3 (delta 1), reused 0 (delta 0)
-----> Deleting 5 files matching .slugignore patterns.
-----> Ruby/Rack app detected
-----> Using Ruby version: ruby-2.0.0
-----> Installing dependencies using Bundler version 1.3.0.pre.5
       Running: bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin --deployment
       Using kgio (2.8.0)
       Using rack (1.4.5)
       Using rack-protection (1.3.2)
       Using raindrops (0.10.0)
       Using tilt (1.3.3)
       Using sinatra (1.3.5)
       Using unicorn (4.6.2)
       Using bundler (1.3.0.pre.5)
       Your bundle is complete! It was installed into ./vendor/bundle
       Cleaning up the bundler cache.
       Would have removed thin (1.4.1)
       Would have removed daemons (1.1.9)
       Would have removed daemons (1.1.8)
       Would have removed thin (1.5.0)
       Would have removed rack (1.4.1)
       Would have removed eventmachine (1.0.0)
       Would have removed eventmachine (0.12.10)
-----> Discovering process types
       Procfile declares types     -> web
       Default types for Ruby/Rack -> console, rake

-----> Compiled slug size: 35.9MB
-----> Launching... done, v53
```

最后重新弄了一下，发现还是很大。

```
Writing objects: 100% (3/3), 281 bytes, done.
Total 3 (delta 2), reused 0 (delta 0)
-----> Deleting 5 files matching .slugignore patterns.
-----> Ruby/Rack app detected
-----> Using Ruby version: ruby-2.0.0
-----> Installing dependencies using Bundler version 1.3.0.pre.5
       Running: bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin --deployment
       Using kgio (2.8.0)
       Using rack (1.4.5)
       Using rack-protection (1.3.2)
       Using raindrops (0.10.0)
       Using tilt (1.3.3)
       Using sinatra (1.3.5)
       Using unicorn (4.6.2)
       Using bundler (1.3.0.pre.5)
       Your bundle is complete! It was installed into ./vendor/bundle
       Cleaning up the bundler cache.
-----> Discovering process types
       Procfile declares types     -> web
       Default types for Ruby/Rack -> console, rake

-----> Compiled slug size: 27.3MB
-----> Launching... done, v5
       http://octopresszhangyu.herokuapp.com deployed to Heroku
```

感觉adam不再怎么发文之后，Heroku有点日趋堕落的趋势。另外，在Procfile里面运用unicorn绝对是个好主义。其效果类似一个dyno(ubuntu)上跑了几个unicorn的进程，
明显处理能力会强于只有一个实例的thin。以上灵感来自[unicorn的部署高人](http://blog.codeship.io/2012/05/06/Unicorn-on-Heroku.html)。

今日装某个系统，发现有掉到了libyaml这个沟里。试了几次，最后发现是 `LD_LIBRARY_PATH=`的缘故。
编译好libyaml，在加入到上面这个环境变量中，ruby才能读的出来。

