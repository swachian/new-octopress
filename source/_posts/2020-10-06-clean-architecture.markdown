---
layout: post
title: "Clean Architecture"
date: 2020-10-06 22:47
comments: true
categories: 
- 技术
- java
---

Rober C. Martin的另一部Clean系列，总体来讲不如Clean Code，但书还值得一读。Bob大叔开发经验丰富，但仔细分析的话，他的主要经验还是基于C的通信软件的开发，之前有过很多的汇编经历。Java看起来真正做过的大的项目似乎并不多。因为按他90年代以前的经历，基本没有使用Java开发过什么，而之后，则转去了做咨询和主编，写的项目按常理应该不多。

书中首先使用龟兔赛跑的隐喻，讽刺了程序员们的迷之自信，总以为自己是聪明的兔子能够有朝一日把一团乱的东西Clean干净，但实际上从来没有发生。以此告诫读者必须脚踏实地做好整洁架构和整洁代码：The only way to go fast is to go well. 随后，提出Software的精髓在于**soft**，也就是easy to change，这是软件设计和开发的根本。并且应用类软件的开发，一般是由urgent behavior驱动的，但维护好clean Architecture则是开发人员的责任。

第二部分里，讲了3种基本的编程范式，强调的都是纪律的重要性。如结构化编程取消了goto，只保留了if/then/else, 
do/while/until; OO则是限制函数间的调用，抽象、封装、继承、多态，并且举了IO device的C接口的例子。同时提出了**Plugin**架构的思想。因为所有的Device其实都是作为一种附件，plugin到OS上面去的。接口是OS定义的，实现则是plugin的事情。

第三第四部分则是作者提出过的SOLID设计原理以及组件的原理。  
SRP，OCP，LSP，ISP，DIP。一个Module应该只对一个Actor负责。Actor通常是source，是使用者。  
组件主要是耦合问题。REP、CCP、CRP，这其实是一个CAP的不可能三角。组件之间要削减循环依赖，被依赖多的Stable，不被依赖的Unstable，Stable的东西需要加入Abstract来实现弹性的增加。同时要减少对易变（volatile）组件的依赖，即在Stable的东西中加入Abstract以使软件变软。

第五部分是全书的的主体，主讲架构。  
架构的目的是为了便于软件开发、部署、运行（非功能性要求）。维护，让细节开放，这样细节可以很晚才被决定。架构师的目标则是make software soft， 实现Policy和Detail之间的decouple，同时也负责设计Policy。

所谓Policy指business rules and procedures，Detail则是和policy进行通信的东西。架构师的一大职责，就是在Details之间画下边界线（boundary line）。而Clean Architecture则是让Details依赖Policy的一种架构方式。也体现了Bob大叔的DIP原则，即反转依赖。低级的组件应该作为插件插入到高级组件中去，高级组件是Policy和Use cases。
这个好处是减少核心内容的复杂性和对外部的依赖。
同时，架构是关于系统的，不是关于框架的，提出了架构设计要和框架尽可能分离的概念。即Domain优先，能让人看了架构设计图就知道系统是干什么的，举了图书馆、住房的设计图例子。这样也容易形成Testable Architecture。但这种做法下，架构师就变成了传统的系统分析师。  

举了几种Clean Architecture，主要就是Ports and Adapters（Hexagonal Architecture）。也提到了Humble模式。架构即画边界以及决定用什么作边界，Humble Objects用于架构边界处。

至于微服务，作者的意思是service并不是分界线，分界线在service内部，举了Kitty Finder和Ride Finder的例子。从这点来说，熔断可以作为某种服务的一种多态实现。所以K8S其实也可以实现熔断，比如在一个Login的service中部署两个不同的service，确定某一个在什么情况下生效。

Test可以作为系统第一部分，而且是最外层的，因为所有的代码都不依赖测试代码，而测试代码却依赖其他代码（Domain+Infrastructure）。但对测试解耦，并没有提出什么实质性的建议。

最后，DB、Web、Framework都是小把戏（Detail），应用本身才是大Boss，不要为了Detail而限制Boss。又举了一个作者自己卖网课的例子，但这个例子实在太短，看不出什么名堂来。

结束后，其实还有两大部分，一个是Simon Brown写的一章，列举了4种常见的代码目录组织方式，并提出组织之间最大的区别在于包内方法的可见性差异。Simon创造了C4架构模型，这章列举的也不错，但例子还是太浅和理想化了，设计细节太少。  另外一部分就是Bob大叔的前半生开发生涯自传，写到了1990年代。里面补充到之后的经历会写成另一本书，应该就是今年出的Clean Agile了吧。

