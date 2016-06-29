---
layout: post
title: "Spring中的CRON"
date: 2014-12-28 15:12
comments: true
categories:
- java
- spring
---

在[Web容器中通过Spring添加Job任务](/blog/2014/09/11/webrong-qi-zhong-tong-guo-springtian-jia-jobren-wu/)一文中，
已经提过在spring中增加例行任务。只是当时提交的任务仅限于间隔一段时间后执行，比如每分钟执行一次，因此使用
`period` 和 `delay`两个参数就够了。

这次新遇到的需求是要求定点执行，比如固定在夜间23:30启动，这时候就需要cron了。好在Spring 4.0版
开始已经支持cron，配置起来也很简洁。

首先，在`spring-mvc.xml`中增加要定期执行的类作为bean，作用是把要定期执行的类交给spring扫描

```xml
<bean id="LastDayDevicePackorderlogRefreshTaskExecutor" class="com.sanss.toolbar.job.LastDayDevicePackorderlogRefreshTaskExecutor">
</bean>
```

其次，在这个类上使用标注`@EnableScheduling`，让spring意识到这是一个定期调度启动的任务。

```java
@EnableScheduling
public class LastDayDevicePackorderlogRefreshTaskExecutor implements Runnable {

}
```

最后，是在具体要启动的method上标注`@Scheduled(cron = "0 * * * * *")`，以此给出具体的执行安排。  
标注中cron的具体含义可以见下面的注释。

```java
	/*
	 * 一个cron表达式有至少6个（也可能7个）有空格分隔的时间元素。
	 *
	 * 按顺序依次为 秒（0~59）
	 *
	 * 分钟（0~59）
	 *
	 * 小时（0~23）
	 *
	 * 天（月）（0~31，但是你需要考虑你月的天数）
	 *
	 * 月（0~11）
	 *
	 * 天（星期）（1~7 1=SUN 或 SUN，MON，TUE，WED，THU，FRI，SAT）
	 *
	 * 7.年份（1970－2099）
	 */
	@Scheduled(cron = "0 * * * * *")
	public void run() {
		// TODO Auto-generated method stub
		// doit();
		logger.info("定期触发");
	}
o
```

## 补充

在`applicationContext.xml`中可加入` layoutxmlns:task="http://www.springframework.org/schema/task"`,使得可以用task标注。

同时在xsi:schemaLocation中加入`http://www.springframework.org/schema/task http://www.springframework.org/schema/task/spring-task.xsd`

随后就可以启用

```
    <!-- 定时任务相关启动 -->
<task:executor id="mvcyExecutor" pool-size="5"/>
<task:scheduler id="myScheduler" pool-size=layout"10"/>
<task:annotation-driven executor="myExecutor" scheduler="mySchedulerduler"/>
```

其作用类似于java配置的
```
@Configuration
@EnableAsync
@EnableScheduling
public class AppConfig {
}
```

其中executor用于异步，scheduler用于同步执行。

另外，对Bean做注解的时候一般使用@Component或其子注解（如：@Service）但是一定要注意使用@Lazy(false)（一般我们会在applicationContext.xml里根级标签，一般为beans里面设置default-lazy-init="true"，所以要想spring启动后定时任务就运行，必须用@Lazy(false）。)

