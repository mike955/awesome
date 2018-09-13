# Scheduler

Scheduler 主要负责 Pod 的调度。将 Controller Manager 创建的待调度的 Pod 按照特定的调度算法和调度策略绑定到集群中某个合适的 Node 上，并将绑定信息写如 etcd中。Node 节点上的 Kubelet 通过 API Server 监听到 Scheduler 产生的 Pod 绑定事件，然后获取响应的 Pod 清单，下载镜像，启动容器，并接管 Pod 的后续管理工作。

## systemd unit 示例文件
```sh
cat > kube-scheduler.service <<EOF
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/GoogleCloudPlatform/kubernetes

[Service]
ExecStart=/opt/k8s/bin/kube-scheduler \\
  --address=127.0.0.1 \\
  --kubeconfig=/etc/kubernetes/kube-scheduler.kubeconfig \\
  --leader-elect=true \\
  --alsologtostderr=true \\
  --logtostderr=false \\
  --log-dir=/var/log/kubernetes \\
  --v=2
Restart=on-failure
RestartSec=5
User=k8s

[Install]
WantedBy=multi-user.target
EOF
```