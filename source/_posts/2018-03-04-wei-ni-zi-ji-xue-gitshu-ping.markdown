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

## git基本操作

从Git设计之初来讲，它是去中心化的。所以本书的大部分运行环境和讲解例子都是基于本地目录。
![git存储结构](https://gitbook.tw/images/using-git/working-staging-and-repository/all-states.png)

`git add index.html`只是把文件从工作目录加入到了暂存区（staging area），`git commit`才能把内容放到存储库(repository)中。

不想让git管控可以给`git rm`加上`--cached`参数。 `git rm welcome.html --cached`,在git目录里的状态就从`tracked`变成`Untracked`。

`git commit --amend` 可以修改最近的一次commit的内容和备注。如果要修改其他更久远的，则可以`git rebase`, `git reset`，极端情况删除`.git`目录重来。  
同时, `--amend`还能往前一次commit中加入新文件。

`.keep`往往用于新增目录时，为了目录进入仓库而作的占位文件。

`.gitignore`搭配`git clean -fX`可清除已经被忽略的档案。

`git log`增加`-p`参数可打印输出文件的变化内容。

`git blame index.html` 可以看见每行是谁写的。
```
86145428 (swachian 2018-02-20 21:05:05 +0800  1) ---
86145428 (swachian 2018-02-20 21:05:05 +0800  2) layout: post
86145428 (swachian 2018-02-20 21:05:05 +0800  3) title: "Peopleware读书笔记"
86145428 (swachian 2018-02-20 21:05:05 +0800  4) date: 2018-02-16 14:20
86145428 (swachian 2018-02-20 21:05:05 +0800  5) comments: true
86145428 (swachian 2018-02-20 21:05:05 +0800  6) categories:
86145428 (swachian 2018-02-20 21:05:05 +0800  7) - 管理
86145428 (swachian 2018-02-20 21:05:05 +0800  8) ---
86145428 (swachian 2018-02-20 21:05:05 +0800  9)
86145428 (swachian 2018-02-20 21:05:05 +0800 10) 读完软件随想录，自然而然被吸引
去了另一本这个领域的名著《人件》

```

`git checkout index.html`可以把误删除的文件恢复出来，如果有多个文件可以使用`git checkout .`一下子切出。  
上面是从staging区域切出到工作目录，如果使用`git checkout HEAD~2 welcome.html`则是把上两个版本的文件切出到working目录和staging目录。  

`checkout`主要是动staging和working 区域，`git reset` 则会涉及版本库区域:

```
git reset master^
git reset HEAD^
git reset 85e7e30
git reset e12d8ef^
git reset HEAD~5
```
`^`的作用是表示“前一次”。

`git reset` 可配合模式使用，`--mixed`,`--soft`, `--hard`,默认是`--mixed`，它们对staging和working区域的反应是不一样的。因为`reset`的本意只是重新设置`HEAD`指向，顺便解决了staging和working的内容。

* soft: 只改HEAD指向，其他都不改  
* mixed: 只动staging的内容  
* hard: 改HEAD指向，改staging，改working

`git reflog` 可以调出每次HEAD移动的记录日志，找回相应的commit标识。命令等于`git log -g`，加上`-g`参数也有类似效果。

`HEAD`指向的是某个分支，内容是具体文件`ref: refs/heads/master`，而这个文件里的内容则是某个commit形成的hash: `ef5dcf2ab28d2ec47252703815ab97bd4108f937`

`git add -p index.html` 可以选择编辑要加入暂存区的行。

## git本地分支操作

设置分支最大的目的是保证主干不受影响。

`git branch cat` 增加分支，`git branch -m cat dog`分支改名,
`git branch -d cat`删除分支，`git checkout cat`切换分支，
`git checkout -b cat`增加并切换分支，`git merge dog`合并分支

`Fast Forward`在一个分支相对于另一个分支只有新增的commit内容时可以使用，
这是没有**小耳朵**的。
否则，git会再造一个commit来合并两个分支，并把一个分支向前推到新增的这个commit。
commit信息里面，`Parents`字段中被合并的分支名位于后面。
![commit合并信息](https://gitbook.tw/images/branch/merge-branch/dog_to_cat.png)  
使用`--no-ff`可以强制产生小耳朵的效果：`git merge cat --no-ff`  
**分支只是一個指向某個 Commit 的指標。**

`git rebase dog`是重新嫁接分支，原理是将当前分支的全部提交一个一个提取出来，
重新计算后作为新的提交加到基准分支`dog`当前commit的后面，最后把当前分支的Head
指向重新apply的最新提交。所以rebase之后，之前分支commit的日期就延后了。

要回退`rebase`，可以使用`git reflog`找到`rebase`前的最新的commit号。  
简化版本是`git reset ORIG_HEAD --hard`，使用`ORIG_HEAD`指针。

有冲突的话，先编辑，然后`git add`加回暂存区，再`commit`。  
如果是`rebase`的，则`git rebase --continue`  

二进制的内容: `git checkout --ours cute_animal.jpg`, `git checkout --theirs cute_animal.jpg`

`git rebase -i bb0c9c2` 可以整理提交历史, `squash`： 合并commit

`revert`和`reset`的作用基本相同，但`revert`是再增加一个commit来实现取消前一次提交的效果，
一般用于多人合作时取消某些提交。

`git tag`，善用tag，**标签和分支最大的区别是标签打好之后这个指针不会再变化，分支则会继续前进**

`git stash`，配合`git stash list`, `git stash pop/apply`使用, 存放手头工作，也可以先`commit`再`reset` .





