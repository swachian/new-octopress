---
layout: post
title: "Ruby Inside 3月链接"
date: 2012-04-19 11:23
comments: true
categories: 
- ruby
---

发现[Ruby Inside](http://www.rubyinside.com/march-2012-ruby-news-5841.html?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+RubyInside+%28Ruby+Inside%29)最近的
文章又好看了起来。选了一些细细研究如下。


* [GitHub's Ruby Style Guide](https://github.com/styleguide/ruby)  
很好的ruby编码规范，来自github，还澄清了我一些似是而非的概念。值得ruby学习者经常review。  
此外，还有[tomdoc](http://tomdoc.org/)做编码文档的规范，也需要进一步阅读。  


* [jekyll](http://rubysource.com/zero-to-jekyll-in-20-minutes/)

jekyll是一个输入markdown文件输出site的html的**引擎**。

```sh
$ mkdir your_blog
$ cd ./your_blog
$ mkdir _layouts _plugins _includes _posts css javascripts images
$ touch index.html _config.yml _layouts/default.html
```
目录树结构

```sh
├── README.md
├── _config.yml
├── _layouts
	└── default.html
├── _plugins
├── _includes
├── _posts
│   ├── 2012-03-27-your_first_post_in_markdown.md
│   └── 2012-03-27-your_second_post_in_textile.textile
├── css
│   └── screen.css
├── javascripts
├── images
└── index.html
```

```sh
$ jekyll --server --auto
```

文档的要求只有一个:

```sh
---
layout: default
title: Your First Post In Markdown
---
```

就会按markdown里面的layout产生内容。

这样就可以明白octopress和jekyll的关系了。o是利用了jekyll做引擎，根据jekyll的目录要求加入了css、布局、图片等，同时还有.rb的一些插件，于是有了这个blog系统。而jekyll则还可以用来写书。道理也是一样的。自己设计layout，然后运行上面的命令即可。


* [使用Nginx做分发的教程](http://spin.atomicobject.com/2012/02/28/load-balancing-and-reverse-proxying-with-nginx/)

基本的内容都有了。而且还有利用nginx实现转发时使用basic验证和加Authorization的例子。 

* [配备了bootstrap的Rails教程](http://news.railstutorial.org/ruby-on-rails-tutorial-now-with-twitters-boot)

Bootstrap 是一个优秀的CSS和UI框架，而这个正好是Rails所欠缺的。二者的结合将是威力巨大的。因为Rails可以解决开发中的
**编码效率**问题，但对**界面美化**却不能为力。而Bootstrap可以很好地弥补这一点。有点类似Jekyll和Octopress的关系。
**结果**都是可以让程序员和不具备界面美化能力的项目经理也可以设计出说得过去的应用。

* [ruby 2.0 garbage collection](http://patshaughnessy.net/2012/3/23/why-you-should-be-excited-about-garbage-collection-in-ruby-2-0)

* [building backbone js apps with ruby sinatra mongodb and haml](http://addyosmani.com/blog/building-backbone-js-apps-with-ruby-sinatra-mongodb-and-haml/)

全篇对backbone基本无介绍，火力集中在sinatra mongodb haml这些东西上了。文章的价值不大。