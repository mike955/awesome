## k8s网络与通信


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [k8s网络与通信](#k8s网络与通信)
	* [1.k8s网络模型](#1k8s网络模型)
	* [2.docker网络](#2docker网络)
	* [3.k8s网络实现](#3k8s网络实现)
		* [3.1 容器到容器之间通信](#31-容器到容器之间通信)
		* [3.2 pod之间进行通信](#32-pod之间进行通信)
			* [3.2.1 同一个Node内的pod之间通信](#321-同一个node内的pod之间通信)
			* [3.2.2 不同Node上的pod之间通信](#322-不同node上的pod之间通信)
		* [3.3 Pod到Service之间进行通信](#33-pod到service之间进行通信)
		* [3.4 集群外部访问service或pod](#34-集群外部访问service或pod)
			* [3.4.1 将容器端口号映射到物理机（pod级别）](#341-将容器端口号映射到物理机pod级别)
			* [3.4.2 将service端口号映射到物理机（service级别）](#342-将service端口号映射到物理机service级别)
	* [4.CNI网络模型和容器网络模型](#4cni网络模型和容器网络模型)
	* [5.k8s网络策略](#5k8s网络策略)
	* [6.开源网络组件](#6开源网络组件)
		* [6.1 Flannel](#61-flannel)
		* [6.2 Open vSwitch](#62-open-vswitch)
		* [6.3 Calico](#63-calico)

---

### 1.k8s网络模型

 - 每个pod都有一个独立的IP地址，且假定所有pod都是可以直接连通，并处在一个扁平的空间中
 - pod之间访问使用的是对方pod的实际地址（docker0上分配的）
 - IP-per—Pod模型

### 2.docker网络


### 3.k8s网络实现
 
k8s网络设置主要致力于解决一下场景

 - 容器到容器之间通信
 - 抽象的pod到pod之间进行通信
 - Pod到Service之间进行通信
 - 集群外部与内部组件之间进行通信

#### 3.1 容器到容器之间通信

 同一个pod内的容器共享一个网络命名空间，共享一个IP地址，可以使用linux的IPC通信，它们之间互相访问只需要使用localhost

#### 3.2 pod之间进行通信

##### 3.2.1 同一个Node内的pod之间通信

&emsp;&emsp;pod1和pod2都是通过Veth连接在同一个docker0网桥上的，他们的IP地址IP1、IP2都是从docker0网桥上动态获取的，他们和网桥本身的IP3是同一个网段。
 
&emsp;&emsp;pod1和pod2的Linux协议栈上，默认路由都是docker0的地址，也就是说所有非本地的网络数据，都会默认发送到docker0的网桥上，由docker0网桥直接中转。

&emsp;&emsp;因此pod1和pod2关联在同一个docker0网桥上，地址段相同，所有他们之间能够通过*PodIP:containerPort*进行通信

##### 3.2.2 不同Node上的pod之间通信

&emsp;&emsp;由于不同Node上的Pod连接的不是同一个docker0网桥，IP地址段可能不同，且处在不同命名空间中，因此不能直接进行通信。

&emsp;&emsp;不同Node上的Pod之间的通信，需要满足两个条件：

 - k8s集群对pod的IP分配进行规划，不能有冲突
 - 将pod的IP和所在的Node的IP关联起来，通过这个关联让Pod可以互相访问

#### 3.3 Pod到Service之间进行通信

#### 3.4 集群外部访问service或pod

serivce是k8s集群范围内的概念，所以集群外的客户算系统无法通过Pod的IP地址或service的虚拟IP地址和虚拟端口号访问到他们，解决方法是将pod或service的端口号映射到宿主机。

##### 3.4.1 将容器端口号映射到物理机（pod级别）

（1）设置container级别的hostPort，将容器端口号映射到物理机

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: webapp
 labels:
  app: webapp
spec:
 containers:
 - name: webapp
   image: tomcat
   ports:
   - containerPort: 8080
     hostPort: 8081     #物理机IP:hostPort 可以访问pod内的容器(不同的hostPort对应不同的容器)
```

（2）设置Pod级别的hostNetwork=true，该pod中所有容器的端口号都被直接映射到物理机上，设置hostNetwork=true时需要注意一下几点：
  
 - 容器的ports部分如果不指定hostPort，则默认hostPort等于containerPort
 - 如果指定hostPort，则hostPort必须等于containerPort

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: webapp
 labels:
  app: webapp
spec:
 hostNetwork: true    #设置pod级别端口映射
 containers:
 - name: webapp
   image: tomcat
   ports:
   - containerPort: 8080    #物理机IP:containerPort，可以访问到pod内的容器
```

##### 3.4.2 将service端口号映射到物理机（service级别）

（1）设置nodePort映射到物理机，同时设置service的类型为NodePort

```yaml
apiVersion: v1
kind: Service
metadata:
 name: webapp
 labels:
  app: webapp
spec:
 type: NodePort
 ports:
 - port: 8080
   taregtPort: 8080
   nodePort: 8081     #物理机IP地址:nodePort可以访问到服务，需配置防火墙
 selector:
  app: webapp
```

（2）设置LoadBalancer映射到云服务提供商提供的LoadBalancer地址，仅使用在公有云场景


### 4.CNI网络模型和容器网络模型


### 5.k8s网络策略


### 6.开源网络组件

*将不同Node上的Docker容器之间的互相访问打通*

#### 6.1 Flannel

flannel可以搭建k8s依赖的底层网络，是因为它可以实现以下两点：

 - 它能协助k8s，给每一个Node上的Docker容器分配互相补不冲突的IP地址
 - 它能在这些IP地址之间建立一个覆盖网络(Overlay Network)，通过这个覆盖网络，将数据包原封不动地传递到目标容器

实现原理：

 - flannel首先创建了一个名为flannel0的网桥，这个网桥一段连接docker0，另一段连接一个叫flanneId的服务进程
 - flanneld进程首先上连etcd，利用etcd来管理可分配的IP地址段资源，同时监控etcd中每个pod的实际地址，并在内存中建立了一个pod节点路由表
 - flanneld下连docker0和无物理网络，使用内存中的pod节点路由表，将docker0发给它的数据包包装起来，利用物理网络的连接将数据包投递到目标FlanneId上，从而完成pod到pod之间的直接的地址通信
 - flannel之间的底层通信协议可选余地有很多，有UDP、VxLan、AWS VPC等；源flanneld加包，目标flanneld解包；常用的是UDP协议

其它：

 - flannel完美实现了对k8s网络的支持，但是引入了多个网络组件，会带来一定网络延时
 - 在大流量、高并发应用场景下还需反复测试

Flannel安装和配置

（1）安装etcd

（2）安装Flannel

&emsp;&emsp;需要在每台Node上都安装Flannel，将下载的压缩包xxx.tar.gz解压，把二进制文件falnnelId和mk-docker-opts.sh复制到/usr/bin(或PATH环境变量中)中，完成安装；

（3）配置Flannel

&emsp;&emsp;1.以systemd系统为例对flanneld服务进行配置，编辑配置文件/usr/lib/systemd/system/flanneld.service:

```service
[Unit]
Description=flanneld overlay address etcd agent
After=network.target
Before=docker.service

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/flanneld
ExecStart=/usr/bin/Flanneld -etcd-endpoint=${FLANNEL_ETCD} $FLANNEL_OPTIONS

[Install]
RequiredBy=docker.service
WantedBy=multi-user.target
```

&emsp;&emsp;2.编辑配置文件/etc/sysconfig/flannel，设置etcd的URL地址：

```sh
# flanneld configuration options

# etcd url localtion. Point this to the server where etcd runs
FLANNEL_ETCD="http://192.168.18.3:2379"

# etcd config key. This is the configuration key that flannel queries
# For address range assignment
FLANNEL_ETCD_KEY="/coreos.com/network"
```

启动flanneld服务之前，需要在etcd中添加一条网络配置设置，这个配置将用于flanneld分配给每个Docker的虚拟IP地址段

```sh
etcdctl set /coreos.com/network/config '{"Network": "10.1.0.0/16"}'
```
由于Flannel将覆盖docker0网桥，所以Docker服务已启动，则需要停止Docker服务


&emsp;&emsp;3.启动flanneld服务

```sh
systemctl restart flanneld
```

&emsp;&emsp;4.设置docker0网桥ID地址

```sh
mk-docker-opts.sh -i
source /run/flannel/subnet.env
ifconfig docker0 ${FLANNEL_SUBNET}
```

&emsp;&emsp;5.重新启动Docker服务

```sh
systemctl restart docker
```

#### 6.2 Open vSwitch

#### 6.3 Calico

相关介绍

 - Calico是一个基于BGP的纯三层网络方案
 - Calico在每个计算节点利用Linux Kernel实现一个高效的vRouter来负责数据转发
 - 每个vRouter通过BGP1协议把在本节点上运行的容器的路由信息向整个Calico网络广播，并自动设置到达其他节点的路由妆法规则
 - Calico保证所有容器之间的数据流量都是通过IP路由的方式完成互联互通的
 - Calico节点组网可以直接利用数据中心的网络结构，不需要额外的NAT、隧道或者Overlay Network，没有额外的封包解包，能够节约CPU运算，提高网络效率
 - Calico在小规模集群中可以直接互联，大规模集群中可以通过额外的BGP route reflector来完成
 - Calico基于Iptables提供了丰富的网络策略

Cailico主要组件

 - Felix：Calico Agent，运行在每台Node上，负责为容器设置网络资源（IP地址、路由规则、Iptables规则等），包住夸主机容器网络互通
 - etcd：Calico使用的后端存储
 - BGP Client(BIRD)：负责吧Felix在各个Node上设置的路由信息通过BGP协议广播到Calico网络
 - BGP Route Reflector(BIRD)：通过一个或多个BGP Route Reflector来完成大规模集群的分级路由分发
 - calicoctl：Calico命令行管理工具

部署Calico服务

（1）修改k8s启动参数，并重启服务

 - 设置master上kube-apiserver服务的启动参数：--allow-privilege=true(因为calico-node需要以特权模式运行在各node上)
 - 设置各node上kubelet服务的启动参数：--network-plugin=cni(使用CNI网络插件)

（2）创建Calico服务，主要包括calico-node和calico policy controller，需要创建的资源对象如下：

 - 创建ConfigMap calico-config，包括Calico所需的配置参数
 - 创建Secret calico-etcd-secrets，用于使用TLS方式连接etcd
 - 在每个Node上运行calico/node容器，部署位DaemonSet
 - 在每个Node上安装Calico CNI二进制文件和网络配置参数(由install-cni容器完成)
 - 部署一个名为calico/kube-policy-controller的Deployment，以对接k8s集群中为pod设置的Network Policy