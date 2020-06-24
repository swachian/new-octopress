---
layout: post
title: "查看java的线程cpu使用情况"
date: 2020-06-24 22:36
comments: true
categories: 
- 技术
- java
---

说来惭愧，那么些年写java，至今也没碰到需要对jvm内部线程cpu使用情况的研究。
今天碰到一例，因为用了flink，出现了一个处理瓶颈，不得不深入一探究竟。

就Linux的操作系统原理而言，jvm的线程是类似进程的东西，通过`top -Hn 14142` 可以查看到
14142这个进程内所有线程的cpu使用情况

```
 PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
14321 hadoop    20   0   17.7g   8.6g  27756 S 43.2 27.4   8:29.33 java
14275 hadoop    20   0   17.7g   8.6g  27756 S 15.9 27.4   2:45.05 java
14408 hadoop    20   0   17.7g   8.6g  27756 S  3.7 27.4   0:33.23 java
14274 hadoop    20   0   17.7g   8.6g  27756 S  2.3 27.4   0:37.25 java
14226 hadoop    20   0   17.7g   8.6g  27756 S  2.0 27.4   0:20.27 java
14222 hadoop    20   0   17.7g   8.6g  27756 S  1.3 27.4   0:12.78 java
14414 hadoop    20   0   17.7g   8.6g  27756 S  1.3 27.4   0:11.12 java
14254 hadoop    20   0   17.7g   8.6g  27756 S  1.0 27.4   0:10.05 java
14288 hadoop    20   0   17.7g   8.6g  27756 S  1.0 27.4   0:11.97 java
14415 hadoop    20   0   17.7g   8.6g  27756 S  1.0 27.4   0:10.99 java
15072 hadoop    20   0   17.7g   8.6g  27756 S  1.0 27.4   0:11.04 java
```

可以发现，14321 14275 这两个线程使用的cpu最多，那么这两个线程对应的算子是什么呢？这里就需要使用到jstack

`jstack 14142 > flink.dump` 

就可以得到jstack的信息。注意，需要以java进程运行用户的身份来运行上面的命令。

可以得到下面这些东西：

```
Full thread dump Java HotSpot(TM) 64-Bit Server VM (25.131-b11 mixed mode):

"Attach Listener" #3673 daemon prio=9 os_prio=0 tid=0x00007f76403d6000 nid=0x676d waiting on condition [0x0000000000000000]
   java.lang.Thread.State: RUNNABLE

"flink-metrics-22" #3672 prio=1 os_prio=0 tid=0x0000000002ef6000 nid=0x674f waiting on condition [0x00007f75bd85d000]
   java.lang.Thread.State: TIMED_WAITING (parking)
        at sun.misc.Unsafe.park(Native Method)
        - parking to wait for  <0x00000004406d94d8> (a java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject)
        at java.util.concurrent.locks.LockSupport.parkNanos(LockSupport.java:215)
        at java.util.concurrent.locks.AbstractQueuedSynchronizer$ConditionObject.awaitNanos(AbstractQueuedSynchronizer.java:2078)
        at java.util.concurrent.LinkedBlockingQueue.poll(LinkedBlockingQueue.java:467)
        at java.util.concurrent.ThreadPoolExecutor.getTask(ThreadPoolExecutor.java:1066)
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1127)
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
        at java.lang.Thread.run(Thread.java:748)

"flink-akka.actor.default-dispatcher-33" #3668 prio=5 os_prio=0 tid=0x00007f765db5f800 nid=0x66d8 waiting on condition [0x00007f75bf67d000]
```

jstack输出的hex也就是16进制的，所以我们需要把pid再做一下转换。使用python可以调用hex方法.

```
Python 3.6.8 (default, Aug  7 2019, 17:28:10)
[GCC 4.8.5 20150623 (Red Hat 4.8.5-39)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> hex(14321)
'0x37f1'
>>> hex(14275)
'0x37c3'
```

然后在dump文件中搜索`0x37f1`，可以得到

```
"at35__process -> (at35_e -> Sink: at35_sink, at35_current_parameter, at35_current_state) (1/1)" #142 prio=5 os_prio=0 tid=0x00007f7648a78800 nid=0x37f1 in Object.wait() [0x00007f75d53d6000]
   java.lang.Thread.State: WAITING (on object monitor)
        at java.lang.Object.wait(Native Method)
        at java.lang.Object.wait(Object.java:502)
        at org.apache.flink.runtime.io.network.partition.consumer.UnionInputGate.waitAndGetNextInputGate(UnionInputGate.java:211)
        - locked <0x0000000441ab5ae8> (a java.util.ArrayDeque)
        at org.apache.flink.runtime.io.network.partition.consumer.UnionInputGate.getNextBufferOrEvent(UnionInputGate.java:169)
        at org.apache.flink.streaming.runtime.io.BarrierBuffer.getNextNonBlocked(BarrierBuffer.java:165)
        at org.apache.flink.streaming.runtime.io.StreamTwoInputProcessor.processInput(StreamTwoInputProcessor.java:273)
        at org.apache.flink.streaming.runtime.tasks.TwoInputStreamTask.run(TwoInputStreamTask.java:117)
        at org.apache.flink.streaming.runtime.tasks.StreamTask.invoke(StreamTask.java:300)
        at org.apache.flink.runtime.taskmanager.Task.run(Task.java:711)
        at java.lang.Thread.run(Thread.java:748)
```

```
"at20_window -> (at20__message, at20_current_parameter, at20_current_state) (1/1)" #112 prio=5 os_prio=0 tid=0x00007f76485f1800 nid=0x37c3 in Object.wait() [0x00007f75d7af9000]
   java.lang.Thread.State: WAITING (on object monitor)
        at java.lang.Object.wait(Native Method)
        at java.lang.Object.wait(Object.java:502)
        at org.apache.flink.runtime.io.network.partition.consumer.UnionInputGate.waitAndGetNextInputGate(UnionInputGate.java:211)
        - locked <0x0000000441a00cc8> (a java.util.ArrayDeque)
        at org.apache.flink.runtime.io.network.partition.consumer.UnionInputGate.getNextBufferOrEvent(UnionInputGate.java:169)
        at org.apache.flink.streaming.runtime.io.BarrierBuffer.getNextNonBlocked(BarrierBuffer.java:165)
        at org.apache.flink.streaming.runtime.io.StreamTwoInputProcessor.processInput(StreamTwoInputProcessor.java:273)
        at org.apache.flink.streaming.runtime.tasks.TwoInputStreamTask.run(TwoInputStreamTask.java:117)
        at org.apache.flink.streaming.runtime.tasks.StreamTask.invoke(StreamTask.java:300)
        at org.apache.flink.runtime.taskmanager.Task.run(Task.java:711)
        at java.lang.Thread.run(Thread.java:748)
```

然后就可以看见线程的名字，就可以去代码里进一步对症下药了。