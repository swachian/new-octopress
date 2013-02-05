---
layout: post
title: "patch and diff"
date: 2013-02-05 10:52
comments: true
categories: 
- 神器
- 技术
- linux
---

patch和diff确实是个神奇的东西，用来对现有版本的升级是最好不过了。
好处在于一来不用停业务，二来可以明确到底改了多少东西。

### diff

首先来说说diff，毕竟patch是从此处产生。

```
diff -ruNa src dest  > a.patch

-r 针对整个目录  
-u 以合并的方式来显示文件内容的不同
-N 新文件做空白文件
-a 包含二进制内容，如jar包，class等
```

据说这个东西是perl的发明者创建的工具，主要用于比较源码，通常不带`-a`。

### patch

patch就比较强大了。如果是更改一个目录下面，最常见的做法是进入该目录，然后执行

```
patch -p1 < ../a.patch 
```

随后，两个目录就会变得一模一样了。
