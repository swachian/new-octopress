---
layout: post
title: "从并发到Kotlin和模式的学习"
date: 2025-04-30 23:42
comments: true
categories: 
- 技术
- java
- kotlin
---

在深入学习JVM并发艺术的过程中，了解到Kotlin的协程拥有比JAVA 21的协程更加的性能，从而对了解Kotlin实际情况产生了兴趣。同时，又找到了一本基于Kotlin的，讲解Gof模式实践和并发模式实践的书籍，于是跟着整本书，把Kotlin也学习了一遍。本文会就Kotlin的特点，相对于Java本身的优势和劣势做一些评价，也会对Kotlin高度配套的Arrow、Ktor、Vert.x写一些体会，同时，因为Kotlin明显受到了Scala的启发，所以也会谈一点关于scala的内容。

前4章讲了Kotlin的基础以及Gof的3类合计23个经典设计模式。Kotlin的语言风格和Java以及JS类似，实质上更像JS，因为她把函数作为一等公民，但很多语法又更像Java。

回忆要点：

### 语法巡礼

* 打印语句是什么  
* 简化的main方法  
* 简化的分号semicolons  
* val var的类型声明以及类型推断  
* ==和===的比较  
* Null safety  

* Lists, Sets, Maps的构造方式类似java，但有更明确的Mutable标识  
* 数组，从list到数组以及arrayOf  
* if 和when控制语句  
* String里变量的解析 ${}  
* loop的写法  

* class和继承，用`:` 来表明继承  
* Properties及其method  
* 必要时可给Property定制set get  
* interface和override  
* abstract class  
* 只有open的class可以被继承，但通过编译糖实现了直接给现有类open一个method(Extension functions)  
* Data 类，也就是value object  

### 创建有关的模式

* 单例 object关键字  
* Factory Method 是要抽象出被建对象的公共Interface  
* Abstract Factory 可以理解成是Factory Method的集成    
* Builder 目前很常用的方法，Kotlin里面增加了通过apply实现的Fluent setters，Default arguments等  
* Prototype Kt里面这就是一个copy  

### 结构有关的模式

* Bridge 引入中间对象类实现行为的委托，让原对象行为的变化通过变换bridge的对象来实现  
* Proxy 和Decorator一样，都包含一个传入的组合对象，只是更多的是做访问控制等工作，并且很可能执行路径和传入的参数很不一样  
* Decorator  `by repository`的意思是继承这个接口的时候使用输入的参数的实现类  
* Composite 把可能单个或者多个的同类参数组织起来，核心结构是包含一个集合，`varargs`关键字可以把输入的多个参数作为数组    
* Facade 把复杂的操作封装起来，这里举的例子有点像后面的中间人  
* Adapter asStream，asArray都是一种adapter的现实应用  
* Flayweight 通过缓存+单例实现内存使用减小  

### 行为相关的模式

责命解迭中记观，策状模访

Java的惯例是都是对象，所以所有的行为模式和结构模式都长的差不多。但是，对应Function优先的语言而言，Function不像对象那样是有状态的，所以可以实现纯策略模式。

* Chain of Responsibility 常见的filter其实就是一种责任链模式，通过提取一个公共的handler(比如request in response 出)函数为入参，就可以把这串方法串行调用起来  
* Command 把要执行的东西压入一个数组，然后提取出来分别执行，其实事件模型有点类似command，但command甚至可以执行回滚    
* Interpreter 解析复杂的文本为对象  
* Iterator  支持迭代模式的对象，就拥有了很多种和迭代器相关的能力，从遍历到map，reduce  
* Mediator 按他的说法，controller在MVC里就是一个中间人  
* Memento  顺便记录点东西  
* Observer launch等的核心模式  
* Strategy 这个其实是被使用的最多的一种模式，动态更换行为  
* State 通过状态不同来更新成员的状态对象，从而有不同的策略  
* Template Method 直接传入定制化的method，从而利用整个模板走完流程  
* Visitor 这个模式的核心其实是把不同元素的处理情况放到一个类中，用when或者switch进行集中处理，而这个类就叫visitor。她可以处理集合，处理集合时意味着丢给集合的accept后续处理，如遇到叶子结点，则直接对元素进行访问后获取自己需要的东西。  

随后本书进入了第二部分，关注于有反应(Reactive)和并发的Pattern。主要就是涉及FP（函数式编程）的模式，以及协程(Coroutines)、Channel、Flow等用于并发的组件。后者更像是基础框架对编程的影响，也由基础组件决定了程序编写的基本套路，即模式。  
以协程为例，Java是17以后才引入的概念，之前只有线程。而Kotlin因为要为安卓服务，所以很早


### FP 

多核的兴起以及FP在意图性编程方面的优势，让FP翻红起来。

