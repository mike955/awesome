#!/bin/sh
#modyfy per host
IP=$G_HOST_IP
INITIAL_CLUSTER="etcd-1a=http://$IP:2380"
IMAGE=elcolio/etcd:2.0.10


docker rm -f etcd-1a etcd-1b etcd-1c
rm -rf /opt/etcd-1*
sh docker_pull.sh $IMAGE

CMD="docker run \$ENV -d --restart=always --name \$NAME -v /opt/\$NAME:/data $IMAGE -name \$NAME \
-advertise-client-urls http://\$IP:\$P2379,http://\$IP:\$P4001 \
-initial-advertise-peer-urls http://\$IP:\$P2380 \
-initial-cluster $INITIAL_CLUSTER　\$ARGS"

P2379=2379 && P2380=2380 && P4001=4001 && P7001=7001
NAME="etcd-1a" && ENV="--net host"
#ARGS="-initial-cluster-state new"
ARGS=
eval $CMD
