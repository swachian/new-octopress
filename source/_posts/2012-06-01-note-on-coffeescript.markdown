---
layout: post
title: "Note on CoffeeScript"
date: 2012-06-01 11:06
comments: true
categories: 
- 技术
- 笔记
- nodejs
- 神器
---

这是阅读'The little Book on CoffeeScript'的笔记。全书只有60页。和CoffeeScript还是相符合的。毕竟它也是一个清简的工具。
不需要太大的部头。

# 安装步骤

coffee可以直接运行在浏览器中，只要浏览器引入了一个js文件。

```html
<script src="http://jashkenas.github.com/coffee-script/extras/coffee-script.js"
type="text/javascript" charset="utf-8"></script>
<script type="text/coffeescript">
# Some CoffeeScript
</script>
```

但这种是需要运行的时候解析的，所以还是应该运用服务端编译的方法，compile成js。下面是执行步骤，注意这里是基于node.js的，
但实际上只要有引擎即可。只不过是因为node安装方便，而且已经自带了引擎。

```
wget http://nodejs.org/dist/v0.6.18/node-v0.6.18.tar.gz
tar -zxvf node-v0.6.18.tar.gz 
cd node-v0.6.18.tar.gz 
./configure
make && make install 
npm install -g coffee-script # -g 才能确保不是安装在当前目录
```

**编译** `coffee --compile my-script.coffee` , 按目录编译 `coffee --output lib --compile src` 
**运行** `coffee my-script.coffee`
**命令行** `coffee` , 值得注意的是，这时候的if等语句换行需要跟随 `\`

# 1. Syntax

CoffeeScript并不是Js的超集合，所以有些句法是**不能**使用的。  
和ruby一样，没有分号；if可以尾随的与语法糖；  单行的if需要用than  

和python一样，空白是重要的，所以程序必须保持sane manner；if的缩进  

支持多行注释  
```js
  ###
    A multiline comment,
  ###
```

### 变量和范围

CS让所有的变量全部变成局部变量，避免了js这方面的混乱。  
需要声明全局变量时，可以直接在浏览器的js代码里面生成，也可以使用`this`关键字，它代表
**global object**  
```js
exports = this
exports.MyVariable = "foo-bar"
```  

### Functions  

cs去掉了js冗长的函数定义语句，改用arrow `->`  ，这个替换js的function关键字
单行函数 `func = -> "bar"`  
多行函数，必须注意**缩进**（indent）  
```js
func = ->
  # An extra line
  "bar"
```

在 `->`前配置**arguments** `times = (a = 1, b = 2) -> a * b`  
接受多个参数 `sum = (nums...) -> `

**调用**时，可以跟`()`或者不跟。当跟上一个或多个参数的时候表现的像ruby，是当函数来调用；但是当
没有参数时，会死死的被当做变量，此时表现的更像python。与ruby不同，ruby永远把应用当函数来调用。

Function **Context** 待进一步了解  
`=>`

### 一些表达式

花括号是可选的，hash和array可以利用缩进完成。
```js
object2 = one: 1, two: 2

object3 = 
  one: 1
  two: 2

array1 = [1, 2, 3]

array2 = [
  1
  2
  3
]
```

Flow Control  
像python，像ruby

String的解析，和ruby类似

### 循环和综合（类似python)
`in` ---- `for name in ["A", "B", "C"]`  
需要index ---- `for name, i in ["A", "B", "C"]`， 只需要加一个参数  
把操作也写成一行 ---- `release prisoner for prisoner in []`  
comprehensions: ---- `release p for p in prisoners when prisoners[0] == "R"`
内置的仅支持while  

### 几个替换和操作符

`@` serve as `this`, `@saviour = true`  
`::` serve as `prototype`, `User::first = -> @records[0]`  

`?` similiar to Ruby's nil?, `praise if brian?` , it's also a `||`， `velocity = southern ? 40 `  

# 2. CoffeeScript Classes

CS使用`class`做关键字来定义类 `class Animal`  ，
使用new 来新建对象 `animal = new Animal`,  
`contructor` 类似ruby的initialize， 
```js
class Animal 
  constructor: (name) -> 
    @name = name
```  
其中，构造函数的参数如果带@则会自动被当成实例变量进行设置  
```js
class Animal
  constuctor: (@name) ->

animal = new Animal("Parrot")
```
### instance 属性

给实例加属性如同给object加属性 

```js
class Animal 
  price: 5
  
  sell: (customer) => 

animal = new Animal
animal.sell(new Customer)
```

为了确保将`this`锁定在它被定义的context中，需要用fat arrow `=>`，这样this就不会随着event callbacks
环境的变化而变化。

### Static 属性 

这就是class变量，需要用到this 或者 @  
```js
class Animal
  this.find = (name) ->

Animal.find("Parrot")

Class Animal
  @find: (name) ->

Animal.find("Parrot")
```

### 继承与Super

和ruby python的继承类似，使用`extends`关键字，内部实现是用prototype完成的。

```js
class Animal
  constructor: (@name) ->
  
  alive: ->
    false

class Parrot extends Animal
  constructor: ->
    super("Parrot")

  dead: ->
    not @alive()

Animal::rip = true

parrot = new Parrot("Macaw")
console.log("aaa") if parrot.rip
```

# 3. 惯用法

```js
### each
fun(n) for n, i in array 

### map
for item in array
  item.name

### select
passed = []
failed = []
for score in [49, 48, 90]
  (if score > 60 then passed else failed).push score

### includes
included = "test" in array #但不能用于单个字符串的内部模式匹配

### 属性遍历
object = {one: 1, two: 2}
for key, value of object
  "#{key} = #{value}"

### or
hash ?= {}

### 支持多值返回

### 外部扩展库
# Use local alias
$ = jQuery

$ ->
  #COMContentLoaded
  $(".js-el").click ->
    alert("clicked!")
```

# 4. 编译
提到了[Cake](http://jashkenas.github.com/coffee-script/#cake)这个工具。
跟rake差不多，可以watch，可以自动编译。

# 5.优良部分

孙子说，知己知彼百战不殆。

CS也只是修复了部分js的缺陷。

`->` 是从input *points to* output。这个创意真棒。 `(input) -> output`
