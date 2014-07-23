---
layout: post
title: "被低估的JS： 「Pro JavaScript Techniques」读后感"
date: 2014-07-23 16:13
comments: true
categories:
- 笔记
- 技术 
- nodejs
---

作为一个Web开发者，无法绕开的一个点就是JavaScript。而对于经过C/Java训练出来的计算机专业人员而言，是很容易轻视JS，从而使得在这方面往往要经过很长的时间和经历，才能体会到
JS的与众不同及其能力。C或者Java同JS的不同已经不用多言，而同为脚本语言的Ruby Php Perl Python 同 JS的差别也是巨大的。有一定编程基础的人，学习其他大众性的语言，比如最常用的10种语言，
一般都是比较快的。但是，JS是如此的和其他语言不一样，以至于学习起来真的费一番功夫。

不过，直到读了John Resig的「Pro JavaScript Techniques」，终于令我豁然开朗。Resig是大名鼎鼎的JQuery的创始人，这本书中很多主要的API可以说就是介绍了JQuery是怎么实现的。包括Id的选择，
ajax方法等。最重要的，如他所说，就是第二章面向对象的JavaScript，或者说如何从其他编程语言来理解JavaScript。

笔记的流水账：

# 第一章 现代化的JS

JS和它的队友：

- Core Javascript 1.5
- XML2（DOM）
- XMLHttpRequest
- CSS（style）
- 事件

```javascript
# 注意通过prototype定义公共函数的模式

function Lecture(name, teacher) {
    this.name = name;
    this.teacher = teacher;
}

// 实例method
Lecture.prototype.display = function() {
    return this.teacher  + " is teaching " + this.name;
}

function Schedule(lectures) {
    this.lectures = lectures;
}


Schedule.prototype.display = function() {
    var str = "";
    for (var i = 0; i < this.lectures.length; i++) {
         str += this.lectures[i].display;
    }       
    return str;
}

var mySchedule = new Schedule([
    new Lecture("Gym", "Mr. Smith");
    new Lecture("Math", "Mrs. Jones");
    new Lecture("English", "TBD");
]);

alert(mySchedule.display());
```

# 第二章 面向对象的JS( javascript的精髓)

### 引用
引用指向的是具体的对象，引用是一个变量。
JS中的引用不会指向引用，`var b = a;`的作用永远是让b指向a表示的实际对象

### 参数类型检查和函数重载

`if (typeof msg == 'undefined') {}` 

以及js对象都有的属性：构造子

`if (str.constructor == String) {}`

后者能够找出具体的构造对象的函数，前者对通过函数构造的对象返回的也是'object'。

js在每个函数里面，有一个隐含属性 `arguments` ，这是一个伪数组，可以遍历、有.length属性，但不能被修改。可以通过复制遍历变成标准数组。

```javascript
function sendMessage(msg, obj) {
    if ( arguments.length == 2) 
          ojb.handleMsg(msg);
    else
         alert( msg );
}
```

### 作用域(Scope)

js通过函数来划分作用域，而不是通过代码块

没有var声明的，则变成全局变量

### 闭包

闭包允许内层函数引用外围函数内的变量，即便外层函数已经终止。

```javascript
function delayedAlert( msg, time ) {
    setTimeoute( function() {
         alert(msg); // msg就是外围函数中的变量
    }, time);
}
```

curry化： 利用函数生成函数

```javascript
function addGenerator(num) {
     return function( toAdd) {
        return num + toAdd;
     };
}

var addFive = addGenerator(5);
alert(addFive(4)==9);
```

### 上下文对象

通过`this`表示，永远指向当前代码所处的对象中。
是调用时确定的对象。

function都有call和apply两个方法，可以用于指定this是什么

```javascript
function changeColor( color ) {
    this.style.color = color;
}

changeColor.call(main, "black");

function setBodyColor() {
     changeColor.apply(main, arguments); //传入隐含的全部参数
}
setBodyColor( "black" );
```

## 原型式继承

```javascript
User.prototype = new Person();
```
其效果是每次 new User()时同时执行了new Person，且user对象就这样拥有了person的全部方法

