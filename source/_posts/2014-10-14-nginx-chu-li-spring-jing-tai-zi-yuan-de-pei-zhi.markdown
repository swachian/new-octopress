---
layout: post
title: "Nginx 处理Spring 静态资源的配置"
date: 2014-10-14 13:19
comments: true
categories: 
- 技术
- java
- spring
---

用Nginx处理静态资源是挺常见的一个事情，自从使用了Spring，也经常直接利用Spring的处理静态文件的功能，也能打上Etag。避免流量传输。
但是近来发现，Spring处理静态资源后，对静态文件获取的请求浏览器还是会发起，只是每次都是返回304。所以想继续借助Nginx给Spring的静态资源打上expire的标记。

需求也算简单：

1. 基于app toolbar的动态请求转发给java
2. gif,png，js等nginx直接处理，并加expire 3h；
3. 部分.js请求如t.js还是转给java，有效期为0；
4. 敏感文件不会被nginx处理，如web.xml无法被nginx转走

因为目前Spring的静态资源单独存放在和WEB-INF并排的目录下，所以利用Nginx配置就大为简单了，只要限制路径名称即可。

```

        location /toolbar {
            root   html;
            proxy_pass http://192.168.203.198:8080;
        }
        location ~ /toolbar/static {
            root   html;
            if (-f $request_filename) {
                expires 1d;
                break;
            }
        }
        location = /toolbar/enter/t.js {
            root   html;
            proxy_pass http://192.168.202.72:8080;
        }
```

然后在nginx的html目录下建立目录`toolbar`，并在其增加一个符号连接` ln -s /home/web/apache-tomcat-7.0.56/webapps/toolbar/static static`，就可以实现上述要求了。

这里面用到了几种Nginx的配置。

1. `location /toolbar`，这是最基本的匹配字符串的表达方式，优先级一般情况下也最低，然而`^~`是一个例外，它的优先级比下面的正则要高。
2. `location ~ /toolbar/static`，这个是用到了正则表达式的匹配，优先级要高于基础的只比较字符。
3. `location = /toolbar/enter/t.js`，这是优先级最高的匹配符，要求uri完全相等。

如果需要使用正则表达式匹配，则必须使用`~`或者`~*`，其中后者和前者的区别是不区分大小写。

整个匹配顺序是：

1. 对`=`进行匹配，有相符的就停止；
2. 对所有的非正则表达式（为使用~ 和 ~*）进行匹配，如果遇到`^~`则也停止，否则全部比对完毕后，最接近的匹配将被选用作为候选，随后进入3匹配正则表达式；
3. 正则表达式按定义的顺序进行匹配，有匹配的则停止，即可选用刚刚匹配的正则表达式，如没有匹配的正则，则选用2中得到的结果。

因此对静态资源的选择，可以加上`~`，也可以不加。但为了避免今后配置的冲突，还是让静态资源的优先级高一些来的好。

随后，可以使用下面的链接进行测试，看看是否满足需求：

http://192.168.203.198/toolbar/enter/t.js,  
http://192.168.203.198/toolbar/static/images/logo1.png,  
http://192.168.203.198/toolbar/WEB-INF/web.xml

前面两个应该得到返回内容，最后一个应该获得报错。



