---
layout: post
title: "Braces 和  do end"
date: 2012-03-21 10:12
comments: true
categories: 
- 技术
- ruby
---

Braces and do/end are completely swappable—almost all the time. They have different precedence. It’s not often that anyone comes across what this means in practice.

``` ruby
outer inner {|where| puts "#{where} called me"}

# "inner called me"

outer inner do |where|
  puts "#{where} called me"
end

# "outer called me"
``` 

区别在于block属于谁，是前一个（outer）还是后一个（inner）。

类似的例子还有高见龙的：
http://blog.eddie.com.tw/2011/06/03/do-end-vs-braces/

``` ruby
my_array = [1, 2, 3, 4, 5]

p my_array.map { |item|
  item * 2  # 得到[2, 4, 6, 8, 10]
}

p my_array.map do |item|
  item * 2  # 得到[1, 2, 3, 4, 5]
end

```

用braces的，因为block属于my_array.map，所以得到的是double的数据。  
但是，下一个里面block却属于p了，于是只是输出了my_array的内容。  
总结起来，就是braces的顺序性更高，拥有更领先的结合能力。  
