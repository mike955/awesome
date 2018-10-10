#!/bin/sh

echo '----------------- start install flannel -----------------'
ROOT=$(cd `dirname $0`/../&&pwd)

cat > flanneld-csr.json <<EOF
{
  "CN": "flanneld",
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

/usr/local/bin/cfssl gencert -ca=/etc/kubernetes/cert/ca.pem \
  -ca-key=/etc/kubernetes/cert/ca-key.pem \
  -config=/etc/kubernetes/cert/ca-config.json \
  -profile=kubernetes flanneld-csr.json | /usr/local/bin/cfcertjson -bare flanneld

cp flannel*.pem /etc/kubernetes/cert/
rm -f flannel.csr flannel-csr.json

# 向 etcd 写入集群 Pod 网段信息
etcdctl \
  --endpoints=${ETCD_ENDPOINTS} \
  --ca-file=/etc/kubernetes/cert/ca.pem \
  --cert-file=/etc/flanneld/cert/flanneld.pem \
  --key-file=/etc/flanneld/cert/flanneld-key.pem \
  set ${FLANNEL_ETCD_PREFIX}/config '{"Network":"'${CLUSTER_CIDR}'", "SubnetLen": 24, "Backend": {"Type": "vxlan"}}'