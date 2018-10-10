#!/bin/sh

ROOT=$(cd `dirname $0`/../&&pwd)
BIN_DIR=/usr/local/bin

# create systemed unit of etcd
mkdir -p /var/lib/etcd  # 必须先创建工作目录
# create etcd-csr
cat > etcd-csr.json <<EOF
{
  "CN": "etcd",
  "hosts": [
    "127.0.0.1",
    "${NODE_1_IP}",
    "${NODE_2_IP}",
    "${NODE_3_IP}"
  ],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "Zhejiang",
      "L": "Hangzhou",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF

# generate cert and private key of etcd
/usr/local/bin/cfssl gencert -ca=/etc/kubernetes/cert/ca.pem \
  -ca-key=/etc/kubernetes/cert/ca-key.pem \
  -config=/etc/kubernetes/cert/ca-config.json \
  -profile=kubernetes $ROOT/cert/etcd-csr.json | /usr/local/bin/cfssljson -bare etcd

mkdir -p /etc/etcd/cert
cp $ROOT/cert/etcd*.pem /etc/etcd/cert
rm -f $ROOT/cert/etcd.csr  $ROOT/cert/etcd-csr.json

# 创建 etcd 的 systemd unit 文件
cp $ROOT/systemed/etcd.service /etc/systemd/system/etcd.service

# launch etcd service
systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
systemctl status etcd | grep Active
