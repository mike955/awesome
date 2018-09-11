#!/bin/sh
# wget https://dl.k8s.io/v1.10.4/kubernetes-server-linux-amd64.tar.gz
# tar -xzvf kubernetes-server-linux-amd64.tar.gz
# cd kubernetes
# tar -xzvf  kubernetes-src.tar.gz
echo '----------------- start install ha ------------------'

ROOT=$(cd `dirname $0`/../&&pwd)

# 将二进制文件拷贝到所有 master 节点
source /opt/k8s/bin/environment.sh
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    scp $ROOT/files/kubernetes/server/bin/* k8s@${node_ip}:/opt/k8s/bin/
    # scp /root/k8s_install/files/kubernetes/server/bin/* k8s@${node_ip}:/opt/k8s/bin/
    ssh k8s@${node_ip} "chmod +x /opt/k8s/bin/*"
  done

# 部署高可用组件
# 安装软件包
source /opt/k8s/bin/environment.sh
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "yum install -y keepalived haproxy net-tools"
  done

# 修改 server ip为机器ip
cat > haproxy.cfg <<EOF
global
    log /dev/log    local0
    log /dev/log    local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin
    stats timeout 30s
    user haproxy
    group haproxy
    daemon
    nbproc 1

defaults
    log     global
    timeout connect 5000
    timeout client  10m
    timeout server  10m

listen  admin_stats
    bind 0.0.0.0:10080
    mode http
    log 127.0.0.1 local0 err
    stats refresh 30s
    stats uri /status
    stats realm welcome login\ Haproxy
    stats auth admin:123456
    stats hide-version
    stats admin if TRUE

listen kube-master
    bind 0.0.0.0:8443
    mode tcp
    option tcplog
    balance source
    server ${NODE_1_IP} ${NODE_1_IP}:6443 check inter 2000 fall 2 rise 2 weight 1
    server ${NODE_2_IP} ${NODE_2_IP}:6443 check inter 2000 fall 2 rise 2 weight 1
    server ${NODE_3_IP} ${NODE_3_IP}:6443 check inter 2000 fall 2 rise 2 weight 1
EOF


# 下发 haproxy.cfg 到所有 master 节点
source /opt/k8s/bin/environment.sh
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    scp haproxy.cfg root@${node_ip}:/etc/haproxy
  done

# 起 haproxy 服务
source /opt/k8s/bin/environment.sh
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    # ssh root@${node_ip} "setsebool -P haproxy_connect_any=1"
    ssh root@${node_ip} "systemctl restart haproxy"
  done

# 检查 haproxy 服务状态
source /opt/k8s/bin/environment.sh
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "systemctl status haproxy|grep Active"
  done

# 检查 haproxy 是否监听 8443 端口：
source /opt/k8s/bin/environment.sh
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "netstat -lnpt|grep haproxy"
  done

# 配置和下发 keepalived 配置文件
source /opt/k8s/bin/environment.sh
cat  > keepalived-master.conf <<EOF
global_defs {
    router_id lb-master-105
}

vrrp_script check-haproxy {
    script "killall -0 haproxy"
    interval 5
    weight -30
}

vrrp_instance VI-kube-master {
    state MASTER
    priority 120
    dont_track_primary
    interface ${VIP_IF}
    virtual_router_id 68
    advert_int 3
    track_script {
        check-haproxy
    }
    virtual_ipaddress {
        ${MASTER_VIP}
    }
}
EOF

source /opt/k8s/bin/environment.sh
cat  > keepalived-backup.conf <<EOF
global_defs {
    router_id lb-backup-105
}

vrrp_script check-haproxy {
    script "killall -0 haproxy"
    interval 5
    weight -30
}

vrrp_instance VI-kube-master {
    state BACKUP
    priority 110
    dont_track_primary
    interface ${VIP_IF}
    virtual_router_id 68
    advert_int 3
    track_script {
        check-haproxy
    }
    virtual_ipaddress {
        ${MASTER_VIP}
    }
}
EOF

# 下面需要修改 ip
# 修改ip， master为k8s master节点， backup为 node 节点IP
scp keepalived-master.conf root@${NODE_1_IP}:/etc/keepalived/keepalived.conf
scp keepalived-backup.conf root@${NODE_2_IP}:/etc/keepalived/keepalived.conf
scp keepalived-backup.conf root@${NODE_3_IP}:/etc/keepalived/keepalived.conf

# 起 keepalived 服务
source /opt/k8s/bin/environment.sh
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "systemctl restart keepalived"
  done

# 检查 keepalived 服务
source /opt/k8s/bin/environment.sh
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "systemctl status keepalived|grep Active"
  done

# 查看 VIP 所在的节点，确保可以 ping 通 VIP
source /opt/k8s/bin/environment.sh
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh ${node_ip} "/usr/sbin/ip addr show ${VIP_IF}"
    ssh ${node_ip} "ping -c 1 ${MASTER_VIP}"
  done
