---
layout: post
title: "Web容器中通过Spring添加Job任务"
date: 2014-09-11 21:59
comments: true
categories:
- 技术
- java
- spring
---

实际投入使用的Web站点总有很多例行任务要做，习惯的做法是利用操作系统的crontab定期执行脚本或者Java程序。
在更早的时候，曾经试过quartz，但后来因为quartz创建的线程属于JVM而不是Web容器，导致停止或
重新部署应用时线程并未终止，因此后来跑java程序例行任务的话，主要就
是单独运行jar文件。

时过境迁，了解到Spring已经接管了定时任务的线程处理，之前在
Web容器里跑多线程任务的最大隐患已经不存在了，所以尝试了一下在
Spring中使用例行更新。

这样做最大的好处当然就是代码集中，容易维护也容易部署。

### 功能说明

整个功能并不复杂，需要对redis中的设备号列表进行遍历，对每一个
号码调用远程接口获取该号码的一些动态变化的信息。取得后，这些信息
的时效时间是6小时，在失效前的10分钟内，需要再次调用远程接口刷新缓存。

因为整个功能的瓶颈在于远程调用，为了提高并发，
调用远程接口采取多线程的方式。而遍历的性能极好，使用单线程就够了。

### 使用组件

采用Java中线程的Executors实现起来最简单直接。Executors实质上就是一个
线程池，每塞给一个号码，就调用派发一个线程进行处理。如果没有线程可派，
则放入队列中，如队列满了则会依据设置再增加线程数量。

```java
private	TaskExecutor taskExecutor
```

Executor确实是一个比较好的多线程编程方式，融合了Actor模式和队列，
使用起来也比较方便。

Executors可以由spring进行注入，在这个任务里比较合适的是采用ThreadPool*

```xml
	<bean id="taskExecutor" class="org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor">
        <property name="corePoolSize" value="5" />
        <property name="maxPoolSize" value="10" />
        <property name="queueCapacity" value="2500" />
    </bean>

```
corePoolSize是例行打开的线程数，queueCapacity是在没有core线程处理时的排队数量，
当超过这个数量时，会再启动线程直到maxPoolSize。如果都使用完毕，则可指定溢出时的抛弃处理方式。

派发任务由`taskExecutor.execute(new PollItInterfaceTask(mdn))`表达，
要同步的数据通过mdn传入。

此外，因为遍历的线程执行速度快，而workers可能需要更长时间才能完成队列中的任务，
为防止重复提交设置了一个多线程会并发访问的集合`private Set<String> mdnInQueue = new ConcurrentSkipListSet<String>(); //用于记录已安排执行但还未执行的号码`
。整个代码的情况如下:

```java
package com.sanss.toolbar.job;

import java.util.Date;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.TimerTask;
import java.util.concurrent.ConcurrentSkipListSet;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.junit.Assert;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.task.TaskExecutor;

import com.sanss.toolbar.service.CacheItInterfaceQueryService;

/*多线程发起的、向IT抓取用户套餐信息的线程池执行者，由spring中触发，根据接口run()*/
public class PollItInterfaceTaskExecutor  implements Runnable {

	private static Log logger = LogFactory.getLog(PollItInterfaceTaskExecutor.class);
	private Set<String> mdnInQueue = new ConcurrentSkipListSet<String>(); //用于记录已安排执行但还未执行的号码
	@Autowired
	CacheItInterfaceQueryService cacheItInterfaceQueryService;

	/*实际被多线程执行的任务,获取在队列中存放的mdn*/
	private class PollItInterfaceTask implements Runnable {
		private String mdn;
		public PollItInterfaceTask(String mdn) {
			this.mdn = mdn;
		}

		public void run() {
			cacheItInterfaceQueryService.setCacheFlux(mdn);
			mdnInQueue.remove(mdn);
			Thread currentThread = Thread.currentThread();  // 获得当前的线程  
			String threadName = currentThread.getName();  
			logger.debug(threadName + ": 刷新下面号码的cache: " + mdn);
		}
	}

	private TaskExecutor taskExecutor;

	public PollItInterfaceTaskExecutor(TaskExecutor taskExecutor) {
		this.taskExecutor = taskExecutor;

	}

	//任务出发后，被run自动执行的任务。首先获得所有需要提前取得IT流量信息的hashkey集合，随后遍历集合分别取出相关的一系列mdn，
	//之后根据mdn检查ttl信息，发现小于500秒就安排Executor执行任务。
	public void doit() {
		Set<String> tlbKeys = cacheItInterfaceQueryService.getAllTlbsetQueryList();
		int total = 0; //号码列表总数
		int count = 0; //本轮需要刷新的
		for (String hshkey : tlbKeys) {
			Map<String, String> mdns = cacheItInterfaceQueryService.getAllFieldsByAKey(hshkey);
			for(String mdn : mdns.keySet()) {
				long ttl = cacheItInterfaceQueryService.ttlFlux(mdn);
				if (ttl < 500 ) {
					if (!mdnInQueue.contains(mdn)) {
						mdnInQueue.add(mdn);
					    taskExecutor.execute(new PollItInterfaceTask(mdn));
					    count++;
				   }
				}
				total++;
			}
		}
		logger.info("本轮刷新"+count+"个记录, 共有"+total+"个记录");
    }

	@Override
	public void run() {
		// TODO Auto-generated method stub
	 System.out.format("开始执行 %s ...%n", new Date());  
		doit();
	}

}

```

CacheItInterfaceQueryService是项目中的一个服务模块，负责具体设置缓存。

```xml
<!-- 定期去IT接口轮训的部署 -->
	<bean id="taskExecutor" class="org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor">
        <property name="corePoolSize" value="5" />
        <property name="maxPoolSize" value="10" />
        <property name="queueCapacity" value="2500" />
    </bean>

      <bean id="pollItInterfaceTaskExecutor" class="com.sanss.toolbar.job.PollItInterfaceTaskExecutor">
           <constructor-arg ref="taskExecutor" />
     </bean>

    <bean id="springScheduleExecutorTask"  
        class="org.springframework.scheduling.concurrent.ScheduledExecutorTask">  

        <property name="runnable" ref="pollItInterfaceTaskExecutor" />  

        <property name="delay" value="1000" />  
        <!-- 每次任务间隔 一分钟-->  
        <property name="period" value="60000" />  
    </bean>  

     <bean id="springScheduledExecutorFactoryBean"  
        class="org.springframework.scheduling.concurrent.ScheduledExecutorFactoryBean">  
        <property name="scheduledExecutorTasks">  
            <list>  
                <ref bean="springScheduleExecutorTask" />  
            </list>  
        </property>  
    </bean>  

```
避免不了的配置如上，`taskExecutor`已经在前面描述过，第二段的`pollItInterfaceTaskExecutor`就是把线程池执行者
作为参数传给自己编写的任务的构造函数，然后第三段定义一个周期执行的任务，设置好执行的间隔，runnable要提供自己编写的业务类（第二段中的内容），
最后第四步把这个周期任务交给Spring的`ScheduledExecutorFactoryBean`工厂来负责管理。
需要注意的是，ScheduledExecutorFactoryBean是spring4中的写法，在spring3中还是另一套描述方式，虽然功能差不多。
但在版本升级时，这是一个不大不小的坑。
