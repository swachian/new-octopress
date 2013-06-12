---
layout: post
title: "my first gem"
date: 2013-06-12 17:02
comments: true
categories: 
- ruby
---

今天终于尝试做了第一个`gem`，其实挺简单的，至少在有了bundler之后。

先 `bundle gem act_as_xxx`，随后就可以编辑里面的内容，比如在`*.gemspec`里面加入描述。编辑好自己的gem后，运行`gem build act_as_xxx.gemspec`，这样一个新的gem就会编译出来。

```
  Successfully built RubyGem
  Name: act_as_xxx
  Version: 0.1.1
  File: act_as_xxx-0.1.1.gem
```

最后`gem push act_as_xxx-0.1.1.gem ` 就发布到rubygems.org上面了。

基本的流程是走通了，不过怎么怎么测试怎么调试等还需要进一步摸索。
