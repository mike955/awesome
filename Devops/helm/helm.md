# helm 介绍及基本使用

---
## 介绍
helm 是 kubernetes 的包管理器，用来管理 Kubernetes 应用程序，helm charts 可以定义、安装和升级复杂的 kubernetes 应用程序。

helm 之于 kubernetes就像 apt 之于 ubuntu、yum 之于 centos 和 homebrew 之于 mac OS。

helm 有三个重要概念：

 * chart: 一组创建 Kubernetes 应用程序实例所必要的信息
 * config: 配置信息，在创建 release 时被合并进 chart 中
 * release: 版本是 chart 的一个实例，通常与一个特地的 config 关联

helm 能够做下面一些事情：
 * 创建 chart
 * 打包 charts 成一个文件
 * 同 chart 仓库进行交互
 * 安装或者卸载 chart
 * 管理 chart 版本

## 组成

helm 由两个主要的组件组成:

 * helm client: client 是一个命令行工具，用户使用其与 tiller server 进行交互，负责以下事情:
    * 发送 chart 给 tiller 去安装
    * 获取 release 信息
    * 更新和卸载已经存在的 release
 * tiller server: tiller server 是一个集群内服务器，与 helm client 进行交互，并与 kubernetes 的 API server进行交互，负责以下内容:
    * 监听来自于 helm client 的请求
    * 通过 chart 和 config 打包成一个 release
    * 安装 charts 到 kubernetes，并追踪后续版本
    * 与 kubernetes 交互去更新和卸载 chart

总的来说，client 负责管理 chart，tiller 负责管理 release。

## 安装
```sh
# install client
wget https://kubernetes-helm.storage.googleapis.com/helm-v2.10.0-linux-amd64.tar.gz
tar -zxvf helm-v2.0.0-linux-amd64.tgz
mv linux-amd64/helm /usr/local/bin/helm

# install tiller
# 加载tiller 库
# docker save --output tiller.tar gcr.io/kubernetes-helm/tiller:v2.10.0  #版本需要与 client 版本相同
# docker load --input tiller.tar
yum install socat -y

kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
helm init --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts --service-account helm
helm repo add incubator https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
helm repo update
```

## 使用