# kubeadm 安装

三台机器:

centos:7.6

k8s01: 192.168.10.102
k8s02: 192.168.10.103
k8s03: 192.168.10.104

1.安装前准备
在三台机器上执行一下命令
```sh
hostnamectl set-hostname k8s01
systemctl stop firewalld && systemctl disable firewalld
swapoff -a


hostnamectl set-hostname k8s02_203
systemctl stop firewalld && systemctl disable firewalld
swapoff -a


hostnamectl set-hostname k8s03_204
systemctl stop firewalld && systemctl disable firewalld
swapoff -a
```

3.修改host 文件
在每台机器的 /etc/hosts 文件后添加如下内容
```sh
192.168.27.202 k8s01_202
192.168.27.203 k8s01_203
192.168.27.204 k8s01_204
```

2.安装docker
在每台机器上执行下面命令
```sh
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

sudo yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

sudo yum install -y docker-ce   # 18.09.3
sudo systemctl start docker
sudo systemctl enable docker

curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://027f9e95.m.daocloud.io
sudo systemctl restart docker
```

3.设置 docker 相关参数
在每台机器上执行相关参数
```sh
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```

4.安装 kubeadm
在 k8s01 上执行下面的命令
```sh
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

systemctl start kubelet
systemctl enable kubelet && systemctl restart kubelet
```

5.初始化集群

master 上执行下面的命令
```sh
kubeadm config images list --kubernetes-version=v1.13.4 # 列出所需镜像

# 开始初始化集群
kubeadm init \
  --kubernetes-version=v1.14.0 \
  --pod-network-cidr=10.244.0.0/16 \
  --apiserver-advertise-address=192.168.114.112   #   修改为机器 ip
```

6.赋予 root 用户 kubectl 权限
```sh
export KUBECONFIG=/etc/kubernetes/admin.conf
```

7.记录token
```sh
kubeadm join 192.168.27.202:6443 --token difo4e.0d0tt24tcbv105m1 --discovery-token-ca-cert-hash sha256:3baa0c3a16f36034b560f0ff0c1abf0562c7312a09efaa089e425bdf929d7c85
```


8.安装 network
```sh
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml
```

9.安装 dashboard
执行当前目录下的 dashboard.yaml 文件
```sh
kubectl create -f  dashboard.yaml
```
执行下面的命令获取 token

```sh
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep dashboard-admin | awk '{print $1}')
```
```txt
eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkYXNoYm9hcmQtYWRtaW4tdG9rZW4tbGo5emoiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGFzaGJvYXJkLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiNzFkZDk1YWYtNDNlMy0xMWU5LTkzNWItMDgwMDI3ZGU2YTI2Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmRhc2hib2FyZC1hZG1pbiJ9.SanFZ0MU-11PPhcksd0f-q485KTLo6vx3wdOXYbeaYSgFjf2ncz1hLAALUKNiv0xlx_nr7H0M0ZoWespLDxxyyDwveZLgG7BYuX2AwAXUWm1cZsOlOo_QPCZehP6_f9luzj84691nu7wHoTC7_ICnehHirQAKUvBo5Ps_KwBsXD1-okTPv8GcYvp5KFiXLQszkeB6-lBAYC-4xTSDzz4T35Uffn7Jagr1_tq6oyQSBe2vA5TSOfS-pLemObNtT-X0tSa-gHGayuyGAVTcneusz3FqBvv3O4Iu0K0zy4t12xe-FU9XVN9fedshGDUzEX0CLa1k9pxi_hXn04PV3WzsA
```

注：如果 pod 起不来，一直报`0/1 nodes are available: 1 node(s) had taints that the pod didn't tolerate.`,是因为 master 默认是不允许调度 pod 的，需要修改设置
```sh
kubectl taint nodes --all node-role.kubernetes.io/master-
```

10.安装 metrics-server

https://cloud.tencent.com/developer/article/1380902


# 安装istio
```sh
wget https://github.com/istio/istio/releases/download/1.0.6/istio-1.0.6-linux.tar.gz
tar zxvf istio-1.0.6-linux.tar.gz
cd istio-1.0.6
```
