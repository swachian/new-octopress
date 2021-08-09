---
layout: post
title: "The hardware architecture of 37 signals"
date: 2012-07-11 11:10
comments: true
categories: 
---

37signals发文讲了他们的[硬件架构](http://37signals.com/svn/posts/3202-behind-the-scenes-the-hardware-that-powers-basecamp-campfire-and-highrise)

老外的硬件设施还是很先进的。比如Dell C5220可以有12个sleds，每个sled可以插一个cpu和4根内存条。这样一个3U高度的机箱
就能装进12个u 48根内存条。目前37signals的rails进程跑了8个sleds。
网络设施中1G的是主流，个别的有10G的。存储是大量采用了ssds，磁阵用的倒是EMC的方案，实现了400TB。
备份直接用的S3 storage。


![37硬件架构](/images/screen_print/37硬件架构.jpg)
