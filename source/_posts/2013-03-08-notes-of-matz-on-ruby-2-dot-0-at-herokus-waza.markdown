---
layout: post
title: "notes of matz on Ruby 2.0 at herokus waza"
date: 2013-03-08 11:15
comments: true
categories: 
- ruby

---

[Mats Ruby 2.0](https://speakerdeck.com/yukihiro_matz/ruby-2-dot-0-en)
的笔记。

首先讲了Ruby的历史

* Dec 1995 0.95
* Dec 1996 1.0
* Aug 1997 1.1
* Dec 1998 1.2
* Aug 1999 1.4
* Sep 2000 1.6

以上是节假日驱动开发，后来改成了周年纪念开发，呵呵。

voccation-driven development  
Anniversary-driven development


* Aug 2003 1.8
* Dec 2007 1.9.0
* Aug 2010 1.9.2
* Oct 2011 1.9.3
* Feb 2013 2.0.0


2.0版最早是在Ruby Conf 2001提出，包括

* new GC
* native Thread with GIL
* 有些特性后来放弃了

2.0的发布带来了：

- New Hash literals

```
  {foo: 1, bar: 2} => {:foo=>1, :bar=>2}
```

- keyword arguments

```
  def log(msg, level: "ERROR", time: Time.now)
    puts "..."
  end
  
  # existing hash passing
  log("Hello!", **hash)
```

- Module#prepend, alias method chain, from CommonLisp

```
#prepend put them before to wrap methods
class Foo
  def foo; p :foo; end
end

module Prepend
  def foo
    p :before
    super
    p :after
  end
end

class Foo
  prepend Prepend # just as include Prepend
end

Foo.new.foo

```

- refine，to constrain open class, scoped monkey patching

```
module R
  refine String do
    def foo
      puts "aaa"
    end
  end
end

"".foo # => error!

using R
"".foo
```

Java 和 Smalltalk有classbox的概念，也与此类似

- Enumerable#lazy， 受函数式编程影响

```
(1..Float::INFINITY).lazy.map {|i|
  i.to_s
}.select {|s|
  /3/ === s
}.first(500000)
```

- Symbol array literals

```
%i(foo bar baz) => [:foo, :bar, :baz]
```

- to_h, to_hash

- UTF-8 by default

* Performance Faster: 
  - VM(YARV)
  - GC
  - require

Ruby 2.1 maybe 25.12.2013