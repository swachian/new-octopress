---
layout: post
title: "为你自己学Git书评"
date: 2018-03-04 14:55
comments: true
categories:
- 技术
- 笔记
---

从Rails把代码库迁至GitHub起，接触Git已经很长时间了。但限于svn的惯性思维，其实我始终没有真的理解Git。
毕竟，上班一直是用的svn，去年12月后才开始迁移到git，而之前一个人用用GitHub的话，也确实是当一个svn在使用，主要就是实现通过中心节点实现多个终端的内容和代码共享。 

没有真正弄懂git的另一个原因，则是没有好的简明的说明教材，毕竟只是一个scm工具，自己舍不得在这上面花太多时间也是事实。而高见龙的这本《为你自己学Git》，目前只有繁体版，则写的够简洁也够深入，并且配合了很多例子，让人对git的原理、应用场景、使用方法都可以做到很清楚。

从Git设计之初来讲，它是去中心化的。所以本书的大部分运行环境和讲解例子都是基于本地目录。
![git存储结构](https://gitbook.tw/images/using-git/working-staging-and-repository/all-states.png)

`git add index.html`只是把文件从工作目录加入到了暂存区（staging area），`git commit`才能把内容放到存储库(repository)中。

不想让git管控可以给`git rm`加上`--cached`参数。 `git rm welcome.html --cached`,在git目录里的状态就从`tracked`变成`Untracked`。

`git commit --amend` 可以修改最近的一次commit的内容和备注。如果要修改其他更久远的，则可以`git rebase`, `git reset`，极端情况删除`.git`目录重来。
