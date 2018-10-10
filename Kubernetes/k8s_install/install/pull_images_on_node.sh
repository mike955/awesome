#!/bin/sh

ROOT=$(cd `dirname $0`/../&&pwd)

pushd $ROOT/install

# docker pull images of calico
sh docker_pull.sh quay.io/calico/node:v2.5.1
sh docker_pull.sh quay.io/calico/cni:v1.10.0
sh docker_pull.sh quay.io/calico/kube-policy-controller:v0.7.0

# docker pull images of kube-dns
sh docker_pull.sh gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:v1.14.1
sh docker_pull.sh gcr.io/google_containers/k8s-dns-kube-dns-amd64:v1.14.1
sh docker_pull.sh gcr.io/google_containers/k8s-dns-sidecar-amd64:v1.14.1

# docker pull images of dashboard
sh docker_pull.sh gcr.io/google_containers/kubernetes-dashboard-amd64:v1.6.0

# docker pull images of consul
# sh docker_pull.sh consul:0.8.4

popd
