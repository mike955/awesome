# Kube-proxy

在 Kubernetes 中，Service 是对一组 Pod 的抽象，根据访问策略来访问这组 Pod。当时 Service 很多情况下知识一个概念，真正将 Service 的作用落实的是 kube-proxy进程。

每个 Node 上都会运行一个 kube-proxy 服务进程，这个进程可以看作是 Service 的透明代理兼负载均衡器，其核心功能是将某个 Service 的访问请求转发到后端的多个 Pod 实例上。

kube-proxy 在运行过程中动态创建与 Service 相关的 Iptables 规则，访问 Service 的请求都被节点的 Iptables 规则重定向到 kube-proxy 监听 Service 服务代理端口。

## systemd unit 示例文件
```sh
cat > kube-proxy.service <<EOF
[Unit]
Description=Kubernetes Kube-Proxy Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target

[Service]
WorkingDirectory=/var/lib/kube-proxy
ExecStart=/opt/k8s/bin/kube-proxy \\
  --config=/etc/kubernetes/kube-proxy.config.yaml \\
  --alsologtostderr=true \\
  --logtostderr=false \\
  --log-dir=/var/log/kubernetes \\
  --v=2
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
```