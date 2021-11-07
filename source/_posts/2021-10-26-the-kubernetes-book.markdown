---
layout: post
title: "The Kubernetes Book"
date: 2021-10-26 09:47
comments: true
categories: 
- 技术
- linux
---

The Kubernetes book, 购于Leanpub  

# 1&2 Kubernetes 基础和操作
## Control plane node (Masters, Heads)

The API Server  
   所有的入口

The cluster store(etcd)  
    分布式数据库，3-5个拷贝，采用RAFT算法，由一个领袖说了算
    C优先于A，一旦不一致，就不能再更新了

The Controller manager  
    Deployment, StatefulSet, ReplicaSet
    

The Scheduler  
    检查Node的状况，给Node评分，以挑选合适的可以执行任务的Node  

The cloud controller manager  
    提供公有云服务的load-balancer到app的连接等

## Worker(Kubelet)

Kubelet  
    安装在主机上的代理，负责向heads汇报状态，并接受任务安排

Containerd  
    从Docker抽象出来的接口，K8S已经不再直接支持Docker  

kube-proxy  
    运行在node上的网络组件，给每个node分配不同的docker内网，建立iptables表格完成路由功能

Kubernetes DNS  
    每个Pod都有一个静态的Ip地址写了DNS服务，基于开源CoreDNS项目开发  

## 声明模式和渴望的状态

1. 在manifest文件里声明目标状态（image，replicas数量，网络端口，如何更新）  
2. Post给API服务（kubectl命令）  
3. Kubernetes存入集群store（解析并分解成操作步骤入库）  
4. Kubernetes实现目标状态(安排任务执行)  
5. 一个controller确保观察到的状态不会和目标状态不同(reconcile循环)  

## Pods 

A flock of birds 一群鸟 A pod of whales 一群鲸  
所以pod就是一群dockers/containers    


## Deployments

一般不会直接部署pods，而是通过Controllers进行部署

## Service

提供TCP UDP层面稳定的网络抽象

# 3. 部署Kubernetes

AWS: EKS, Azure: AKS, Google: GKE  
腾讯: TKE, 阿里云: ACS（C是container）的缩写

可以在自己的机器上部署K8S作为练习：如docker Desktop，k3d, 开发可以用单机版的尝试

## kubectl

~/.kube/config，中存放了命令行的操作配置

Clusters，Users和Contexts，前二者可以通过最后一个进行关联，表示用哪个用户的账号去操作哪个cluster

`kubectl config current-context`用于查看当前活跃的context  
`kubectl config use-context docker2` 用于调整当前活跃的context  



# 4. 用Pods工作

1. 让资源共享：文件系统、同一个IP、共享内存、共享存储  
2. 一个pod中可以有多个containers，同一pod内的container可以通过localhost+不同的端口进行通信  
3. 通过Controller部署的pods才有高可用等特性支持  
4. 直接通过Pod manifest部署的pod，只有自生自灭  

Pod本身就是容器  

## The pod network

Pod的网络叫做pod network，是一种扁平的、各个pod可以彼此直接访问的组网。

## 生命周期有长有短的pod

long-lived: Deployments, StatefulSets, DaemonSets  
short-lived: CronJobs, Jobs  

长的多用于服务，短的多用于批量job。

## 多Containers的几种花样  

Sidecar: 德国摩托车旁边的侧车；即一个container为主，一个为辅的模式。serice mesh里面常常用来对流量加密、暴露测量的数据  
Adapter: sidecar的变种，比如把nginx的日志转变成普罗米修斯能解析的格式  
Ambassador：也是变种，含义上讲更像是主container的使者  
Init: 在拉起主app之前，执行一些辅助工作，通常只执行一次  

`kubectl apply -f pod.yml` 运行一个简单的pod，下面两个命令用于查询pod及其内容器的状态  
`kubectl describe pods hello-pod`  
`kubectl get pods  hello-pod  -o wide`  

