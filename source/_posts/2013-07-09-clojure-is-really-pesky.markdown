---
layout: post
title: "Clojure is really pesky"
date: 2013-07-09 22:07
comments: true
categories:
- 技术
---

试用了一下clojure，感觉这个东西不太灵。最早知道clojure，是在Heroku宣布[支持它](http://devcenter.heroku.com/articles/clojure)，知道彼时这个东西挺火。应该和闭包什么的有关联。

这次看七周七语言，终于得以一睹真容。知道了clojure其实就是Lisp的一个JVM实现。这个设计思路听上去不错，但仔细想想JVM的lib真有那么大的意义吗？答案是否定的。我不太相信用惯了其他语言的人会喜欢在新语言中继续调用java的内容。如果，在ruby中，我不会有兴趣去调用java。一旦用惯了clojure也不太可能再接受调用java的api。对比起来，scala倒是和java结合的挺紧密。

变成jvm的一部分，一大恶果就是启动变慢，从而作为脚本功能来跑很不美。毕竟一个jvm启动的时间很长，内存消耗也很大，对于处理任务极其简单的情况下，jvm启动的时间和内存开销显然过大了。
其次，融入jvm中，意味着需要ide的配合了。无论哪种ide，都是很重的，因此很是麻烦。
叠加起来，就是导致这种基于jvm模式的开发是不令人愉快的。

当然，天下英雄用java做clojure scala甚至jruby也不是没原因的。Jvm的性能确实很好，底层的库也很齐全，java的开发效率毕竟也比C高，所以基于java开发新的语言首先开发是脚容易一些，另外就是需要连接数据库等组件都是现成的。

但是，真的要给java注入活力，最直接了当的办法是让java中调用ruby clojure等方便。伟大语言才会诞生伟大的框架和lib，而现在这种只解决新语言中调用java lib，其实是不利于java王者归来的。只是这条路这家年已经无人深入了。

除了依赖JVM这个不好不坏的一点，Clojure自身的语法也很难让人爱。基本就是Lisp那套，写啥都已左右括号为主，这样的感觉其实是不太棒的。

所以看了一圈clojure的内容后，觉得这个语言现在还是别搀和了。
