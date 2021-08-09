---
layout: post
title: "Clojure is really pesky"
date: 2013-07-09 22:07
comments: true
categories:
- 技术
---

最早知道clojure，是在Heroku宣布[支持](https://blog.heroku.com/archives/2011/7/5/clojure_on_heroku)[它](http://devcenter.heroku.com/articles/clojure)，这是Heroku支持的第三种语言。知道彼时这个东西挺火。应该和闭包什么的有关联。

这次看七周七语言，终于得以一睹真容。知道了clojure其实就是Lisp的一个JVM实现。
不过今天试用了一下clojure，感觉这个东西不太灵。
基于JVM的设计思路听上去不错，但仔细想想JVM的lib真有那么大的意义吗？答案是否定的。我不太相信用惯了其他语言的人会喜欢在新语言中继续调用java的内容。在ruby中，我不会有兴趣去调用java。一旦用惯了clojure也不太可能再接受调用java的api。对比起来，scala倒是和java结合的挺紧密。

变成jvm的一部分，一大恶果就是启动变慢，从而作为脚本功能来跑很不美。毕竟一个jvm启动的时间很长，内存消耗也很大，对于处理任务极其简单的情况下，jvm启动的时间和内存开销显然过大了。
其次，融入jvm中，意味着需要ide的配合。无论哪种ide，都是很重的，因此很是麻烦。
叠加起来，就是导致这种基于jvm模式的开发是不令人愉快的。

而Lisp程序员似乎都喜欢用emacs，emacs和ide兼容，呵呵，这是在开什么玩笑。注定这东西的推广在开发层面会存在很大的障碍。

当然，天下英雄用java做clojure scala甚至jruby也不是没原因的。Jvm的性能确实很好，底层的库也很齐全，安装clojure也比较方便，但clojure又引入了leinxxx。不过Java的开发效率毕竟比C高，基于java开发新的语言大概也容易一些。另外就是需要连接数据库等组件都是现成的。这就使得在java上涌现出了很多二次开发的语言。可能，这才是那么多Java实现的根本原因。


但是，个人不太看好就因为用java实现，这些新语言就会被java开发的主流程接纳。道理很简单，混在jvm里面只是有利于复用已有jvm的机器（这点其实也不太重要），好歹部署还算方便，然而对开发而言完全是另学一套，而同时加上的枷锁和限制却更多了。  

真的要给java注入活力，最直接了当的办法是让java中调用ruby clojure等，而且是要方便地调用。   伟大语言才会诞生伟大的框架和lib，而现在这种只解决新语言中调用java lib，其实是不利于java王者归来的。只是这条路这些年已经无人深入了。

除了和JVM跳舞令人哭笑不得外，Clojure自身的语法也很难让人爱。基本就是Lisp那套，写啥都已左右括号为主，这样的感觉其实是不太棒的。特别好这口的人除外。这个不是通过教育就能改变的。

所以看了一圈clojure的内容后，觉得这个语言目前还是浅尝辄止为好。

最后，需要提一下的是，这个语言的性能也比较普通。比普通脚本语言快，但比JS V8慢。相较于Scala Haskell，Clojure还是弱了一些。   
![image](/images/screen_print/programming_performance.jpg)