普通的执行命令 `kubectl exec hello-pod -- ps aux`  
获取pod内shell的命令 `kubectl exec -it hello-pod -- sh`, 注意需要加上`it`  

# 5. Namespace 

查看命名空间 `kubectl get namespaces`  可以缩写为`ns`  

用kubectl可以命令式创建ns，用yaml文档可以声明式创建  
`kubectl create ns hydra`  
`kubectl apply -f shields-ns.yml`  

切换默认的ns `kubectl config set-context --current --namespace ss`  

声明式的清除 `kubectl delete -f shield-app.yml` 

# 6. Kubernetes部署

Workload apis: Deployments, DaemonSets, StatefulSets

Deployments是aggregation root，内部其实还有ReplicaSet， 通过ReplicaSet来操作Pods

Reconcile：补锅，补偿，使得现实变成目标  

```yaml
piVersion: apps/v1
kind: Deployment
metadata:
  name: hello-deploy
spec:
  replicas: 10
  selector:
    matchLabels:
      app: hello-world
  minReadySeconds: 10
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-pod
        image: nigelpoulton/k8sbook:latest
        ports:
        - containerPort: 8080
```

`.spec.selector`中的label选择了template中的app，注意label Selectors

`ubectl get deploy hello-deploy`  
`kubectl scale deploy hello-deploy --replicas 5`

rollback， clean-up

# 7. Service

1. Service是一个K8S对象  
2. Service有稳定的ip地址(a cluster ip)、dns名字以及port口  
3. 利用labels和selectors去动态地选择pods以传递流量   

从外部访问的方法：1. NodePort， 2. LoadBalancer

使用DNS服务作为服务发现的核心。Service名称会自动注册到DNS集群中，每个pod及其container都预先配置了dns集群的配置，以解决Service Name 到 ClusterIP之间的映射   

# 8. Ingress

Ingress属于七层交换的概念，可以通过域名或路径等组合来转发请求   

NodePorts的缺点： 使用的port偏大，30000-32767  
LoadBalancer缺点： 需要和云的load-balancer 1-to-1 对应，开销容易很大  
Ingress可以在只有一个云load-balancer的情况下完成多个服务的路由  

不过，如果使用一个service mesh，可能Ingress的作用就不大了。  

Ingress也是一种controller，只是大部分不是内建的。

可以使用helm创建nginx-ingress

```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ss
kubectl get pods -n ss -o wide

ingress-nginx-controller-5c8d66c76d-2kq2f   1/1     Running   0          49m   10.244.2.34   master-node   <none>           <none>

kubectl get svc
NAME                                 TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx-controller             LoadBalancer   10.108.112.4    <pending>     80:32003/TCP,443:30330/TCP   50m

```

但因为是自建的kubeadm，所以没有云原生的直接load-balance的支持，但可以通过32003端口对服务进行访问。

# 9. 服务发现详解

```
kubectl get pods -n kube-system  -o wide
NAME                                           READY   STATUS    RESTARTS      AGE   IP             NODE                   NOMINATED NODE   READINESS GATES
coredns-78fcd69978-kb5td                       1/1     Running   1 (8d ago)    59d   10.244.0.4     office-wallet-dev-17   <none>           <none>
coredns-78fcd69978-l6m5g                       1/1     Running   1 (8d ago)    59d   10.244.0.5     office-wallet-dev-17   <none>           <none>
```

control plane上有dns集群

svc部署后会分配一个vip，也就是clusterIp；因为svc name最终会进入dns服务，所以这也是svc的命名规则要求和dns域名一致的根本原因

Kube-proxy会完成对Endpoints的监控和转发调整。现代版本的linux普遍使用IPVS，老的使用iptables。

clusterIp是一个不存在的IP，所以container传给node，node传给它的gateway（node的kernel，IPVS或Iptables），由kube-proxy负责对ClusterIp的重定向。
IPVS是L4 load-balancer，扩展的性能更优越。

服务发现和namespace

`<object-name>.<namespace>.svc.cluster.local`