* function的几种写法，从最严格的到最简化的

```
fun generateMultiply1(): (Int, Int) -> Int {
    return fun(x: Int, y: Int): Int {
       return x * y 
    }
}

fun generateMultiply2(): (Int, Int) -> Int {
    return { x: Int, y: Int ->
        x* y 
    }
}

fun generateMultiply3() = {x : Int, y : Int ->
    x + y
    y + 3
}

fun subtract(x: Int) = fun(y: Int): Int {
    return x - y
}
```

* Trailing lambda  又称 call suffix，类似ruby的模板方法在尾部输入函数  
* Higher-order functions，forEach里面有自动入参`it`，是item的缩写  
* Clousures 由此支持了currying和Memoization记忆数组，本质就是让函数也可以有**状态**  
* fun或者lambda里更多地使用expressions而不是statements  
* tailrec用于性能优化递归函数，限制是只能是最后一句包含递归，本质上这是compiler技术提升的一种表现  


### 线程和协程

* 昂贵的Thread，因为消耗更多的内存，有Thread Stack，还有CPU间的Context Switch  
* coroutines，kotlinx-coroutines-core提供了这种轻量级线程的实现，通过with+launch或者with+async的方式来实现  
```
    with(GlobalScope) {
        launch {
            delay(100)
        } 
    }
    // with 在kotlin里让{}里的this自动指向入参，上面例子中就是GlobalScope，这个思路有点类似于decorator模式中举例的by repository。launch只是一个普通的method，但需要一个scope才能跑起来launch代表的coroutine
```

* runBlocking和suspend  
```
fun main() {
    runBlocking {
        val job: Deferred<UUID> = fastUuidAsync()
        println(job.await())
    }
}

suspend fun main() {
    val job: Deferred<UUID> = fastUuidAsync()
    println(job.await())
}
```

* Dispatchers.Default和Dispatchers.IO等，协程实质依赖线程运行，dispatcher就是这些线程，可以作为入参提供给launch和async  
* Structured concurrency，coroutines套coroutines，父协程要等待子协程们完成才结束。子协程的异常会导致父协程终止，supervisorScope可以防止这个异常繁殖传递，coroutineScope方法也能做此限制  


### 控制数据流

FP+coroutines的设计原则： 

* Responsive, Resilient(supple), Elastic, Message-driven  
* collections上的高阶函数，reduce的话有一个fold和reduce类似，但可以提供initial value，flatMap和flatten，后者更简洁一点，类似toList()不用输入lambda  
* sequences 同list最大的区别在于不像list被整个处理，而是会被一个一个送出去并行处理，一般而言效率优于List  
* Channels kotlin版本的BlockingQueue，用于底层通信，属于热队列，既已经发出的消息不会重放, produce可以制造一个channel，搭配这个channel上的consumeEach  
* Actor，封装了channel和coroutine，但在kotlin中处于临期的状态  
* Flows，冷队列，会把消息从头到尾再发给新的监听者，用于数据流但实际上也能通过配置改变这种默认的行为，搭配为emit和collect，flow有点像tcp，有更高级的主题，例如shareIn，Conflate以及限流相关的debounce，sample，distinctUntilChanged等功能函数，spring的projectreactor也提供了类似的库，但没有协程助力，要采用事件驱动的写法    


### 并发相关的设计模式

* Deferred Value, java的Future，kotlin的Deferred，一般从async中返回  
* Barrier, kotlin中是用几个await等待几个异步的事情都完成后再进行处理，java中的CountDown，CylicleBarrier也都是干这种事情的  
* Scheduler，任务的调度（如何执行）和执行什么分离，再kotlin是Dispatcher，在java是executors  
* Pipeline, 把一个复杂的任务拆成流水，这样可以多个线程或协程同时运行小任务，也是stream设计的要点  
* Fan-Out, 把一个大任务分散后发出去，同Pipeline的区别在于可能只是批处理分发，而pipeline有更强的单个操作的协作性  
* Fan-In，Out后的东西最终往往需要汇总后才有意义  
* Racing，和Barrier类似，但只要有一个有效就可以忽略其他等待，kotlin在这里使用了select，即多路复用  
* Mutex，类似java最经典的synchronize，通过lock unlock来同步竞态资源  
* Sidekick，小外挂，把一部分工作包出去，目前AI计算和NVIDIA的关系就是N卡其实就是Sidekick  



至此，本书最精华的部分就讲解完毕了。后面又讲了3个常见的库和框架的使用，但更流于框架的使用说明，有些例子也举的不太好。
总体而言，本书的视角比较独特，用kotlin介绍的设计模式有令人耳目一新的地方。当然作者部分地方也显得功力不够，讲的不够清楚到位，有些例子也举的不是很好。