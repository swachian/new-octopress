---
layout: post
title: "Oracle的价格"
date: 2013-03-28 14:57
comments: true
categories:
- 时评
---


不少人应该对Oracle的报价是好奇的，研究了一番之后，发现Oracle的报价无论在商务上还是使用策略上都可以称之为出奇的**成功**.

### Oracle的数据库种类

Oracle的数据库讲穿了只有一套，但又分成ee、se等几个版本。而这些都可以提供免费试用。
通过免费可以培养用户群，降低工程师的雇佣成本。通过划分版本，又可以执行价格策略，抢占不同的市场。

### Oracle的单价种类
Oracle的单价基本可以分为按User和按CPU卖。User的话是一个自然人或者设备。CPU就是按装机卖了。

下面是一些价格举例，单位都是美刀
按用户： {企业版： 950，se: 350, seo: 180}
按cpu: {企业版：47500， se：17500，seo：5800}



### Oracle的起步license概念

显然，按user大部分情况下应该比较便宜。所以，邪恶的oracle又有了最小license数量的概念。比如，企业版最低的user数就是25，se则是5，以此来保证oracle的收入。

### 折扣

以上只是目录价，一般通过代理买，获得一半的折扣是没有多少问题的。如果是大客户的话，还可以更加优惠。

最后，说一下关于DataGuard的事情。有说是免费的，也有说是付费的。在10g的ee版本中，这个确实已经包含了。

> Data Guard supports both physical standby and logical standby sites. Oracle Corporation makes Data Guard available only as a bundled feature included within its "Enterprise Edition" of the Oracle RDBMS.

所以，10g ee里面的ODG肯定是免费的，因为已经买过单了。

> The "Oracle Active Data Guard" option, an extra-cost facility,[4] extends Oracle Data Guard physical standby functionality in Oracle 11g configurations. It allows read-only access on the standby node at the same time as applying archived transactions from the primary node.[5]

然后，在11g里面，又推出了Active Data Guard，二者在技术上有什么区别还没研究过，但在付费上这是一个可选包。目录价200/user.



参考资料：

1. [oracle price list](http://www.oracle.com/us/corporate/pricing/technology-price-list-070617.pdf)

2. [oracle data guard wiki](http://en.wikipedia.org/wiki/Oracle_Data_Guard)


