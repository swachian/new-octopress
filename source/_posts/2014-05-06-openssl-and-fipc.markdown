---
layout: post
title: "Openssl and fIPC"
date: 2014-05-06 14:27
comments: true
categories: 
- 技术
---

Openssl还是一个关联很多的基础组件。自从爆出心血漏洞后，给自己的虚机也重新编译了一个新的openssl，
但是在编译ruby 2.1.1时却发现了新的问题。

第一个问题，是编译时老是认不出已经安装的openssl。可能因为openssl是从源码手工安装，而没有使用
apt-get intall，原因在于apt-get是失败的。

为解决这个问题，就在`/usr/loca/openssl-1.0.1g` 下独立编译生成了一个openssl。然后ruby再编译时可以识别openssl组件了。
但是，编译到一半，会报错

```
linking shared-object digest/md5.solibcrypto.a(md5_dgst.o): relocation R_X86_64_PC32 against undefined symbol
```

错误具体是连接报错。建议是要编译时加上 `-fIPC` 的选项。初看起来有点摸不着头脑，到底是给ruby编译时加上还是给openssl加上呢？

这里就是遇到的第二个问题，连接共享库失败。

于是检查这个选项是什么意思。查下来后，我大致的理解是：

1. `fIPC`使得编译出来的库文件(.a, .so等)地址都是相对地址；
2. 相对地址的好处是适合共享使用，但在装载时不同的进程可能会装载多次这个共享库；
3. 如果没有此选项，则是按绝地地址来编译，好处是内存中只有一份。

了解了fIPC是什么东西，上述报错就好理解了，是需要在openssl编译时加上此选项。

`./config --prefix=/usr/local/openssl-1.0.1g -shared -fPIC` 然后`make && make install `

再在ruby安装包里执行

`./configure --prefix=/home/user/.rbenv/versions/ruby-2.1.1 --disable-install-doc --with-openssl-dir=/usr/local/openssl-1.0.1g` , 然后 `make && make install && rbenv rehash` 

这样就装好了。

其实，我还有一点疑问，就是如何让openssl静态且又能找到。
估计又是一个属于和ubuntu紧密相关的问题。
