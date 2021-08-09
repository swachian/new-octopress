---
layout: post
title: "静态文件的url后缀md5化"
date: 2015-01-22 09:55
comments: true
categories: 
- java
- 技术
- spring
---

长久以来，在jsp中引入css和JavaScript都是手工硬编的:

```jsp
<link href='/toolbar/static/orderFlow/css/reset.css' rel="stylesheet" type="text/css" />
<script src="/toolbar/static/jquery/jquery.min.js" charset="utf-8"></script>
```

好处很明显，最接近实际生成的html，很直观。坏处在于重复性高，而且无法控制后台生成的随机数，这样不太利于nginx等处理静态资源的缓存。终极方案莫过于在后缀上加上md5指纹信息，这样既可以让nginx等通知浏览器长期缓存，而一旦文件发生变化也必然可以让浏览器再次发起请求获得css和JavaScript。最终生成的页面信息达到下面的效果：

```jsp

<script src="/toolbar/static/jquery/toolbar.js?2dc0cb76e7faa4c150fca76981cbcd20" charset="utf-8"></script>
```

实现包含两部分，一方面需要可以计算出静态文件的md5值，另一方面则是可以在jsp中调用并生成上述html。多番比较后，发现jsp中还是使用标签比较合适，所以继续写tag文件：

style.tag
```jsp
<%@ tag pageEncoding="UTF-8" import="com.sanss.toolbar.hepler.BaseHelper" %>
<%@ attribute name="file" type="java.lang.String" required="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<link href='${ctx}<%=BaseHelper.rtg(file) %>' rel="stylesheet" type="text/css" />
```

javascript.tag
```jsp
<%@tag pageEncoding="UTF-8" import="com.sanss.toolbar.hepler.BaseHelper"%>
<%@ attribute name="file" type="java.lang.String" required="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<script src="${ctx}<%=BaseHelper.rtg(file) %>" charset="utf-8"></script>
```

其中使用到了BaseHelper里面的生成md5后缀级链接的方法`rtg(filepath)i`

```java
/** 生成静态文件链接的公共方法，加上md5后缀或者时间戳。
   * @param resource
   * @return
   */
  public static String rtg(String resource) {
    
    String fileMd5 = fileMD5s.get(resource);
    if (StringUtils.isEmpty(fileMd5)) {
      System.out.println(System.getProperty("user.dir"));
      fileMd5 = getFileMD5("../webapps/toolbar/static/"+resource);
      if (StringUtils.isEmpty(fileMd5)) {
        fileMd5 = timestamp;
      }
      fileMD5s.put(resource, fileMd5);
    }

    return "/static/"+resource+"?"+fileMd5;
  }
```

最不济的情况下，也能给文件加上启动日期的时间戳。

而在布局或者其他需要引入css和js的页面，直接使用这种代码即可:

```jsp
<tags:style file="styles/css1.css" />
<tags:javascript file="jquery/jquery.min.js" />
<tags:javascript file="jquery/tl.js" />
```
