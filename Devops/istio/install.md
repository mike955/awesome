# 使用 helm 安装 istio

```sh
curl -L https://git.io/getLatestIstio | sh -
cd istio-1.0.0  # 版本不一定为1.0.0
helm template install/kubernetes/helm/istio --name istio --namespace istio-system > $HOME/istio.yaml
kubectl create namespace istio-system
kubectl create -f $HOME/istio.yaml
```
docker save --output pilot.tar istio/pilot:1.0.2
