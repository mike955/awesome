## kubectl 常用命令介绍

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [kubectl 常用命令介绍](#kubectl常用命令介绍)
  - [1.创建资源对象](#1创建资源对象)
  - [2.查看资源对象](#2查看资源对象)
  - [3.描述资源对象](#3描述资源对象)
  - [4.删除资源对象](#4删除资源对象)
  - [5.执行容器命令](#5执行容器命令)
  - [6.查看容器日志](#6查看容器日志)
  - [7.查看 pod 启动日志](#7查看pod启动日志)

<!-- /code_chunk_output -->

---

#### 1.创建资源对象

```shell
kubectl create -f myservice.yaml
```

#### 2.查看资源对象

```shell
kubectl get po      #查看pod
kubectl get rc      #查看副本
kubectl get deployment  #查看部署
kubectl get svc        #查看服务
```

#### 3.描述资源对象

```shell
kubectl describe nodes <node-name>
kubectl describe pods/<pod-name>
kubectl describe svc <svc-name>
```

#### 4.删除资源对象

```shell
kubectl delete -f pod.yaml
kubectl delete pods,services -l name=<label-name>   #删除包含某个label的pod和service
kubectl delete pods -all        #删除所有pod
```

#### 5.执行容器命令

```shell
kubectl exec <pod-name> data  #执行pod的data命令，默认使用pod中的第一个容器执行

kubectl exec <pod-name> -c <container-name> date    #指定pod中某个容器执行data命令

kubectl exec -it <pod-name> -c <container-name> /bin/bash #登陆pod的某个容器

kubectl exec -it <pod-name> /bin/bash   #登陆某个pod
```

#### 6.查看容器日志

```shell
kubectl logs <pod-name>     #查看容器输出到stdout日志
kubectl logs -f <pod-name> -C <container-name>  #跟踪查看容器日志
```

#### 7.查看 pod 启动日志

```sh
kubectl logs cadvisor-5dbdb7bbc-765c4 -n kube-system
```
