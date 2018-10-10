#!/bin/bash

ROOT=$(cd `dirname $0`/../&&pwd)

# kubectl create -f $ROOT/manifests/kubedns/

# ETCD_KEY=$(cat $ROOT/ssl/etcd-key.pem | base64 -w 0)
# ETCD_CERT=$(cat $ROOT/ssl/etcd.pem | base64 -w 0)
# ETCD_CA=$(cat $ROOT/ssl/ca.pem | base64 -w 0)

# cat > $ROOT/manifests/calico/calico-secret.yaml <<EOF
# ---

# # The following contains k8s Secrets for use with a TLS enabled etcd cluster.
# # For information on populating Secrets, see http://kubernetes.io/docs/user-guide/secrets/
# apiVersion: v1
# kind: Secret
# type: Opaque
# metadata:
#   name: calico-etcd-secrets
#   namespace: kube-system
# data:
#   # Populate the following files with etcd TLS configuration if desired, but leave blank if
#   # not using TLS for etcd.
#   # This self-hosted install expects three files with the following names.  The values
#   # should be base64 encoded strings of the entire contents of each file.
#   etcd-key: ${ETCD_KEY}
#   etcd-cert: ${ETCD_CERT}
#   etcd-ca: ${ETCD_CA}

# EOF
sh replace_env_variables.sh -m calico

kubectl create -f $ROOT/manifests/calico/rbac.yaml
# kubectl create -f $ROOT/manifests/calico/calico-secret.yaml
kubectl create -f $ROOT/manifests/calico/calico.yaml