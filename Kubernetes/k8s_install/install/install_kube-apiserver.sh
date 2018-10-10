#!/bin/sh

ROOT=$(cd `dirname $0`/../&&pwd)
BIN_DIR=/usr/local/bin

# 导入的 environment.sh 文件定义了 BOOTSTRAP_TOKEN 变量
cat > token.csv <<EOF
${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:kubelet-bootstrap"
EOF
mv token.csv /etc/kubernetes/

# 创建 kube-apiserver 的 systemd unit 文件
sh replace_env_variables.sh -s kube-apiserver

#启动 kube-apiserver
systemctl daemon-reload
systemctl enable kube-apiserver
systemctl start kube-apiserver
systemctl status kube-apiserver
