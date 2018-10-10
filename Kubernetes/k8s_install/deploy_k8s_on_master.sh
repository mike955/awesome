#!/bin/sh

set -e

ROOT=$(cd `dirname $0`&&pwd)

pushd $ROOT/install/

# install ready
sh install_ready.sh

# clear docker
sh clear_docker.sh

# install docker and start consul on master
sh install_docker.sh

# pull needed images on worker nodes
# sh pull_images_on_node.sh

# create CA certificates
sh ca.sh

# install kubectl
sh install_kubectl.sh

# install etcd
sh install_etcd.sh

# install flannel
sh install_flannel.sh


# install master kubernetes components
# kubernetes master 节点包含的组件：
#         kube-apiserver
#         kube-scheduler
#         kube-controller-manager

sh install_kube-apiserver.sh
sh install_kube-scheduler.sh
sh install_kube-controller-manager.sh

# # install kubernetes Node components
# # kubernetes Node 节点包含如下组件：
# #         kubelet
# #         kube-proxy
sh install_kubelet.sh
sh install_kube-proxy.sh

# create calico
sh create_calico.sh

# create labels for k8s nodes
kubectl label node $G_MASTER_IP consul=server schedulable=true

popd

mkdir -p $ROOT/root/etc/profile.d/
cp /etc/profile.d/environment.sh $ROOT/root/etc/profile.d/

pushd $ROOT/root
tar cvf - /opt/k8s-install --exclude /opt/k8s-install/root | tar xvf -
popd

pushd $ROOT/root/opt/k8s-install/ssl
rm etcd* kubernetes* admin*
popd

mkdir -p $ROOT/root/usr/local/bin
cp /usr/local/bin/{calicoctl,cfssljson,etcdctl,kube-proxy,kubelet,cfssl,consul-template,kube-apiserver,kube-scheduler,mk-docker-opts.sh,cfssl-certinfo,etcd,kube-controller-manager,kubectl} $ROOT/root/usr/local/bin
