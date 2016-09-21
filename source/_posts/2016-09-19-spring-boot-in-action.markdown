---
layout: post
title: "spring boot in action"
date: 2016-09-19 14:47
comments: true
categories: 
- java
- spring
---

* Auto-Config
* 用starter处理依赖
* CLI 命令行处理启动等
* Actuator 监控组件 , 通过web或者shell

```
spring version 
spring --version
spring shell # windows下打开可以自动补全的功能
```

### 工程初始化
```
spring init -dweb,jpa,security --build gradle -p jar -x //-x表示生成到当前目录
spring init -dweb,jpa,security --build gradle -p war myapp //表示生成工程到myapp目录
```

```
@SpringBootApplication
public class DemoddfApplication {

public static void main(String[] args) {
SpringApplication.run(DemoddfApplication.class, args);
}
}
```

@SpringBootApplication 起到了过去3个标注的作用，打开了自动配置和自动扫描。如果有新的配置要求，@Configuration用在其他配置类中进行配置的扩充。而主class可以不必修改

用starter定义可实现更高度的抽象，也不必给出每个组件的版本号。通过`mvn dependency:tree`可查看实际的包依赖关系.
starter就是普通的maven或gradle依赖，所以可以exclude也可以指定更直接的版本。

### 自动配置定制化的举例

安全是最好的需要自己自行设置的例子，not one--size-fits-all。
这是yml方式
```
server:
port: 8443
ssl:
key-store: file:///path/to/mykeys.jks
key-store-password: letmein
key-password: letmein
```

配置数据源

```
spring:
datasource:
url: jdbc:mysql://localhost/readinglist
username: dbuser
password: dbpass
driver-class-name: com.mysql.jdbc.Driver
```

### 属性信息的几种来源

1 Command-line arguments
2 JNDI attributes from java:comp/env
3 JVM system properties
4 Operating system environment variables
5 Randomly generated values for properties prefixed with random.* (referenced when setting other properties, such as `${random.long})
6 An application.properties or application.yml file outside of the application
7 An application.properties or application.yml file packaged inside of the application
8 Property sources specified by @PropertySource
9 Default properties

在application.properties中指定`spring.profiles.active`的值后，boot就会读取application-{active}.properties的值


### 自动化测试

@WebIntegrationTest Test class有这个标注就会让spring启动一个测试的tomcat或jetty进程

```
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(
classes=ReadingListApplication.class)
@WebIntegrationTest

public class SimpleWebTest {
@Test(expected=HttpClientErrorException.class)
public void pageNotFound() {
try {
RestTemplate rest = new RestTemplate();
rest.getForObject(
"http://localhost:8080/bogusPage", String.class);
fail("Should result in HTTP 404");
} catch (HttpClientErrorException e) {
assertEquals(HttpStatus.NOT_FOUND, e.getStatusCode());
throw e;
}
}
}
```

代入参数
`@WebIntegrationTest(value={"server.port=0"})` 和 `@WebIntegrationTest("server.port=0")`

selenium的用ie模拟访问自己的服务很有意思，值得制作一个。

```java
                FirefoxDriver browser = new FirefoxDriver();
    browser.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
    String baseUrl = "http://www.baidu.com/";
    browser.get(baseUrl);
    String currentUrl = browser.getCurrentUrl();
    assertEquals(baseUrl +"/readingList", currentUrl);

    assertEquals("You have no books in your book list", 
                 browser.findElementByTagName("div").getText());

    browser.findElementByName("title").sendKeys("BOOK TITLE");
    browser.findElementByName("author").sendKeys("BOOK AUTHOR");
    browser.findElementByName("isbn").sendKeys("1234567890");
    browser.findElementByName("description").sendKeys("DESCRIPTION");
    browser.findElementByTagName("form").submit();
    
    WebElement dl = 
        browser.findElementByCssSelector("dt.bookHeadline");
    assertEquals("BOOK TITLE by BOOK AUTHOR (ISBN: 1234567890)", 
                 dl.getText());
    WebElement dt = 
        browser.findElementByCssSelector("dd.bookDescription");
    assertEquals("DESCRIPTION", dt.getText());
```
