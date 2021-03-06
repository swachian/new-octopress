---
layout: post
title: "WebSocket"
date: 2012-05-28 14:00
comments: true
categories: 
- java
---

[**WebSocket**](http://www.websocket.org/quantum.html) defines a full-duplex communication channel that operates through a single socket over the Web

现在浏览器对real-time应用的解决办法：

* _polling_ ajax 定期轮询
* _long_polling_ 有请求上来后，不直接回应。但这样做未必能带来比前一种稍好的性能表现。  
* _streaming_ server不关闭链接，发送并维持住一个打开的response。但会导致HTTP buffer 回应的问题，因为一直不给complete信号会导致不即刻传回去。

结论：这种实时体验的代价高昂。这些代价包括： **延误**, **没必要的网络流量**， **cpu性能的拖累**

WebSocket这是下一代的web通信---full-duplex, bidirectional, a single socket。看下来是对HTTP协议的一个替换。


```
GET /text HTTP/1.1\r\n Upgrade: WebSocket\r\n Connection: Upgrade\r\n Host: www.websocket.org\r\n …\r\n 
HTTP/1.1 101 WebSocket Protocol Handshake\r\n Upgrade: WebSocket\r\n Connection: Upgrade\r\n …\r\n
```

WebSocket目前只有chrome有实现。 Server端的编程工具也还不是很多。
Kaazing WebSocket Gateway 对这些实时东西可以做一个很好的转发。