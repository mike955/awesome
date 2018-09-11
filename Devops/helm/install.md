# helm 介绍

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
helm init --stable-repo-url https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts/ --service-account helm
helm repo add incubator https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts-incubator/
helm repo update
```