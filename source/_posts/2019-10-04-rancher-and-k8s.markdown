---
layout: post
title: "rancher and k8s"
date: 2019-10-04 16:48
comments: true
categories: 
- 技术
---

今年不期而遇而使用的技术很多，除了大数据flink，就是rancher/k8s/docker了。

docker的话，几年前已经有过接触，总体感觉有价值，但对java来讲，帮助就比较有限了。  
k8s是对docker的编排，其实就是把docker作为基本的单元，让各种服务可以在一个抽象的层面跑起来，在服务监控、伸缩等方面都提供了很好的抽象和封装，易于运维人员操作。  
而Rancher，个人理解是k8s的编排，可能没那么复杂，但站在使用的角度，就便于安装、编辑、使用k8s的UI界面，当然，除了界面，幕后还有很多组件用于搭建一套k8s，启动相应的服务。

## 安装

因为他们都是基于docker的，所以前提需要安装好docker。然而，docker又是离不开OS的，所以前提是要装好OS。至于是物理主机还是虚机，倒是无所谓的。我选择使用Ubuntu 18.04 + Docker 19.03.2的组合，官方是到18.09.x。[https://rancher.com/docs/rancher/v2.x/en/installation/requirements/]

### 安装docker
```bash
# 1. 移除旧版本
sudo apt-get remove docker docker-engine docker.io

# 2. 更新apt包索引
sudo apt update

# 3. 安装https支持包
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

# 4. 添加Docker官方GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# 5. 添加稳定版的仓库源(按架构选择)
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# 6. 更新apt包索引 
sudo apt update

# 7. 安装
sudo apt-get install docker-ce
```

### 安装rancher

执行下面命令即可

```
docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher:latest
```
直接用docker启动rancher镜像，并映射80和443端口给rancher的UI界面。随后用浏览器即可访问到rancher服务，用admin账号登录进去后，就可以进行后续的操作。

### 增加集群

在rancher的浏览器界面里，通过`Add Cluster`即可以增加节点。  
首先需要增加的是etcd和controlpanel节点，这两个属于rancher的幕后服务。  
命令在浏览器里会有提示，得到命令后，到要加入集群并且已经安装好docker的虚机上执行即可。命令很简单，就一条：

```bash
sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run rancher/rancher-agent:v2.2.8 --server https://172.17.3.186 --token gjvvrqpf4sbkl2l48zmpcdpmcbcb68fntdj44vlb2784ttgct6s6wc --ca-checksum ae6f90ddff032e2d040015f70283c2e9ed5282ebdfafe0edf11e163b540dd2a7 --etcd --controlpanel

sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run rancher/rancher-agent:v2.2.8 --server https://172.17.3.186 --token gjvvrqpf4sbkl2l48zmpcdpmcbcb68fntdj44vlb2784ttgct6s6wc --ca-checksum ae6f90ddff032e2d040015f70283c2e9ed5282ebdfafe0edf11e163b540dd2a7 --worker
```
--etcd和--controlpanel可部署在同一台机器上。然后需要耐心等待一段时间，因为会起很多个docker的服务。

光有控制资源是不够的，还需要加入worker资源，这个就比较方便了，可以随时扩容。

### 新建服务

上述弄完以后，就可以发布新的服务了。

到新建的集群中选择`Deploy`，拉取对应的镜像，设置好pod数量，就可以拉起服务。不过，这个对应的镜像主要是公共的镜像，如果私有镜像，则需要另外进行配置。

## 新建私有docker仓库

本身构造仓库并不复杂，逻辑上只要找一台虚机启动一个docker的registry服务，然后在rancher浏览器的`Resources->Registries`中注册一下这个地址即可。  
但事实上永远不会那么简单。主要原因在于docker默认是需要https才能对外提供服务，这就需要进行很多额外的配置。当然，主要是私有仓库的配置。可以参考下面几个链接：
https://rancher.com/docs/rancher/v2.x/en/k8s-in-rancher/registries/
https://docs.docker.com/registry/deploying/
https://docs.docker.com/registry/insecure/

最后形成的做法如下。

一. 选择一台虚机作为registry主机，最好不要和rancher是一台机器，这样避免争抢443端口。在这台机器上先生成一下证书：
```bash
mkdir certs
openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout certs/domain.key \
  -x509 -days 365 -out certs/domain.crt
```

这里面要注意cn需要输入自己定义的域名，比如mydocker.co

二. 将生成的`domain.crt`改名为`ca.crt`, 上传或复制为其他docker主机的`/etc/docker/certs.d/mydocker.co/ca.crt`，绑定这些主机的`hosts`文件中该域名的指向到上一步的ip中，或者也可以修改域名服务器里该域名

三. 在第一台机器上运行docker的registry服务。
```bash
docker run -d \
  --restart=always \
  --name registry \
  -v "/opt/registry/certs":/certs \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/domain.key \
  -p 443:443 \
  registry:2
```

上面的命令中，`--restart=always`表示每次重启docker都会重启该服务，`-v`是挂载了卷，并将生成的ca证书指给了这个服务，3个`-e`设置了容器里运行的变量值，`-p 443:443`把主机和容器的443端口对应起来，`registry:2`表示第二个版本的registry

四. 再次deploy服务的时候，直接在镜像地址中带出`mydocker.co`开头的镜像链接即可，比如`mydocker.co/my-ubuntu` 。

## k8s的dns服务变迁

SkyDNS（1.2） -> KubeDNS（1.4） -> CoreDNS（1.11）  

kubedns: 监控service资源变化，生成service名称和ip的记录，并保存在DNS中  
dnsmasq: 为客户端容器提供dns服务  
sidecar: 对kubedns和dnsmasq提供健康检查服务  


CoreDNS和KubeDNS均是Go语言编写，但用一个服务替换了3个服务。


## ingress-nginx

ingress-nginx 默认是每个node 1个容器服务，`1 per node`  
通过rancher配置规则可以在`workloads->load balancing`中进行。里面的域名指向实际的worker主机地址。

## 核心组件

kube-proxy进程，负责获取每个Service的Endpoints，Endpoints实现service到pod之间的关联。

K8S的思路是每个对象都是一个资源，每个资源都有对应的controller：  
* RC Controller  
* Node Controller  
* ResourceQutoa Controller(cpu和memory限制的配置)  
* Namespace Controller  
* Service Controller & Endpoints Controller  
  

  Kubelet是每个Node上k8s的代理，

kube-proxy历经了从HA proxy -> iptables -> IPVS进化。核心诉求始终是性能驱动  
  

