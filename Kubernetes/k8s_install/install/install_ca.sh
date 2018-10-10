#!/bin/sh

ROOT=$(cd `dirname $0`/../&&pwd)

pushd $ROOT/ssl/
# 生成 CA 证书和私钥：
cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "8760h"
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
      "ST": "Zhejiang",
      "L": "Hangzhou",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF
/usr/local/bin/cfssl gencert -initca ca-csr.json | /usr/local/bin/cfssljson -bare ca
rm -f ca-csr.json ca.csr
# copy ssl certificates
mkdir -p /etc/kubernetes/cert
cp ca* /etc/kubernetes/cert

# generate kubernetes csr
cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "hosts": [
    "127.0.0.1",
    "${G_MASTER_IP}",
    "${CLUSTER_KUBERNETES_SVC_IP}",
    "kubernetes",
    "kubernetes.default",
    "kubernetes.default.svc",
    "kubernetes.default.svc.cluster",
    "kubernetes.default.svc.cluster.local"
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

# create kubernetes cert
/usr/local/bin/cfssl gencert -ca=/etc/kubernetes/cert/ca.pem \
  -ca-key=/etc/kubernetes/cert/ca-key.pem \
  -config=/etc/kubernetes/cert/ca-config.json \
  -profile=kubernetes kubernetes-csr.json | /usr/local/bin/cfcertjson -bare kubernetes
# rm kubernetes-csr.json kubernetes.csr

cp kubernetes*.pem /etc/kubernetes/cert/
rm -f kubernetes.csr  kubernetes-csr.json

# generate kube-proxy csr
cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "hosts": [],
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
# generate kube-proxy cert
/usr/local/bin/cfssl gencert -ca=/etc/kubernetes/ssl/ca.pem \
  -ca-key=/etc/kubernetes/ssl/ca-key.pem \
  -config=/etc/kubernetes/ssl/ca-config.json \
  -profile=kubernetes  kube-proxy-csr.json | /usr/local/bin/cfssljson -bare kube-proxy
cp kube-proxy*.pem /etc/kubernetes/ssl/
rm -f kube-proxy.csr  kube-proxy-csr.json

# create cert and key of etcd
cat > etcd-csr.json <<EOF
{
  "CN": "etcd",
  "hosts": [
    "127.0.0.1",
    "${ETCD_NODE_IP}"
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
/usr/local/bin/cfssl gencert -ca=/etc/kubernetes/ssl/ca.pem \
  -ca-key=/etc/kubernetes/ssl/ca-key.pem \
  -config=/etc/kubernetes/ssl/ca-config.json \
  -profile=kubernetes $ROOT/ssl/etcd-csr.json | /usr/local/bin/cfssljson -bare etcd

mkdir -p /etc/etcd/ssl
cp $ROOT/ssl/etcd*.pem /etc/etcd/ssl
rm -f $ROOT/ssl/etcd.csr  $ROOT/ssl/etcd-csr.json

popd

# SSL=$ROOT/ssl/
# eval `find $SSL -type f | awk '{print "curl --request PUT --data-binary @"$1" http://'$G_CONSUL':8500/v1/kv/k8s/ssl/"substr($1,'$((${#SSL}+1))')";"}'`
