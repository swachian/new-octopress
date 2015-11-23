---
layout: post
title: "文艺的HashMap初始化"
date: 2015-11-23 20:33
comments: true
categories:
- 技术
- java
---

多年以来，受制于java没有初始设置`hash`对-值的方法，例如js有：

```javascript
var obj = {
  a: 1, b: 2
};
```

ruby在借鉴js的文法之前，有著名的rocket标注

```ruby
obj = {:a=>1, :b=:2}
```

而java则只能继续使用过程定义来描述

```java
Map<String, integer> map = new HashMap<String, integer>();
map.put("a", 1);
map.put("b", 2);
```

而最近发现了一种文艺一些的写法：

```java
Map<String, integer> map = new HashMap<String, integer>(){
  {
    put("a", 1);
    put("b", 2);
  }
}

```

此种写法是利用了创建一个匿名类的文法，该匿名类直接继承自HashMap，而第二套花括弧则是实例初始化。

实例初始化是对应于静态初始化，后者属于整个类，而前者属于某个对象初始化时进行。

```java
public class demo {
  static {
    do sth of class
  }

  {
    do sth of instance
  }
}
```

其实这种写法的代码行数并不少，但是语意，主要是段落的分割清楚了许多。
