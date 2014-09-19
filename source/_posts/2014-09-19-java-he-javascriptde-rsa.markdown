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