`kubectl get all -n dev` 可以同时列出 svc pods

# 10. Storage

Storage采用的CSI plugin的机制。

SC - StorageClass 定义存储的硬件  
PVC - 变成PV的请求，也是Pod可以使用的存储    
PV - SC检测到PVC后，会变成PV  

- PVC里的Access mode:  
  * ReadWriteOnce(RWO)传统的一块硬盘  
  * ReadWriteMany(RWM) NFS这种支持多个加载  
  * ReadOnlyMany(ROM)  可被多少只读  

PV只能按一种模式打开  

`kubectl get sc`  

解除后数据是否删除的策略：1. Delete 2. Retain  
Sc中的VolumeBindingModo: 1. Immediate 2. WaitingForFirstConsumer(Pod)  

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: volpod
spec:
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: pvc-prem
  containers:
  - name: ubuntu-ctr
    image: ubuntu:latest
    command:
    - /bin/bash
    - "-c"
    - "sleep 60m"
    volumeMounts:
    - mountPath: /data
      name: data
```

# 11. ConfigMaps and Secrets

ConfigMaps是键值对，value可以是一个简单的值，也可以是一整个配置文件。  
注入container有几种方式：1. 环境变量 2. 启动的命令 3. volume中的文件  
env var； cmd； vol

`kubectl create configmap `

vol最大的优势是一旦修改了configMap，可以在container的mount位置立刻看见修改。而两位两个必须重启容器。即Vol的注入是动态的，env的注入是静态的。

Secret只是以base64的形势存放起来

# 12. StatefulSets


与Deployment相比的差异：  
1. 可预知的持久的pod名字  
2. 可预知的持久的DNS主机名字  
3. 可预知的持久度vol绑定  

pod生成的规则：<StatefuleSetName>-<Integer>，而且是按顺序依次启动，完成前一个，才启动后一个。  

Stateful controllers自己直接处理治愈和扩容，而不是假手ReplicaSet

## headless service and StatefulSet's governing service

headless service就是clusterIP为空的service，搭配StatuefulSet，就会产生独立的每个pod的dns名称。app的调用也会基于具体的pod 名称。

`volumeClaimTemplates`用于给每个stateful pod创建动态PVC。

独立pod的dns命名规则为<object-name>.<service-name>.<namespace>.svc.cluster.local

如果是pod退出，那么StatefulSet可以很容易地重新创建一个替代的pod。但如果是node不正常，则需要手工干预。


# 13. API 安全和RBAC

user,gourp, Service acct -> API server -> authN -> authZ -> Admission control

Kubernetes没有自己的identity database，主要通过和其他auth模块集成（plug-in）的方式来实现authN。  
比如client certs，webhooks，IAM（Identity Access Management)  

K8S的authZ只有allow没有deny，因为默认全部都是deny。

```yaml
rules:
  - apiGroups: ["apps"]
    resources: ["deployments"]
    verbs: ["get", "watch", "list"]
```

`*`意味着全部授权

4个RBAC对象

* Roles  
* ClusterRoles  
* RoleBindings  
* ClusterRoleBindings

顾名思义，可以使用的namespace是不同的。需要注意的是，ClusterRoles经常和RoleBindings搭配使用。

Admission controller有很多个，实际主要负责批准相应的请求。

# 14. The Kubernetes API

JSON + Protobuf支持，

可以自己定义并扩展API

# 15. Threat和K8S

STRIDE 模型 

Spoofing欺骗:  
  - 通信层面的安全TLS  
  - 限制pod和API server的通信，token的失效期等等  

Tampering篡改:  
  - 组件的篡改：etcd，api server，controller，scheduler，kubelet，镜像运行时，镜像文件等  
  - 运行的pod修改  

Repudiation否认:  
  - 中央化的收集各个组件的审计日志  

Information Disclosure 信息泄露:  
  - KMS和HSM是实现key和数据在节点上分离  

Denial of Service(DOS):  
  - HA  
  - WAF

Elevation of privilege:  





