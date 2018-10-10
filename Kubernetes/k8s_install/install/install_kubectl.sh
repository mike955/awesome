#!/bin/sh

ROOT=$(cd `dirname $0`/../&&pwd)
BIN_DIR=/usr/local/bin

# consul-template -consul-addr "$G_CONSUL:8500" -template "$ROOT/consul-tpl/kube-config.tpl:$ROOT/config/kube-config" -once
# KUBE_CONFIG_SIZE=$(stat --printf="%s" $ROOT/config/kube-config)

pushd $ROOT/ssl/
# 创建 admin 证书签名请求
cat > admin-csr.json << EOF
{
  "CN": "admin",
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
      "O": "system:masters",
      "OU": "System"
    }
  ]
}
EOF

/usr/local/bin/cfssl gencert -ca=/etc/kubernetes/cert/ca.pem \
  -ca-key=/etc/kubernetes/cert/ca-key.pem \
  -config=/etc/kubernetes/cert/ca-config.json \
  -profile=kubernetes admin-csr.json | /usr/local/bin/cfcertjson -bare admin
cp admin*.pem /etc/kubernetes/cert/
rm -f admin.csr admin-csr.json

if [ ! -f $ROOT/config/kube-config ]; then
    # 设置集群参数
    kubectl config set-cluster kubernetes \
    --certificate-authority=/etc/kubernetes/ssl/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER}
    # 设置客户端认证参数
    kubectl config set-credentials admin \
    --client-certificate=/etc/kubernetes/ssl/admin.pem \
    --embed-certs=true \
    --client-key=/etc/kubernetes/ssl/admin-key.pem
    # 设置上下文参数
    kubectl config set-context kubernetes \
    --cluster=kubernetes \
    --user=admin
    # 设置默认上下文
    kubectl config use-context kubernetes
    # eval `curl --request PUT --data-binary @/root/.kube/config http://$G_CONSUL:8500/v1/kv/k8s/config/kube-config;`
    cp /root/.kube/config $ROOT/config/kube-config
else
    mkdir -p /root/.kube/
    cp $ROOT/config/kube-config /root/.kube/config
fi

popd