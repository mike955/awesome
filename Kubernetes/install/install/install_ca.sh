#!/bin/bash

echo '----------------- start install CA ----------------------'

ROOT=$(cd `dirname $0`/../&&pwd)

mkdir -p /opt/k8s/cert && sudo chown -R k8s /opt/k8s && cd /opt/k8s
# wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
# wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
# wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64


## 需要设置目录后修改后面 bin 目录：
cp $ROOT/bin/cfssl_linux-amd64 /opt/k8s/bin/cfssl
cp $ROOT/bin/cfssljson_linux-amd64 /opt/k8s/bin/cfssljson
cp $ROOT/bin/cfssl-certinfo_linux-amd64 /opt/k8s/bin/cfssl-certinfo

chmod +x /opt/k8s/bin/*
export PATH=/opt/k8s/bin:$PATH

cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "87600h"
      }
    }
  }
}
EOF

cat > ca-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "k8s",
      "OU": "4Paradigm"
    }
  ]
}
EOF

cfssl gencert -initca ca-csr.json | cfssljson -bare ca
ls ca*

# 将生成的 CA 证书、秘钥文件、配置文件拷贝到**所有节点**的 `/etc/kubernetes/cert` 目录下：
source /opt/k8s/bin/environment.sh # 导入 NODE_IPS 环境变量
for node_ip in ${NODE_IPS[@]}
  do
    echo ">>> ${node_ip}"
    ssh root@${node_ip} "mkdir -p /etc/kubernetes/cert && chown -R k8s /etc/kubernetes"
    scp ca*.pem ca-config.json k8s@${node_ip}:/etc/kubernetes/cert
  done
