---
layout: post
title: "Gimli and markdown 2 pdf"
date: 2012-04-17 15:24
comments: true
categories: 
- ruby
- 神器
---


想把博客部分文章转换成pdf，利于直接把文件分发。试了很多东西，包括 pandoc、little book 等等。
最终在这个法国人的[博客](http://kevin.deldycke.com/2012/01/how-to-generate-pdf-markdown/)中找到了很好的解决办法。
最后因为安装了gimli，最终直接解决了格式、中文编码等各种问题。

先安装 Pandoc

`sudo agt-get install pandoc nbibtex texlive-latex-base texlive-latex-recommended texlive-latex-extra preview-latex-style dvipng texlive-fonts-recommended`

安装ruby的gem gimli

```sh
sudo agt-get install wkhtmltopdf
gem install gimli
```

最后运行

```sh 
gimli -f ./README.md 
```

即可得到类似GitHub风格的pdf文档。