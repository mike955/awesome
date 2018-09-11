#!/bin/bash
echo '----------------- start install -----------------'

ROOT=$(cd `dirname $0`; pwd)
# install ready
sh $ROOT/install/install_ready.sh

# install CA
sh $ROOT/install/install_ca.sh

# install kubectlls
sh $ROOT/install/install_kubectl.sh

# install etcd
sh $ROOT/install/install_etcd.sh

# install flannel
sh $ROOT/install/install_flannel.sh

# install ha
sh $ROOT/install/install_ha.sh

# install api-server
sh $ROOT/install/install_api-server.sh

# install controller-manager
sh $ROOT/install/install_controller-manager.sh

# install scheduler
sh $ROOT/install/install_scheduler.sh

# install node
sh $ROOT/install/install_node.sh

# install docker
sh $ROOT/install/install_docker.sh

# install kubelet
sh $ROOT/install/install_kubelet.sh

# install kube-proxy
sh $ROOT/install/install_kube-proxy.sh