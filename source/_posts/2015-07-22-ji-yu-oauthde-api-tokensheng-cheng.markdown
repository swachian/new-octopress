---
layout: post
title: "基于OAuth的API Token生成"
date: 2015-07-22 16:00
comments: true
categories: 
- 技术
---

基本思路是对方要先注册一下，**注册的时候提供回调地址**，服务平台生成一个**id**给该用户。

然后，用户用这个id来访问平台公开的认证链接，平台生成**code**并通过注册时提供的**回调地址**发送给对方。

对方最后根据code到**token**获取地址拿到实际的token内容：

```
{
  "access_token":"01234567-89ab-cdef-0123-456789abcdef",
  "expires_in":28799,
  "refresh_token":"01234567-89ab-cdef-0123-456789abcdef",
  "token_type":"Bearer",
  "user_id":"01234567-89ab-cdef-0123-456789abcdef",
  "session_nonce":"2bf3ec81701ec291"
}
```
