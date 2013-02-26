---
layout: post
title: "change to ruby 2.0.0"
date: 2013-02-26 11:30
comments: true
categories: 
- ruby

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