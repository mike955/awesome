#!/bin/sh

ROOT=$(cd `dirname $0`/../&&pwd)
BIN_DIR=/usr/local/bin

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo $ROOT/docker-ce.repo
yum makecache fast
yum install -y docker-ce-18.03.1.ce-1.el7.centos.x86_64

#docker 从 1.13 版本开始，可能将 iptables FORWARD chain的默认策略设置为DROP，
#从而导致 ping 其它 Node 上的 Pod IP 失败，遇到这种情况时，需要手动设置策略为 ACCEPT
cp $ROOT/systemd/docker.service /etc/systemd/system/docker.service
systemctl daemon-reload
systemctl stop firewalld
systemctl disable firewalld
systemctl enable docker
systemctl start docker

iptables -P FORWARD ACCEPT
echo "sleep 120 && /sbin/iptables -P FORWARD ACCEPT" >> /etc/rc.local
iptables -F && sudo iptables -X && sudo iptables -F -t nat && sudo iptables -X -t nat
