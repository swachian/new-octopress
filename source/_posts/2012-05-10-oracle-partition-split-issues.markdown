---
layout: post
title: "Oracle Partition split Issues"
date: 2012-05-10 13:41
comments: true
categories: 
---


Split 一个分区有最多10次的限制。这跟实现的机制有关。当split发生时，是这么操作的：

1. 将现有的PART# + 1， 名字保留为被拆分的partition
2. PART# - 1， 作为另一个partition的名字
3. 再继续拆分的话，依照上面的分法持续划分。

所以10次以后，就会出现这种错误`ORA-00001: unique constraint (SYS.I_TABPART_BOPART$) violated`

自己值选的好一些，可以最多分成20个区。不过从实际情况来看，RAC似乎已经会自己relocate PART#。