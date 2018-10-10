#!/bin/sh

set -e

ROOT=$(cd `dirname $0`&&pwd)

# stop firewall
systemctl stop firewalld
systemctl disable firewalld

# modify hostname
if [ "$G_HOSTNAME" != "" ]; then
    hostnamectl set-hostname $G_HOSTNAME
    hostnamectl --transient set-hostname $G_HOSTNAME
fi

pushd $ROOT/install/
# clear docker
sh clear_docker.sh

# install docker
sh install_docker.sh

# pull needed images on worker nodes
sh pull_images_on_node.sh

# download certificates
sh download_cert.sh

# install kubectl
sh install_kubectl.sh

# install kubernetes Node components
# kubernetes Node 节点包含如下组件：
#         kubelet
#         kube-proxy
sh install_kubelet.sh
sh install_kube-proxy.sh

# create labels for k8s nodes
kubectl label node $G_HOST_IP consul=agent beta.kubernetes.io/fluentd-ds-ready=true

popd
