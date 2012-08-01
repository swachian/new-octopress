---
layout: post
title: "我的开发环境"
date: 2011-06-20 15:48
comments: true
categories: 
- 技术
- rails
- ruby
---

牵涉到的软件：

vmware

  ubuntu1104

    ssh

    rvm

     ruby gem rails thin


windows

  securecrt

  radrails

    rse 远程控制插件
    Target Management 3.0 Update Site	http://download.eclipse.org/dsdp/tm/updates/3.0	Enabled

其实就是通过一个virtualbox的方式，将rails的环境安装在ubuntu上。而ide利用radrails+ssh通道的方式访问整个虚拟机的目录，同时搭配securecrt的console能力。可以说，这是在windows下最好的方案。考虑到中文等支持，可能也是比ubuntu下直接利用netbeans等开发更好的方案了。

具体做法，前提是vmware上装好ubuntu，同时装好并启用ssh
sudo apt-get install openssh-server

然后，下载最新版的radrails，安装后，选择安装软件，更新增加里面的rse插件，基本做法可以是输入remote
　　让系统去filter
　　。