---
layout: post
title: "Apollo Config"
date: 2021-08-19 17:30
comments: true
categories: 
- 技术
- Java
---


配置项的管理始终是一个很头疼的问题。虽然磕磕绊绊总能凑合着过，但确实一直不太优雅，甚至容易出错。
人多的情况下，优雅是很难的，还是考虑怎么能减少损耗吧。所以抽空看了看Apollo的东西。

> Apollo（阿波罗）是携程框架部门研发的开源配置管理中心，能够集中化管理应用不同环境、不同集群的配置，配置修改后能够实时推送到应用端，并且具备规范的权限、流程治理等特性。

也支持热更新、版本控制、分组等比较实用的特性，据说还能适应复杂的流程治理要求。简单适用了一下，确实不负盛名。

### 一. 安装并启动Apollo

因为是试用，目前使用的是单机版的Apollo，后续可能会进一步调研一下高可用版的发布。

下载 `https://github.com/apolloconfig/apollo-build-scripts.git` ,  修改`demo.sh`里面的数据库配置信息和config server信息: 

```
 apollo_config_db_url="jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai"
-apollo_config_db_username=root
-apollo_config_db_password=

 # apollo portal db info
 apollo_portal_db_url="jdbc:mysql://localhost:3306/ApolloPortalDB?characterEncoding=utf8&serverTimezone=Asia/Shanghai"
-apollo_portal_db_username=root
-apollo_portal_db_password=

-config_server_url=http://localhost:8080
-admin_server_url=http://localhost:8090
 eureka_service_url=$config_server_url/eureka/
-portal_url=http://localhost:8070
```

config server就是未来的meta server，portal就是管理界面。

### 二. Java端的配置

对于基于Sprint Boot的应用而言，最简单和顺利的方式是在bootstrap.yml里面。操作步骤如下

1. 加入依赖 `    implementation group: 'com.ctrip.framework.apollo', name: 'apollo-client', version: '1.8.0'`   
2. 除去原先对config的依赖 `compile('org.springframework.cloud:spring-cloud-starter-config')`, 删除整个application.yml文件  
3. 删除application.yml文件，并把内容转移到apollo里面  
4. 在bootstart.yml里面替换下面的文件

```
apollo:
  bootstrap:
    enabled: true
    namespaces: application,application.yml
  meta: http://xxxx:8080
app:
  id: xxxxxx-compare-monit

```

enabled表示启用apollo读取配置，namespaces是给出了需要拉取的namespace，默认只有application一个，如果是自己添加的yml，则需要按上面的配置加一个。
meta就是config server的地址。app.id表示了应用的身份，需要和apollo的对应起来。

如果再portal侧重新发布配置项，可以看见下面的日志

```
INFO 69947 --- [Apollo-Config-1] c.f.a.s.p.AutoUpdateConfigChangeListener : Auto update apollo changed value successfully, new value: 222222, key: bcmonit.xxxxxKey, beanName: xxxxxxProperties, field: com.xxxxx.address.util.xxxxxProperties.xxxxxKey

```

更多的内容可以参考官网的设计文档，对apollo架构的介绍非常到位。

[Apollo官网设计文档](https://www.apolloconfig.com/#/zh/design/apollo-design)

### 三. K8S 部署

首先，要有一个K8S集群，可以参考 https://phoenixnap.com/kb/install-kubernetes-on-ubuntu 
来进行操作。但一般会需要trouble shotting，比较好的工具是通过`journalctl -xeu kubelet` 查看日志来定位问题，然后一一解决

- 安装docker   
- 安装kubeadm kubelet kubectl  
  * 用apt-mark hold把上面几个组件的版本**定**住  
- Master
  * 用kubeadm init --pod-network-cidr=10.244.0.0/16创建带网络信息的初始化  
  * 用kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml部署虚拟网络  
  * 查看pods的情况 kubectl get pods --all-namespaces
- Workder  
  * 用kubeadm join --discovery-token abcdef.1234567890abcdef --discovery-token-ca-cert-hash sha256:1234..cdef 1.2.3.4:6443 加入k8s集群。  
  * 其中的token可以通过kubeadmin token list查看，通过kubeadmin token create --ttl 0创建，sha256是证书，不会失效  
  * 通过kubectl get nodes查看节点状态  
- 安装服务或应用  
  * 使用helm  
  * 使用kubectl apply  

其次，安装helm，这是一个k8s的包管理工具:

```
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

查看安装效果

`kubectl get pods --all-namespaces -o wide` ，这个可以输出实际跑在各节点上的效果 

```
AMESPACE     NAME                                                       READY   STATUS              RESTARTS   AGE     IP             NODE                   NOMINATED NODE   READINESS GATES
default       apollo-service-dev-apollo-adminservice-566996fd98-mkdgm    1/1     Running             0          5d19h   10.244.2.3     master-node            <none>           <none>
default       apollo-service-dev-apollo-configservice-7f955f6f66-x2mjw   0/1     ContainerCreating   0          5d19h   <none>         master-node            <none>           <none>
default       my-nginx-5b56ccd65f-4rngp                                  1/1     Running             0          3h8m    10.244.2.2     master-node            <none>           <none>
kube-system   coredns-78fcd69978-kb5td                                   1/1     Running             0          5d20h   10.244.0.3     office-wallet-dev-17   <none>           <none>
kube-system   coredns-78fcd69978-l6m5g                                   1/1     Running             0          5d20h   10.244.0.2     office-wallet-dev-17   <none>           <none>
kube-system   etcd-office-wallet-dev-17                                  1/1     Running             0          5d20h   172.17.3.4     office-wallet-dev-17   <none>           <none>
kube-system   kube-apiserver-office-wallet-dev-17                        1/1     Running             0          5d20h   172.17.3.4     office-wallet-dev-17   <none>           <none>
kube-system   kube-controller-manager-office-wallet-dev-17               1/1     Running             0          5d20h   172.17.3.4     office-wallet-dev-17   <none>           <none>
kube-system   kube-flannel-ds-mbvzp                                      1/1     Running             0          18m     172.17.3.186   master-node            <none>           <none>
kube-system   kube-flannel-ds-x75sk                                      1/1     Running             0          5d20h   172.17.3.4     office-wallet-dev-17   <none>           <none>
kube-system   kube-proxy-n6q7x                                           1/1     Running             0          18m     172.17.3.186   master-node            <none>           <none>
kube-system   kube-proxy-ph8s5                                           1/1     Running             0          5d20h   172.17.3.4     office-wallet-dev-17   <none>           <none>
kube-system   kube-scheduler-office-wallet-dev-17                        1/1     Running             0          5d20h   172.17.3.4     office-wallet-dev-17   <none>           <none>
```

### Helm 和 kubectl apply的区别

默认kube提供的安装服务方法是`kubectl apply -f ./run-my-nginx.yaml`，适用于应用比较少的情况。如果应用很多，那么helm就可以帮上忙了。


https://www.apolloconfig.com/#/zh/deployment/distributed-deployment-guide?id=_24-kubernetes%e9%83%a8%e7%bd%b2

groovy for gradle: 

https://docs.gradle.org/current/dsl/org.gradle.api.Task.html

https://docs.gradle.org/current/userguide/tutorial_using_tasks.html