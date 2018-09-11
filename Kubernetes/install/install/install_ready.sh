#!/bin/bash

echo '------------------start install ready work------------'

ROOT=$(cd `dirname $0`/../&&pwd)

source $ROOT/install/environment.sh
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "useradd -m k8s"
    ssh root@${node_ip} "sh -c 'echo 123456 | passwd k8s --stdin'"
    ssh root@${node_ip} "sed -i 's/^# \%wheel/\%wheel/' /etc/sudoers"
    # mkdir directory
    ssh root@${node_ip} "mkdir -p /opt/k8s/bin"
    ssh root@${node_ip} "chown -R k8s /opt/k8s"
    ssh root@${node_ip} "mkdir -p /etc/kubernetes/cert"
    ssh root@${node_ip} "chown -R k8s /etc/kubernetes"
    ssh root@${node_ip} "mkdir -p /etc/etcd/cert"
    ssh root@${node_ip} "chown -R k8s /etc/etcd/cert"
    ssh root@${node_ip} "mkdir -p /var/lib/etcd && chown -R k8s /etc/etcd/cert"
    ssh root@${node_ip} "mkdir -p /run/haproxy/"
  
    # 无密码登陆其他节点
    ssh-copy-id k8s@${node_ip}
    scp $ROOT/install/environment.sh k8s@${node_ip}:/opt/k8s/bin/
    ssh k8s@${node_ip} "chmod +x /opt/k8s/bin/*"
  done

source /opt/k8s/bin/environment.sh
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "useradd -m docker"
    ssh root@${node_ip} "gpasswd -a k8s docker"
    ssh root@${node_ip} "mkdir -p  /etc/docker/"
    ssh root@${node_ip} "setenforce 0"
    ssh root@${node_ip} "sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config"
    ssh root@${node_ip} "echo 'PATH=/opt/k8s/bin:$PATH:$HOME/bin:$JAVA_HOME/bin' >>~/.bashrc"

    # stop wap
    ssh root@${node_ip} "sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab"

    # stop dnsmasq
    ssh root@${node_ip} "service dnsmasq stop"
    ssh root@${node_ip} "systemctl disable dnsmasq"

    # install dependency
    ssh root@${node_ip} "yum install -y epel-release"
    ssh root@${node_ip} "yum install -y conntrack ipvsadm ipset jq sysstat curl iptables libseccomp"
    ssh root@${node_ip} "yum -y install net-tools"
  done

# 加载内核模块
modprobe br_netfilter
modprobe ip_vs

source /opt/k8s/bin/environment.sh
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "cat > kubernetes.conf <<EOF
        net.bridge.bridge-nf-call-iptables=1
        net.bridge.bridge-nf-call-ip6tables=1
        net.ipv4.ip_forward=1
        vm.swappiness=0
        vm.overcommit_memory=1
        vm.panic_on_oom=0
        fs.inotify.max_user_watches=89100
        EOF"
    ssh root@${node_ip} "cp kubernetes.conf  /etc/sysctl.d/kubernetes.conf"
    ssh root@${node_ip} "sysctl -p /etc/sysctl.d/kubernetes.conf"
    ssh root@${node_ip} "mount -t cgroup -o cpu,cpuacct none /sys/fs/cgroup/cpu,cpuacct"
  done

# set timezone
timedatectl set-timezone Asia/Shanghai

# 将当前的 UTC 时间写入硬件时钟
timedatectl set-local-rtc 0

# 重启依赖于系统时间的服务
systemctl restart rsyslog 
systemctl restart crond