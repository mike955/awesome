#!/bin/sh

# 停相关进程：

DOCKER_STATUS=$(rpm -qa | grep docker)

if [ "$DOCKER_STATUS" != ""  ]; then
    docker stop `docker ps -aq`
    docker rm `docker ps -aq`
    docker rmi `docker images -q`

    systemctl stop docker

    yum remove docker-ce
    yum remove docker \
            docker-client \
            docker-client-latest \
            docker-common \
            docker-latest \
            docker-latest-logrotate \
            docker-logrotate \
            docker-selinux \
            docker-engine-selinux \
            docker-engine

    # 删除 docker 工作目录
    rm -rf /var/lib/docker

    # 删除 docker 的一些运行文件
    rm -rf /var/run/docker/

    # 删除 systemd unit 文件
    rm -rf /etc/systemd/system/docker.service*

    # 删除docker 创建的网桥
    ip link del docker0
fi