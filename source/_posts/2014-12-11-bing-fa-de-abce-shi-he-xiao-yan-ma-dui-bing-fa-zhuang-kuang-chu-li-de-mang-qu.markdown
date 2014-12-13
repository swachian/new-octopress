---
layout: post
title: "并发的ab测试和校验码对并发状况处理的盲区"
date: 2014-12-11 21:55
comments: true
categories:
- 技术
- java
---


某个报障称我们的短信轰炸拦截无效，听到后感觉比较奇怪，因为此限制已经加上并且经过测试验证。
但提供的素材上，单个用户确实同时收到了多条短信。于是又检查了一遍代码，发现问题可能出在并发上。

限制的过程是这样的：

1. 取出session中的校验码并与请求中的参数进行比较，通过的进入第2步，如失败则直接进入第3步；
2. 发送短信；
3. 刷新校验码。

而如果扫描软件获取验证码后，同时交给多个线程并发发起请求，因为第一步执行的速度较快，而下发短信的请求处理较慢，
极其可能在执行第3步之前，另外几个请求也都通过了第一步的检查，从而可以进行第二步。

然后就是要验证这种猜测是否成立。由于扫描软件并不是我的，所以需要自己模拟这个请求，而又由于一些陷阱，导致整个验证也
颇费了一番周折。

### 第一个坑： ! 和 &都是shell的特殊字符

最简单的模拟无非就是ab测试（ApacheBench），

`ab -c 5 -n 10  http://xxx.com/portal/get\!validate.action?user_id=1xxxx\&verfiyCode=5614`

但是，一开始并没有在!和&前面加上转移符号，所以运行失败

### 第二个坑： 需要提前放入session

一开始并没有搞清楚shell执行ab失败只是因为缺乏转义符号，于是尝试使用编写客户端代码解决。首先使用了Java的Jersey，
因为手头一个项目最近使用这个也比较顺手。运行之后发现每次都是返回404的错误。而在浏览器中，即使验证码不对，也会显示
正确的jsp。换了一台机器后，发现自己犯了个低级错误，因为验证码是存放在session里面的，而Jersey的普通请求不会
带cookie上去，因此就得到了错误的响应。

于是想着给Jersey的请求加上cookie消息头。一番考察后，被告知Jersey原生态并不支持直接加cookie，于是决定还是换用
ruby的rest-client。

```ruby
require 'rest-client'


jsp = "http://xxx.com/portal/";
passportUrl = 'http://xxx.com\!validate.action?user_id=1xxxxxx\&verfiyCode=9813';

def s
  response = RestClient.get(jsp)
  @cookies = response.cookies

  @cookies['JSESSIONID'] = '74113695C0FB915393AE69DD63EAE088'
  p @cookies
  #puts response.body

  5.times do |n|
     response = RestClient.get(passportUrl, cookies: @cookies)
  end
  puts response.body
end

s()
```

手工填入浏览器中的校验码，运行正常。但ruby的单线程运行方式下，
模拟不出并发的效果，所以还是需要回到ab测试上。

最后的结果倒是很简单，给路径加上转义并添加cookie头即可：

`ab -c 5 -n 10 -H "Cookie: JSESSIONID=74113695C0FB915393AE69DD63EAE088;" http://xxx.com/portal/get\!validate.action?user_id=1xxxx\&verfiyCode=5614`

这条命令基本上可收到5条短信，因为并发是5个。

### 解决的办法

最偷懒且管用的办法是使用`synchronized`关键字。需要注意的是两点：

第一， synchronized锁住的只是对象对应的代码段，所以适用于单例对象或者是static method。也可以通过
下面的方式，让锁住类对象来实现static的效果。

```java
       synchronized (Controller.class) {  

        }
```

第二， 因为是只有一个线程可以执行代码，这个锁的影响还是很大的，所以要确保锁住的代码快足够小，操作足够快，
才不至于影响业务的性能。在此采用这么粗的锁，也是因为从session中验证校验码并删除是足够短的处理逻辑。

```java
synchronized private static void validCode(HttpSession sesson, String code) {
  result = false;
  if (StringUtils.equal(session.getAttribute("rand1"), code)) {
    result = true;
  }
  session.removeAttribute("rand1");
  return result;
}
```

### 得到的教训

部分业务逻辑在设计和实现时必须考虑并发的情况，尽管这个确实有点难度。
