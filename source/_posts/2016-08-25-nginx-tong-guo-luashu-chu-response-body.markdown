---
layout: post
title: "nginx 通过Lua输出response body"
date: 2016-08-25 23:03
comments: true
categories: 
- 技术
---

Nginx默认是不只支持`$request_body` 而不支持response的body输出的。这个设定是合理的，因为大量的html响应或者静态文件的内容输出将使得整个日志毫无意义。
然而，response body输出对api的请求来讲，则很多时候、尤其是在调试的时候是很有必要的。取代了抓包的作用，且简单直观许多。
搜寻之下，发现使用lua的话，可以达到此目的。

1. 下载并安装lua语言的安装包

```
 wget http://luajit.org/download/LuaJIT-2.0.3.tar.gz
tar -zxvf LuaJIT-2.0.3.tar.gz
cd LuaJIT-2.0.3.tar.gz
make && make install
```
注意，可能你的服务器的wget会实际下载一个html到本地导致tar解压失败，此时可以用浏览器下载完毕后再次上传到服务器上。

2. 下载并解压ngx_devel_kit套件

```
wget https://github.com/simpl/ngx_devel_kit/archive/v0.2.19.tar.gz
tar v0.2.19
```

3. 下载并解压lua-nginx-module模块

```
wget https://github.com/chaoslawful/lua-nginx-module/archive/v0.9.6.tar.gz
tar v0.9.6
```

4. 下载并解压nginx后，使用下面的命令重新编译nginx

```
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_flv_module --with-http_gzip_static_module --with-pcre --sbin-path=/usr/sbin/nginx --add-module=/root/lua-nginx-module-0.9.6 --add-module=/root/ngx_devel_kit-0.2.19 
make && make install
cp /usr/sbin/nginx /usr/local/nginx/sbin/

```

最后，在nginx的conf文件中的`server{}`上下文里加入下面代码

```
log_format  main_with_response  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"'
                      'request: "$request_body"' 'response: $resp_body';

server {

...
   lua_need_request_body on;
    set $resp_body "";
    body_filter_by_lua '
        local resp_body = string.sub(ngx.arg[1], 1, 1000)
        ngx.ctx.buffered = (ngx.ctx.buffered or "") .. resp_body
        if ngx.arg[2] then
             ngx.var.resp_body = ngx.ctx.buffered
        end
    ';

       location /xxxx {
            root   html;
            access_log  logs/access.log  main_with_response;
            proxy_pass http://192.168.203.198:8080;
        }

}
```

为避免response溢出整个日志，可选择在特定的location中使用输出response body。
