#!/bin/sh

IP=$G_DOCKER_REGISTRY

IMAGE=`docker images |awk -F ' ' '{print $1":"$2}' |grep $1`
if [ "$IMAGE" = "$1" ];then
    echo "$1 exist"
    exit
fi

docker pull $IP/$1
docker tag $IP/$1 $1
docker rmi $IP/$1
