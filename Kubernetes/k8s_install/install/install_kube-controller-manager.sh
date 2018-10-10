#!/bin/sh

ROOT=$(cd `dirname $0`/../&&pwd)
BIN_DIR=/usr/local/bin

# 创建 kube-controller-manager 的 systemd unit 文件
sh replace_env_variables.sh -s kube-controller-manager

# 启动 kube-controller-manager
systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl start kube-controller-manager
