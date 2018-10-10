#!/usr/bin/bash

# 生成 EncryptionConfig 所需的加密 key
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

# 三台机器信息
export NODE_1_IP=192.168.17.123
export NODE_2_IP=192.168.17.124
export NODE_3_IP=192.168.17.125

export NODE_1_NAME=kube-node1
export NODE_2_NAME=kube-node2
export NODE_3_NAME=kube-node3

# master机器
export MASTER_IP=${NODE_1_IP}

# 当前机器信息
export NODE_IP=${NODE_1_IP}
export NODE_NAME=${NODE_1_NAME}

# etcd 地址
export ETCD_NODE_NAME=${NODE_NAME} # 当前部署的机器名称(随便定义，只要能区分不同机器即可)，因为是单节点，所以只需要修改一次
export ETCD_NODE_IP=${NODE_IP} # 当前部署的机器 IP，因为是单节点只需修改为master节点IP即可
# etcd 集群服务地址列表，地址修改为三台机器接口
export ETCD_ENDPOINTS="https://${NODE_1_IP}:2379,https://${NODE_2_IP}:2379,https://${NODE_3_IP}:2379"
# etcd 集群间通信的 IP 和端口，修改为三台机器接口
export ETCD_NODES="${NODE_1_NAME}=https://${NODE_1_IP}:2380,${NODE_2_NAME}=https://${NODE_2_IP}:2380,${NODE_3_NAME}=https://${NODE_3_IP}:2380"

# 服务网段，部署前路由不可达，部署后集群内路由可达(kube-proxy 和 ipvs 保证)
SERVICE_CIDR="10.254.0.0/16"

# Pod 网段，建议 /16 段地址，部署前路由不可达，部署后集群内路由可达(flanneld 保证)
CLUSTER_CIDR="172.30.0.0/16"

# 服务端口范围 (NodePort Range)
export NODE_PORT_RANGE="8400-9000"

# HA 节点，配置 VIP 的网络接口名称，视具体网卡而修改
export VIP_IF="enp0s3"


# flanneld 网络配置前缀
export FLANNEL_ETCD_PREFIX="/kubernetes/network"

# kubernetes 服务 IP (一般是 SERVICE_CIDR 中第一个IP)
export CLUSTER_KUBERNETES_SVC_IP="10.254.0.1"

# 集群 DNS 服务 IP (从 SERVICE_CIDR 中预分配)
export CLUSTER_DNS_SVC_IP="10.254.0.2"

# 集群 DNS 域名
export CLUSTER_DNS_DOMAIN="cluster.local."