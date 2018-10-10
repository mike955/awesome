#!/bin/sh

ROOT=$(cd `dirname $0`/../&&pwd)
S_NAME=
M_NAME=
while getopts "s:m:" arg
do
    case $arg in
        s)
            S_NAME=$OPTARG;;
        m)
            M_NAME=$OPTARG;;
        ?) 
            echo "unkonw argument"
            exit 1
            ;;
    esac
done

replace_service_variables(){    
    # Use alternative command character "~", since these maybe include a "/".
    sed -i s~__G_HOST_IP__~${G_HOST_IP:-}~g $TMP_SERVICE_FILE
    sed -i s~__G_HOSTNAME__~${G_HOSTNAME:-}~g $TMP_SERVICE_FILE
    sed -i s~__G_ETCD__~${G_ETCD:-}~g $TMP_SERVICE_FILE
    sed -i s~__G_DOCKER_REGISTRY__~${G_DOCKER_REGISTRY:-}~g $TMP_SERVICE_FILE
    sed -i s~__G_CONSUL__~${G_CONSUL:-}~g $TMP_SERVICE_FILE
    sed -i s~__G_MASTER_IP__~${G_MASTER_IP:-}~g $TMP_SERVICE_FILE
    sed -i s~__BOOTSTRAP_TOKEN__~${BOOTSTRAP_TOKEN:-}~g $TMP_SERVICE_FILE
    sed -i s~__SERVICE_CIDR__~${SERVICE_CIDR:-}~g $TMP_SERVICE_FILE
    sed -i s~__CLUSTER_CIDR__~${CLUSTER_CIDR:-}~g $TMP_SERVICE_FILE
    sed -i s~__NODE_PORT_RANGE__~${NODE_PORT_RANGE:-}~g $TMP_SERVICE_FILE
    sed -i s~__CLUSTER_KUBERNETES_SVC_IP__~${CLUSTER_KUBERNETES_SVC_IP:-}~g $TMP_SERVICE_FILE
    sed -i s~__CLUSTER_DNS_SVC_IP__~${CLUSTER_DNS_SVC_IP:-}~g $TMP_SERVICE_FILE
    sed -i s~__CLUSTER_DNS_DOMAIN__~${CLUSTER_DNS_DOMAIN:-}~g $TMP_SERVICE_FILE
    sed -i s~__ETCD_ENDPOINTS__~${ETCD_ENDPOINTS:-}~g $TMP_SERVICE_FILE
    sed -i s~__ETCD_NODE_NAME__~${ETCD_NODE_NAME:-}~g $TMP_SERVICE_FILE
    sed -i s~__ETCD_NODE_IP__~${ETCD_NODE_IP:-}~g $TMP_SERVICE_FILE
    sed -i s~__ETCD_NODE_IPS__~${ETCD_NODE_IPS:-}~g $TMP_SERVICE_FILE
    sed -i s~__ETCD_NODES__~${ETCD_NODES:-}~g $TMP_SERVICE_FILE
    sed -i s~__KUBE_APISERVER__~${KUBE_APISERVER:-}~g $TMP_SERVICE_FILE
}

replace_manifest_variables(){
    sed -i s~__G_HOST_IP__~${G_HOST_IP:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_HOSTNAME__~${G_HOSTNAME:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_ETCD__~${G_ETCD:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_DOCKER_REGISTRY__~${G_DOCKER_REGISTRY:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_CONSUL__~${G_CONSUL:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_MASTER_IP__~${G_MASTER_IP:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_BOOTSTRAP_TOKEN__~${BOOTSTRAP_TOKEN:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_SERVICE_CIDR__~${SERVICE_CIDR:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_CLUSTER_CIDR__~${CLUSTER_CIDR:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_NODE_PORT_RANGE__~${NODE_PORT_RANGE:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_CLUSTER_KUBERNETES_SVC_IP__~${CLUSTER_KUBERNETES_SVC_IP:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_CLUSTER_DNS_SVC_IP__~${CLUSTER_DNS_SVC_IP:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_CLUSTER_DNS_DOMAIN__~${CLUSTER_DNS_DOMAIN:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_ETCD_ENDPOINTS__~${ETCD_ENDPOINTS:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_ETCD_NODE_NAME__~${ETCD_NODE_NAME:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_ETCD_NODE_IP__~${ETCD_NODE_IP:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_ETCD_NODE_IPS__~${ETCD_NODE_IPS:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_ETCD_NODES__~${ETCD_NODES:-}~g $MANIFEST_DIR/*.yaml
    sed -i s~__G_KUBE_APISERVER__~${KUBE_APISERVER:-}~g $MANIFEST_DIR/*.yaml
}


if [ "" != "$S_NAME"  ]; then
    TMP_SERVICE_FILE=/tmp/${S_NAME}.service
    cp $ROOT/systemd/${S_NAME}.service ${TMP_SERVICE_FILE}
    replace_service_variables
    mv ${TMP_SERVICE_FILE} /etc/systemd/system/
fi
if [ "" != "$M_NAME"  ]; then
    MANIFEST_DIR=$ROOT/manifests/${M_NAME}/
    if [ -d $MANIFEST_DIR ]; then
        replace_manifest_variables
    fi
fi