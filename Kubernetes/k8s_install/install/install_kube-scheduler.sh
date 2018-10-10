#!/bin/sh

ROOT=$(cd `dirname $0`/../&&pwd)
BIN_DIR=/usr/local/bin

# 创建 kube-scheduler 的 systemd unit 文件
sh replace_env_variables.sh -s kube-scheduler

# 启动 kube-scheduler
systemctl daemon-reload
systemctl enable kube-scheduler
systemctl start kube-scheduler
