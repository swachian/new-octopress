---
layout: post
title: "CORS问题"
date: 2021-03-18 13:40
comments: true
categories: 
- 技术
---

动手搞了一下Nginx和Chrome的CORS问题，顺手记录一下一些基本概念。

CORS的本意是限制Http请求中Origin的来源，主要是用于保护浏览器客户端的，可以一定程度上防止浏览器访问页面A时，莫名其妙连去B站资源的情况发生。

原理上，CORS工作时会先发出一个OPTIONS请求，并携带Origin消息头：

```
OPTIONS /
Host: service.example.com
Origin: http://www.example.com
Access-Control-Request-Method: PUT
```

然后，服务器端如果支持跨域，则会返回Access-Control-Allow-Origin消息头，里面给出允许访问的Origin域名。如果用`*`，则表示没有任何限制。如果要允许多个域名，则可以使用Nginx中动态变量的方法，这种情况下每次还是只返回一个域名。

```
location / {

                root html;
             if ($request_method = "OPTIONS") {
add_header Access-Control-Allow-Origin *;
                add_header 'Access-Control-Allow-Credentials' 'true';
                add_header 'Access-Control-Allow-Headers' 'Authorization,Content-Type,Accept,Origin,User-Agent,DNT,Cache-Control,X-Mx-ReqToken,X-Requested-With';
                add_header 'Access-Control-Allow-Methods' 'GET,POST,OPTIONS';
                add_header 'Access-Control-Max-Age' 10;
                return 204;
             }

                add_header 'Access-Control-Allow-Credentials' 'true' always;
                add_header 'Access-Control-Allow-Headers' 'Authorization,Content-Type,Accept,Origin,User-Agent,DNT,Cache-Control,X-Mx-ReqToken,X-Requested-With' always;
                add_header 'Access-Control-Allow-Methods' 'GET,POST,OPTIONS' always;
                add_header 'Access-Control-Max-Age' 10 always;
                proxy_set_header host $host;
                proxy_set_header X-real-ip $remote_addr;
                proxy_set_header X-forward-for $proxy_add_x_forwarded_for;
                proxy_pass http://127.0.0.1:8080;
        }
```

Nginx的配置需要注意两点：

1. add_header在proxy_pass时默认不会起作用，如果需要起作用，则要加上`always`参数。  
2. Access-Control-Allow-Origin 要严格的只有1条，不能有多条。