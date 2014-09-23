---
layout: post
title: "Java 和 Javascript的RSA"
date: 2014-09-19 13:57
comments: true
categories: 
- java
- nodejs
---


近来安全问题日益被重视，通过HTTP传输的部分数据也有了加密的需求。虽然最到位的办法肯定是HTTPS，但证书的申请是比较麻烦的。所以，还是决定
通过diy的方式，将浏览器中的部分敏感数据加密后再传给服务器。

说到加密算法，主要是对称或不对称，可逆或不可逆。最保险的当然是不可逆的密文传输，但是部分业务获得不可逆的密文后无法处理，只能选择可逆的形式。
而在浏览器中加密，显然用对称加密方式就不合适了。所以最后选择了RSA。既是不对称的也是可解密的。

这件事情里面，最麻烦的就是rsa的算法是java和javascript分别实现的。客户端的加密别无选择，只有js胜任。服务端主要提供给现有服务使用，因此主要就是Java。
而让两者配合，则是需要花费些功夫的。网上尽管资料不少，但讲清楚之间配合的很少。

## Javascript中的RSA

Java的加密算法之前已经用过多次，了解了一下js的rsa算法，还真的有不少，最后选了一个大家提到的比较多的[ras in javascript](http://www.ohdave.com/rsa/)。
在html中使用的代码如下:

```html
<html>
<head>
    <meta charset="UTF-8">
    <title>JavaScript RSA</title>
    <script type="text/javascript" src="http://www.ohdave.com/rsa/BigInt.js"></script></script>
    <script type="text/javascript" src="http://www.ohdave.com/rsa/RSA.js"></script></script>
    <script type="text/javascript" src="http://www.ohdave.com/rsa/Barrett.js"></script></script>
</head>
<body>
    <script type="text/javascript">
        //公钥加密明文
        setMaxDigits(231);
        var modulu = "00aad04454bda226e1";
        var key1 = new RSAKeyPair("010001", "", modulu);
        var password = "jack1234张三";
        var encryPssword = encryptedString(key1, password);
        document.write(encryPssword);
        alert(encryPssword);
        
        //私钥解密
        var priExp = "078c4c789faca941";
        var key2 = new RSAKeyPair("010001", priExp, modulu);
        var decryptedPssword = decryptedString(key2, encryPssword);
        alert(decryptedPssword);
    </script>
</body>
</html>
```
其中，`setMaxDigits`我理解下来是给计算留下足够多的空间的，一般选择秘钥位数(key_size)*2/16，每个digit可以放16个bit.  
`RSAKeyPair(encryptionExponent, decryptionExponent, modulus)`是构造钥匙的方法，实际上构造公钥（加密）只需要第一个参数和第三个参数，构造私钥（解密）只需要第二个参数和第三个参数。
第三个参数是类似模的一个东西，另外两个参数则是指数，根据模和各自的指数，就能生成相应的公钥和私钥的数字。而这个js的版本，都是返回的hex，即16进制的内容，且不支持中文，如果需要支持中文的话，需要自己先转成某种编码。不过，还剩下一个问题，就是模和指数从哪里获取呢？

## Java中的RSA

Java的RSA代码有很多，可以参考[链接](http://blog.csdn.net/songxiaobing/article/details/17505237)。关键在于如何使用这些API。

```java
  public static void main(String[] argvs) throws Exception {
    KeyPair keyPair = RSAUtil.generateKeyPair(null);
    RSAPublicKey pubKey = (RSAPublicKey) keyPair.getPublic();
    RSAPrivateKey priKey = (RSAPrivateKey) keyPair.getPrivate();

    byte[] pubModBytes = pubKey.getModulus().toByteArray();
    byte[] pubPubExpBytes = pubKey.getPublicExponent().toByteArray();
    byte[] priModBytes = priKey.getModulus().toByteArray();
    byte[] priPriExpBytes = priKey.getPrivateExponent().toByteArray();
    RSAPublicKey recoveryPubKey = RSAUtil.generateRSAPublicKey(pubModBytes,
        pubPubExpBytes);
    RSAPrivateKey recoveryPriKey = RSAUtil.generateRSAPrivateKey(
        priModBytes, priPriExpBytes);
       
    System.out.println("加密指数: "
        + SSOEncrypter.byte2hex(pubPubExpBytes));
    System.out.println("解密指数： "
        + SSOEncrypter.byte2hex(priPriExpBytes));
    System.out.println("公钥modulus: "+SSOEncrypter.byte2hex(pubModBytes));

  }

```

生成密钥对可以用`generateKeyPair`，并且会生成一个RSA文件。随后的重点是要把里面的公钥私钥转换成有`RSA`前缀的相应类，只有这样才能调出获得Exp和Mod的方法。
两个ModBytes得到的结果是一样的。所以在js里面，modulu就变成只有一个参数了。

## 二者的异同

如同之前预料的一样，两个语言写出来的加密解密在一些细节上是不一样的。

* java
  - 默认密文是二进制的，自己主动转成16进制的话是连续的
  - 原生支持中文

* javascript
  - 默认密文就是16进制的，且每个分组之间使用一个空格进行分隔
  - 分组内部的排列是倒序的
  - 不支持中文

下面的输出比较说明问题

```java
String s1 = SSOEncrypter.byte2hex(rsa.encrypt(pubKey,str.getBytes()));
System.out.println("加密后==" + s1); //加密后==0c983a3d17e57037456582ce61bc1276
System.out.println("解密后==" + Javanew String(rsa.decrypt(priKey, SSOEncrypter.hexStringToByte(s1)))); //解密后==abcdefghijklmn

js相同内容的输出为：
4831c7394dc3623c 5429366c63908d05 16d4229e4631084a
```
差异还是比较显而易见，具体的实现如下：

```java
/**
   * 解析js的rsa处理过来的密文
   * @param jsHex 的特点是每16个字符中间有空格分割，而且block还原的顺序需要颠倒过来
   * 
   * @throws Exception 
   */
  
  public String decryptFromJsRSA(String jsHex, RSAPrivateKey priKey ) throws Exception {
    String[] blocks = jsHex.split(" ");
    StringBuffer sb = new StringBuffer();
    String block = "";
    for (int i=blocks.length; i>0; i--) {
      block = blocks[i-1];
      //byte[] en_result = new BigInteger(block, 16).toByteArray();
      byte[] en_result = SSOEncrypter.hexStringToByte(block);
      
        byte[] de_result = decrypt(priKey, en_result);
        sb.append(new String(de_result));
    }
      //返回解密的字符串
      return sb.reverse().toString();
  }
  
```

## 中文编码的问题

上面用到的js的rsa库，写的很小巧，运行速度也很快。唯一的缺点就是不支持中文。好在按上面的算法，试了几千条数据后，确保非中文的情况下java和js之间的明文-密文转换是没有问题的。
所以只要给js加上Base64的编码，就可以解决问题了。

```javascript
    genRandomNum = function(pwdLen) {
    var count = 0; // 生成的密码的长度
    var str = [ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k',
        'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w',
        'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        '/', ';', '\'', ']', '{', '!', '#', '%', '^', '&', '*', '(', ')', '-', '#', '+', '=',
        '我', '爱', '北', '京', '天','安', '门',
        '日', '产', '别', '克', '大', '众', '丰', '田'];
    var maxNum = str.length;
    var pwd = '';
    while (count < pwdLen) {
      // 生成随机数，取绝对值，防止生成负数，
      var i = Math.floor(Math.random()*maxNum); // 生成的数最大为36-1
      if (i >= 0 && i < maxNum) {
        pwd += str[i]
        count++;
      }
    }
    //console.log(pwd);
    return pwd;
      
    }
    
  var pwds = [];
  for (var i=0; i < 100; i++) {
       var pwd = genRandomNum(Math.floor(Math.random()*40));
       pwds.push(pwd);
  }
        //公钥加密明文
        setMaxDigits(231);
        var modulu = "0085cf15ef6336cb3f";
        var key1 = new RSAKeyPair("010001", "", modulu);
        for (var pwd of pwds) {
          document.write(pwd+"[ ");
        }
        document.write("<br />");
        for (var pwd of pwds) {
          console.log(pwd);
          var encryPssword = encryptedString(key1, Base64.encode(pwd));
          document.write(encryPssword+", ");
        }
       
        
```

通过上面的程序，可以产生长度不等的多个随机密码，把明文进行base64转码后交给rsa加密成16进制的字符，然后就可以把得到的明文和密文交给java进行比对了。
另外Base64的编码是url不安全的。因为+ = /都是base64的适用字符，而这些在url传输中都会被转义，所以js的base64编码一般还有一个对url-safe的版本。
而在此处，rsa会最终转成16进制，因此并不需要使用url-safe的特性。考虑到Java的base64还是标准版的，所以使用标准版的base64更合适。


