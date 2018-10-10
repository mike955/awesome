#!/bin/sh

ROOT=$(cd `dirname $0`/../&&pwd)
BIN_DIR=/usr/local/bin

# kubelet 启动时向 kube-apiserver 发送 TLS bootstrapping 请求，
# 需要先将 bootstrap token 文件中的 kubelet-bootstrap 用户赋予 system:node-bootstrapper 角色，
# 然后 kubelet 才有权限创建认证请求(certificatesigningrequests)
kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --user=kubelet-bootstrap

# 设置集群参数
kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=bootstrap.kubeconfig

# 设置客户端认证参数
kubectl config set-credentials kubelet-bootstrap \
  --token=${BOOTSTRAP_TOKEN} \
  --kubeconfig=bootstrap.kubeconfig

# 设置上下文参数
kubectl config set-context default \
  --cluster=kubernetes \
  --user=kubelet-bootstrap \
  --kubeconfig=bootstrap.kubeconfig
# 设置默认上下文
kubectl config use-context default --kubeconfig=bootstrap.kubeconfig
mv bootstrap.kubeconfig /etc/kubernetes/

mkdir /var/lib/kubelet # 必须先创建工作目录

# 创建 kubelet 的 systemd unit 文件
sh replace_env_variables.sh -s kubelet

# 启动 kubelet
systemctl daemon-reload
systemctl enable kubelet
systemctl start kubelet
systemctl status kubelet

sleep 10
# 通过 kubelet 的 TLS 证书请求
kubectl get csr | grep -e 'csr-.*Pending$' | awk -F' ' '{print $1}' | xargs -I {} kubectl certificate approve {}