## 类似继承

Douglas Crockford创造的`method`, `inherits`, `swiss` 三个方法。

```javascript
User.inherits(Person);
User.method( 'getName', function(){
  return "My name is: " + this.uber('getName');
});

```

## Base 库
## Prototype库
就是rails原先自带的库

## 命名空间

`$.`其实就是命名空间。
```javascript
var YAHOO = {};
YAHOO.util = {};
YAHOO.util.Event = {
    addEventListner: function() {}
};
YAHOO.util.Event.addEventListener(...);
```

## 清理代码
`!=` 和`==` 会对变量进行求值，即把对象变成false或true后进行比较，
js中， null false 0 undefined 求值后都是false

js一行一行地写可以不用分号，但是一旦被压缩后，换行符号都将取消，此时没有分号就不行了。鉴于js的使用场景，还行建议每行都加上分号。

压缩代码的三种方式: 
1. 只取出空白和注释
2. 压缩变量
3. both

IE 是不灵的，在调试方面

Firefox的调试是最好的，尤其搭配firebug和 View Rendered Source，Venkman也是一个ff的扩展

Safari还在迅速变化发展中，Chrome与之类似

## 测试套件

- JSUnit: 老牌的
- J3Unit: 稍新的，通Java集成的更好
- Test.Simple , Test.More

# 第三章 分离式的JavaScript

DOM(Document Object Model)是表达XML文档的标准，并不是唯一的方式，但确实是应用最广泛的方式。这一点和js能统一浏览器的原因一致，就是因为被广泛使用了。

