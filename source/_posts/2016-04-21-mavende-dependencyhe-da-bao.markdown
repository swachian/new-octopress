---
layout: post
title: "Maven的Dependency和打包"
date: 2016-04-21 11:32
comments: true
categories: 
- java
---

使用Maven一大便捷之处就是管理依赖变得方便了，另一个好处就是打包更加灵活。

以前全部用jar包加入到工程里面，如果实际部署的时候需要剔除个别包，就需要自己手工在war包里删除。
而实际上需要这么干的情况还是有一些的，比如一些公共的包像ojdbc.jar，都已经放到容器里面了，如果war包里再有，则容易引发冲突。
删除公共的包，另一个好处就是可以给war包瘦身，这样在传递、部署时都会更加便捷。

6种范围依赖：

* compile: 默认的选项，会在export的时候加入全部依赖
* provided: 由其他环境提供，如容器或jdk，但在编译和测试的时候还是会导入，对于容器公共的包，可以使用这个选项
* runtime
* test
* system: 和provided很类似，但需要自己指名jar所处的位置，类似于以前直接把jar包加到工程里面的做法
* import

个人用的比较多的还是compile和provided两种。


