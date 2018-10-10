#!/bin/sh
echo '----------------- start install -----------------'

set -e

ROOT=$(cd `dirname $0`; pwd)
# modify hostname
if [ "$G_HOSTNAME" != "" ]; then
    hostnamectl set-hostname $NODE_NAME
    hostnamectl --transient set-hostname $NODE_NAME
fi

# stop firewall
systemctl stop firewalld
systemctl disable firewalld

# stop selinux
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# stop swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# stop dnsmasq
service dnsmasq stop
systemctl disable dnsmasq

# load linux core module
modprobe br_netfilter
modprobe ip_vs

# set system variables
cat > kubernetes.conf <<EOF
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
net.ipv4.ip_forward=1
vm.swappiness=0
vm.overcommit_memory=1
vm.panic_on_oom=0
fs.inotify.max_user_watches=89100
EOF

cp kubernetes.conf  /etc/sysctl.d/kubernetes.conf
sysctl -p /etc/sysctl.d/kubernetes.conf
mount -t cgroup -o cpu,cpuacct none /sys/fs/cgroup/cpu,cpuacct

# set timezone
timedatectl set-timezone Asia/Shanghai

# 将当前的 UTC 时间写入硬件时钟
timedatectl set-local-rtc 0

# 重启依赖于系统时间的服务
systemctl restart rsyslog 
systemctl restart crond

# install dependency 
yum install -y epel-release \
            conntrack \
            ipvsadm \
            ipset \
            jq \
            sysstat \
            curl \
            iptables \
            libseccomp

mkdir -p /opt/bin
cp $ROOT/environment.sh /opt/bin/

chmod +x $ROOT/bin/*
cp $ROOT/bin/* /usr/local/bin/