DOM的模型：
DOM是一个树结构，根节点是html，
下属节点分为元素和文本两种类型。
每个节点包括5个指针:
1. 父节点parentNode
2. 兄节点(previousSibling)
3. 弟节点(nextSibling)
4. 第一个子节点(firstChild)
5. 最后一个子节点(lastChild）

整个的遍历和渲染其实都是基于DOM模型的。

## DOM的加载

* html解析完毕
* src中的脚本和css加载完毕
* 脚本在文档内解析并执行（此时dom并未构造起来）
* Html DOM完全构造起来
* 图片和外部内容加载


1. 等待整个页面的加载，基于window对象的load事件，速度最慢，因为是在图片下载之后

```javascript
addEvent(window, "load", function (){
  net( id("everywhere") ).style.background = 'blue';
});
```

2. 把script标签放置在页面的最后，这样确保执行的时候dom已建立

3. 监听DOM的加载状态，实现复杂。
jquery实现的方法，$或者说domReady，其主要原理是检查document是否已存在，document.getElementsByTagName和document.getElementById两个函数是否已存在，以及document.body是否已存在。搭配setInterval不停地检查，检查到位后就清楚timer

## 在HTML中寻找元素

cssQuery， jQuery
主要是css选择器和xpath选择器

## 获取元素的内容

1. 获取文本 text
2. 获取 html

## 操作元素的属性(attribute)

一旦元素加载到DOM中，元素会有一个管理数组，

```javascript
formElem.attributes = {
  name: "myForm",
  action: "/test.cgi",
  method: "POST"
};
```

实际提供了attr方法

## 修改DOM

1. 创建节点
createElement

2. 插入到DOM中  
insertBefore： 在子元素前插入 
`parentOfNode.insertBefore(nodeToInsert, beforeNode)
appendChild: 插入一个父节点中最后一个子节点，`parenElem.appendChild(nodeToInsert);`

## 异步与事件处理

### 异步事件与线程

### 事件阶段

捕获和冒泡，捕获是由外向内，冒泡是由内向外

是否能停止冒泡？


通过对按键事件的处理，停止textarea的正常响应
```html
<html>
<head>


</head>

<body>

<textarea rows="4" cols="50">
At w3schools.com you will learn how to 

make a website. We offer free tutorials 

in all web development technologies. 
</textarea>

<script>
document.getElementsByTagName

("textarea")[0].onkeypress = function(e) 

{ 
e = e || window.event;
return true;

};
</script>
</body>
```

上面的e是事件对象

`this`作为一种指代，可以泛化成各类元素，使得js的编写变得简单

```javascript
var li = document.getElemensByTagName("li");
for (var i = 0; i < li.length; i++) {
  li[i].onclick = handleClik;
}

function handleClick() {
   this.style.backgroundColor = "blue";
   this.style.color = "white";
}
```
### 取消冒泡（重载浏览器的事件处理）

```javascript
function stopBubble(e) {
  //如果传入了事件对象，那么就是非IE浏览器
  if ( e && e.stopPropagation ）
     e.stopPropagation();
  else // 否则使用IE的方式来取消事件冒泡
     window.event.cancelBubble = true;
}

```
### 取消浏览器的默认行为（重载）

```javascript
function stopDefault(e) {
  if (e && e.preventDefault)
    e.preventDefault();
  else //windows 特供
    window.event.returnValue = false;
  
  return false;
}

li.onclick = function(e) {
    iframe.src = this.href
    return stopDefault(e);
}
```

## 绑定事件的3中方法

1. 传统方法

```javascript
windo.onload = function() {};
```

好处在于简单稳定，处理事件时可以使用this关键字；
坏处是事件只在冒泡时运行，捕获时不运行。且一个元素一次只能绑定一个处理函数，即onload=func2会替换前面已经注册过的函数。同时ie中，还不能得到事件对象e。

2. W3C

```javascript
window.addEventListener('load', function(){}, false);

```
相对于第一种，好处是第三个参数指明了哪个阶段处理事件：false（冒泡）或true(捕获)；事件对象可以通过处理函数的第一个参数获取；不会覆盖之前已绑定的事件。缺点就是老的ie不支持。

3. IE绑定

```javascript
window.attachEvent('onload', function(){});
```

粗看起来和w3c的类似，但细节有很多不同：
* 仅支持冒泡阶段
* this关键字指向了window对象
* 事件对象存在于window.event中
* 事件必须以ontype的形式命名，如onload而非load

4. facade的addEvent和removeEvent

```javascript
addEvent( window, "load", function() {

});
```

唯一的缺点是仅能工作在冒泡阶段

## 事件类型

* 鼠标
* 键盘
* UI，focus，blur
* 表单事件
* 加载和错误

## 分离式的javascript

就是不在html里绑定怎么处理js，是的href可以是有意义的，使得js禁用时系统依然可以使用

## 访问CSS属性


## 位置 尺寸和可见性

### 位置

4种定位

position: static; //top和left不起作用，顺序排版
position: relative; //top和left相对于static进行偏移
position: absolute; //相对于它的第一个非静态定位的祖先元素而展示，如没有这样的祖先元素，就是相对于整个文档
position: fixed; //相对于浏览器窗口
top: 0px;
left: 0px;
right: ;
bottom: ;


### 元素的可见性

* visibility: hidden, visible
* diplay: none, block, inline, ''
* opacity: 
  - filter: 'alpah(opacity='50)
  - opacity: 50/100

## 动画效果

1秒执行20帧动画

```javascript
for ( var i = 0; i <= 100; i += 5 ） {
     (function(){
         var pos = i;
         setTimeout(function(){

            elem.style.height = (pos/100)*h + "px";
         }, (pos+1)*10);

     })();
}

```

## viewport是视口，就是浏览器滚动条内的一切东西

`window.scrollTo(0, 0)`可以移动浏览器窗口位置

## 拖放功能

使用拖放库可以

P145的悬停真是写的漂亮

# 第四章 Ajax

这部分其实主要就是举例ajax的例子，来做了综合的应用。

responseXML和responseText是xhttprequest的主要返回对象
其中，xml是响应头的content-type为xml时有效

一个$.ajax的实现，代码真精妙

返回响应的种类：

* xml
* json
* html ，可以直接注入html
* script

pageHeight(判断整个页面又多高)，scrollY(获知当前视口的顶部滚动到了哪里)，
windowHeight(获知视口有多高)

四步法：

1. DOM操作
2. 获取数据
3. 事件监测
4. 发起ajax请求


