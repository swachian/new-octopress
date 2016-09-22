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

《Selenium WebDriver in Practice》但还没完成，可能要到2016年10月份才能出版 


/beans 列出创建的全部bean
/autoconfig 列出自动配置生效和未生效的内容
/env 列出设置的环境
/configprops 列出所有的参数
/metrics 列出访问的指标
/trace 给出近100个http请求的处理信息
/dump 给出所有线程的情况
/health 表明是否UP
/info 列出属性文件中info.开头的信息，但似乎有乱码

actuator的remote shell
默认启动一个端口在2000，每次启动时会生成一个密码，可以用ssh访问

```
ssh user@localhost -p 2000
Password authentication
Password:
```

自己定义metrics：

actuator有CounterService服务，可以用于增加值。
```
public interface CounterService {
void increment(String metricName);
void decrement(String metricName);
void reset(String metricName);
}



```

GaugeService是记录值

```
public interface GaugeService {
void submit(String metricName, double value);
}
```

自定义Health

```
@Component
public class AmazonHealth implements HealthIndicator {
@Override
public Health health() {
try {
RestTemplate rest = new RestTemplate();
rest.getForObject("http://www.amazon.com", String.class);
return Health.up().build();
} catch (Exception e) {
return Health.down().build();
}
}
}

//还可以加入更多的细节内容，使用withDetail

return Health.down().withDetail("reason", e.getMessage()).build();



```

上述endPoint的保护需采用所有spring暴露的链接一致的方式

`management.context-path=/mgmt`，其中的`management.context-path`可以给spring actuator定义全部的前缀

这样可便于统一控制
`.antMatchers("/mgmt/**").access("hasRole('ADMIN')")`

