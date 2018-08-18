# k8s基本概念和术语


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [k8s基本概念和术语](#k8s%E5%9F%BA%E6%9C%AC%E6%A6%82%E5%BF%B5%E5%92%8C%E6%9C%AF%E8%AF%AD)
  - [1.master](#1master)
  - [2.Node](#2node)
  - [3.Pod](#3pod)
  - [4.Label](#4label)
  - [5.Replication Controller](#5replication-controller)
  - [6.Deployment](#6deployment)
  - [7.Horizontal Pod Autoscaler](#7horizontal-pod-autoscaler)
  - [8.StatefulSet](#8statefulset)
  - [9.Service](#9service)
  - [10.命名空间](#10%E5%91%BD%E5%90%8D%E7%A9%BA%E9%97%B4)

<!-- /code_chunk_output -->

---
## 1.master

master指的是集群控制节点，每个k8s集群需要有一个master节点
 - 作用：
  - 负责集群的管理和控制
 - 节点运行以下进程：
  - kubernetes API Server (kube-apiserver)
  - kubernetes Controller Manager (kube-controller-manager)
  - kubernetes Scheduler (kube-scheduler)  
  - etcd

## 2.Node

Node指的是k8s集群中除master外的所有节点，为pod的运行节点

 - 作用：运行Pod
 - 节点允许以下进程
    - kubelet
    - kube-proxy
    - docker-engine

## 3.Pod

Pod是k8s管理的最小单位

 - 包含的容器
    - Pause：pod内所有容器共享pause容器ip
    - 其它应用容器  
 - 种类：
    - 普通Pod
    - 静态Pod：不存储在etcd中，存放在具体的Node上的一个文件中 
 - Endpoint:
    - Endpoint=PodIP(pauseIP):ContainerIP    
 - 创建脚本
 ```yaml
 apiVersion: v1
 kind: Pod
 metadata:
  name: myweb   #pod的名字
  labels:       #pod标签
   name: myweb  
 spec:          #pod包含的容器组，可以有多个
  containers:   #可以在里面对容易所能使用的资源(cpu等)进行配置
   - name: myweb    #容器名称
     images: kubeguide/tomcat-app:v1    #容器镜像
     ports: 
      - containerPort: 8080     ##容器端口号
     env:       #容器环境变量
     - name: MYSQL_SERVICE_HOST
       value: 'mysql'
     - name: MYSQL_SERVICE_PORT
       value: '3306'
 ```

## 4.Label

 label是一个key=value的键值对，可以用于多种场合

  - 版本标签
    - release:stable
  - 环境标签
    - environment: dev
  - 架构标签
    - environment: frontend
  - 分区标签
    - partition: cunsomerA
  - 质量管控标签  
    - track: daily
  - 使用场景
    - kube-controller通过RC上定义的label selector来筛选pod
    - kube-proxy通过service的label selector来筛选pod
    - 在pod文件中使用NodeSelector来定向调度

## 5.Replication Controller

 pod副本管理器，即让pod的数量符合定义时的预期值

  - 支持基于集合的Label Selector
  - RC定义包含如下几部分
    - pod期待的副本数(replicas)
    - 用于筛选目标的pod的Label Selector
    - 当pod的副本数量小于预期值时，创建新的pod
  - RC模版
  ```yaml
apiVersion: v1
kind: ReplicationController #已更名为ReplicaSet
metadata:
 name: frontend
spec:
 replicas: 1
 selector:
  tier: frontend
 template:
  metadata:
   labels:
    app: app-demo
    tier: frontend
   spec:
    containers:
     - name: tomcat-demo
       image: tomcat
       imagePullPolicy: IfNotPresent
       env:
        - name: GET_HOSTS_FROM
          value: dns
       ports:
        - containerPort: 80
  ```

## 6.Deployment

用来解决Pod的编排问题，是Replica Set的升级

- 使用场景
    - 创建一个Deployment对象来创建pod创建
    - 检查Deployment状态来查看部署状态
    - 更新Deploment以创建新的pod
    - 当前Deploment不稳定，可以回滚到上一个版本
    - 暂停Deploment修改PodTemplatesSpec配置，恢复Deploment，再发布
    - 扩展Deploment以应对高负载
    - 清理不需要的旧版本ReplicaSet
- 支持基于集合的Label Selector
- 创建脚本
```yaml
apiVersion: extension/v1beta1
kind: Deployment
metadata:
 name: frontend
spec:
 replicas: 1
 selector:
  matchLables:
   tier: frontend
   matchExpressions:
    - {key: tier, operator: In, values: [frontend]}
  template:
   metadata:
    labels:
     app: app-demo
     tier: frontend
   spec:
    containers:
     - name: tomcat-demo
       images: tomcat
       imagesPullPolicy: IfNotPresent   #镜像拉取策略
       ports:
       - containerPort: 8080
```

## 7.Horizontal Pod Autoscaler

pod只能扩容，通过追踪分析RC控制的所有目标Pod的负载变化情况，来针对性的调整目标pod的副本数，这是HPA的实现原理

 - pod负载指标
    - CPUUtilizationPercentage
    - 应用程序自定义的度量指标，如(QPS和TPS)
 - 模版
 ```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
 name: php-apache
 namespace: default
spec:
 maxReplicas: 10
 minReplicas: 1
 scaleTargetRef:
  king: Deployment
  name: php-apache
 targetCPUUtilizationPercentage: 90  #cpu使用率超过90%自动扩容
 ```

## 8.StatefulSet

StatefulSet里的每个pod都有稳定唯一的标识

- StatefulSet里的每个pod都有稳定唯一的标识，可以用来发现集群内的其他成员，假如StatefulSet的名字叫kafka，那么第一个pod叫kafka-0，第二个叫kafka-1，以此类推。
- StatefulSet控制的pod副本的启停顺序是受控的，操作第n个pod的时候，前n-1个pod已经是允许且是准备好的状态
- StatefulSet里的pod采用稳定的持久化存储卷，通过PV/PVC来实现，剔除pod时不会删除与StatefulSet相关的存储卷

## 9.Service

Service是一个服务，管理着一组pod，与pod之间通过label selector来进行选择。

 - k8s为每个service分配了一个全局唯一的虚拟IP地址，称为clusterIP
 - 整个service生命周期内，clusterIP不会发生变化
 - 创建一个service
 ```yaml
apiVersion: v1
kind: Service
metadata:
 name: tomcat-service #service的名字
spec:
 type: NodePort
 ports:
  - port: 8080      #service端口号
    nodePort: 31002 #集群外部访问serivice的端口号
 selector:
  tier: frontend    #选取label为“tier=frontend”的pod
 ```
 - 外部系统访问service
    - k8s里的三种ip
        - NodeIP: Node节点的IP
        - PodIP: Pod的IP地址，节点的无力网卡IP地址
        - ClusterIP: Service的IP地址
            - 仅作用于当前service，由k8s管理和分配，是一个虚拟的ip
            - 无法被ping通
            - 无法在集群外部使用这个地址
    - 通过 k8s的service的IP:想要访问service的nodePort

## 10.命名空间

用户隔离资源，将集群内部的资源对象"分配"到不同的Namespace中，不同namespace中的服务不能通信