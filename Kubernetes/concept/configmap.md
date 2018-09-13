# ConfigMap

ConfigMap 提供一种统一的应用配置管理方案，用于将配置文件从容器镜像中解耦，增强容器应用的可移植性。

ConfigMap 主要有以下三种典型用法：
 * 生成容器内的环境变量
 * 设置容器启动命令的启动参数（需设置为环境变量）
 * 以 Volume 的形式挂载为容器内部的文件或目录

ConfigMap 以一个或多个 key:value 的形式保存在 kubernetes 系统中供应用使用，既可以表示一个变量的值，也可以表示一个完整的配置文件内容。

可以通过 yaml 文件或直接使用`kubectl create configmap`命令创建 ConfigMap。

## 创建 ConfigMap 资源对象

### 以 yaml 配置文件方式创建
*test-configmap.yaml*
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: test            # configmap 文件名
data:                   # configmap 值
  apploglevel: info
  appdatadir: /var/data
```
执行命令创建 configmap
```sh
kubectl create -f test-configmap.yaml
```
查看configmap
```sh
kubectl describe configmap test

# output
Name:         test
Namespace:    kube-td
Labels:       <none>
Annotations:  <none>

Data
====
appdatadir:
----
/var/data
apploglevel:
----
info
Events:  <none>
```

### 以命令行方式创建
1. 
```sh
# bar 为键值，bar文件内容为键值
kubectl create configmap test --from-file=bar
```
2. 基于文件创建，使用特定的 key
```sh
# file1.text 的 key 为 key1，file2.txt 的 key 为 key2
kubectl create configmap my-config --from-file=key1=/path/to/bar/file1.txt --from-file=key2=/path/to/bar/file2.txt
```

3. 字面量方式创建
```sh
kubectl create configmap special-config --from-literal=foo=bar --from-literal=goo=mar

kubectl get configmap special-config -o yaml

# output 
apiVersion: v1
data:
  foo: bar
  goo: mar
kind: ConfigMap
metadata:
  creationTimestamp: 2018-09-13T08:31:59Z
  name: special-config
  namespace: kube-td
  resourceVersion: "61373854"
  selfLink: /api/v1/namespaces/kube-td/configmaps/special-config
  uid: 7b35eb43-b72f-11e8-83ef-c81f66e45558
```

## 在 pod 内使用 ConfigMap
1. 通过环境变量方式使用 configmap
configmap 内容如下：
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: test            # configmap 文件名
data:                   # configmap 值
  apploglevel: info
  appdatadir: /var/data
```
pod yaml 文件如下
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test
spec:
  containers: info
  - name: clx-test
    image: centos
    command: ["/bin/bash", "-c", "env | grep App"]
    env:
    - name: APPLOGLEVEL
      valueFrom:
        configMapKeyRef:        # 使用 test ConfigMap 中值
          name: test
          #如果 key 值不设定，则 test configMap 的所有配置都是 Pod 的环境变量
          key: apploglevel      # 在容器内就可以使用 apploglevel 环境变量了
```

2. 通过 volumeMount 使用 ConfigMap
configmap 内容如下：
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: test            # configmap 文件名
data:                   # configmap 值
  apploglevel: info
  appdatadir: /var/data
```
pod 内容如下
```yaml
apiVersion: v1
kind: Pod
metada:
 name: test
spec:
  containers:
  - name: test-kk
    image: centos
    volumeMounts:
    - name: servervol
        path: keys  # 对 /
      mountPath: /configfiles   # 将容器内的 /configfiles 路径挂载到卷 servervol
  volumes:
  - name: servervol
    configMap:
      name: test
      items:
      - key: apploglevel
        path: keys.txt  # 对 /configfiles/keys.txt 文件进行挂载，内容为 test configmap 中健为 apploglevel 的值
      - key: appdatadir
        path: apps.json # 对 /configfiles/apps.json 文件进行挂载，内容为 test configmap 中健为 appdatadir 的值
```
进入容器查看挂载数据
```sh
cat /configfiles/keys.txt
# info

cat /configfiles/app.json
# /var/data
```