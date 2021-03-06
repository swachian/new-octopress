---
layout: post
title: "思考出哪些不用测试更加重要"
date: 2012-04-12 21:06
comments: true
categories: 
- 技术
- 测试
- 项目管理
---


很多次，一直问自己测试代码到底值不值？毕竟我写过几次，但最后发现写测试代码的工作量其实很大。特别是碰到需求变更，本来只要改一处的代码，变得
必须改  **2x** 处。做了一段时间以后，我承认这是对保证质量有效的，但是往往确实不值得，因为得不偿失。另一个问题是先写
测试还是先写程序？ 

按TDD的要求，无疑测试代码在先，实际代码在后。但根据我写web程序的经验，尤其是那些controller的经验，坚持测试代码在先基本没什么意义。在web上和
数据库上直接看见结果显然更有感觉。
 
二者结合起来，最后我们就不怎么写测试代码了。尽管对违反TDD有一种罪恶感，但在教条和现实之间，我们还是选择了现实。其实想来比坚持教条要好。但实际上可以处理的更加聪明，也更有效果些。 

直到今天读了DHH的 [测试识别](http://37signals.com/svn/posts/3159-testing-like-the-tsa) ， 我对上面的问题有了更深一步的认识。

1. __严格按照TDD__还是__不写__是两个极端， 实际上中间有很多中间状态。比如，比较优良的测试覆盖率应该在20%，绝不应该超过33% . 道理很简单，就是一直讽刺thoughtworks的他们是在写测试程序而不是真正**有用的软件**。
2. 写测试本来就是不是**免费**的，需要阅读、需要维护、需要动脑筋、需要花时间，而这个时间比例也最好控制起来，20%是不错的一个开销比例。
3. 关键问题在于，也是最难的，是**识别什么东西是需要测试的**，真正值得动脑筋的是这些东西。
4. 识别出要写的测试后，先写测试还是后写其实和在写什么内容关系重大。针对api的可以tdd，而应用类的实际上还是可以先写代码再写测试，毕竟tdd在web中更多的是一种保障作用。

得到的教训：

人类最可贵的是 **独立思考** + **灵活运用**， 走极端不好。实际上很多事情都是一个度的问题， 把原则用在需要的地方。 在做其他事情方面也是一样的。
不用追求用了TDD就100%，未满似乎就不是TDD。或者写不到50%以上就索性一点都不写。即使做其他事情的时候，也要牢记这个道理。原则是有价值的，但必须要有灵活的运用。这才是运用技术手段时该抱有的开放的心态。

