## 深度掌握 pod

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [深度掌握 pod](#深度掌握-pod)
	* [1.pod 理解](#1pod-理解)
	* [2.pod 定义](#2pod-定义)
	* [3.pod 基本用法](#3pod-基本用法)
	* [4.静态 pod](#4静态-pod)
		* [4.1 创建静态 pod](#41-创建静态-pod)
	* [5.pod 共享 volume](#5pod-共享-volume)
	* [6.pod 管理配置](#6pod-管理配置)
		* [6.1 ConfigMap 应用场景](#61-configmap-应用场景)
		* [6.2 创建方式](#62-创建方式)
			* [6.2.1 yaml 文件创建方式](#621-yaml-文件创建方式)

<!-- /code_chunk_output -->

---

### 1.pod 理解

- pod 是 k8s 调度的最小单位
- pod 是一组紧密关联的容器集合，共享 PID、IPC、Network 和 UTS namespace
- pod 只有集群自动分配的 ip，没有端口，如果访问容器，使用 podIP:containerPort(EndPoint)

### 2.pod 定义

```yaml
apiVersion: v1 #required，版本号
kind: Pod #必须，模版对象类型
metadata: #必须，元数据
  name: string #必须，pod名称
  namespace: string #必须，pod所属命名空间
  labels: #必须，自定义标签列表
    - name: string #标签名称和值
  annotations: #自定义注解列表
    - name: string #列表名称和值
spec: #必须，pod中容器详细定义
  containers: #必须，容器列表
    - name: string #必须，容器名称
      images: sring
      imagePullPolicy: [Always | Never | IfNotPresent] #获取镜像策略，always(每次都尝试下载新镜像)、never(仅使用本地镜像)、IfNotPresent(优先使用本地镜像)
      command: [string] #容器启动命令列表，不指定则使用镜像打包时使用的启动命令
      args: [string] #容器启动命令参数列表
      workingDir: string #容器工作目录
      volumeMounts: #挂载到容器内部的存储卷配置
        - name: string #引用pod定义的共享存储卷的名称
          mountPath: string #存储卷在容器内mount的绝对地址
          readOnly: boolean #是否为只读模式，默认为只读模式
      ports: # 容器需要暴露的端口号地址
        - name: string # 端口名称
          containerPort: int # 容器需要监听的端口号
          hostPort: int # 容器所在主机需要监听的端口号
          protocol: string # 端口协议，支持tcp和udp，默认为tcp
      env: # 容器运行前需设置的环境变量列表
        - name: string # 环境变量名称
          value: string # 环境变量值
      resources: # 资源限制和资源请求限制
        limits: # 资源限制的设置
          cpu: string # cpu限制，单位了core数，将用于docker run --cpu-shares参数
          memory: string # 内存限制，单位可以为MiB/GiB等，将用于docker run --memory参数
        requests: # 资源限制的设置
          cpu: string # cpu请求，单位为core，容器启动的初始可用数量
          memory: string # 哪出请求，单位可以为MiB、GiB等，容器启动的初始可用数量
      livenessProbe: # 对pod内容器设置探针进行健康检查
        exec: # exec方式
          command: [string] # exec方式命令或脚本
        httpGet: # 对pod内容器已httpGet方式进行健康检查，需指定path和port
          path: string
          port: number
          host: string
          scheme: string
          httpHeaders:
            - name: string
              value: string
        tcpSocket: # tcpSocket方式进行健康检查
          port: number
        initialDelaySeconds: 0 # 容器完成后进行首次探测的时间，单位为s
        timeoutSeconds: 0 # 设置探针响应超时时间，单位为s，默认为1s，超过该时间，默认为容器不健康，重启容器
        periodSeconds: 0 # 设置检测时间间隔，单位为s，默认为10s
        successThreshold: 0
        failureThreshold: 0
        securityContext:
          privileged: false
  restartPolicy: [Always | Never | OnFailure] # pod重启策略
  nodeSelector: object # 将改pod调度到包含这些label的node上，以key:value格式指定
  imagePullSecrets: # pull 镜像时使用的secret名称
    - name: string
  hostNetwork: false
  volumes: # pod上定义的共享存储卷列表
    - name: string # 共享存储卷的名字
      emptyDir: {} # 类型为enptyDir的存储卷，表示与pod同生命周期的一个零时目录，其值为一个空对象：enptyDir:{}
      hostPath: # 类型为hostPath的存储卷，表示挂载pod所在宿主机的目录，
        path: string # pod所在宿主机的目录
      secret: # 类型为secret的存储卷，表示挂载集群与定义的secret对象到容器内部
        secretName: string # secret存储卷名字
        items:
          - key: string
            path: string
      configMap: # 类行为configMap的存储卷，表示挂载集群预定义的configMap对象到容器内部
        name: string
        items:
          - key: string
            path: stirng
```

### 3.pod 基本用法

```sh
kubectl create -f name-pod.yaml		# 以name-pod.yaml模版创建pod

kubectl get po				# 查看已创建的pod

kubectl describe pod po-name		# 查看名为po-name的pod详情
```

### 4.静态 pod

#### 4.1 创建静态 pod

- 配置文件
- http 方式

### 5.pod 共享 volume

```yaml
apiVersion: v1
kind: Pod
metadata:
 name: volume-pod
spec:
 containers:
 - name: tomcat
   image: tomcat
   ports:
   - containerPort: 8080
   volumeMounts:
   - name: app-logs
	 mountPath: /usr/local/tomcat/logs	# 将tomcat容器内的该路径挂载到pod的app-logs存储卷
 - name: logreader
   image: busybox
   command: ["sh", "-c", "tail -f /logs/catalina*.log"]
   volumeMounts:
   - name: app-logs
	 mountPath: /logs		# 将logreader容器的该路径挂载到pod的app-logs存储卷
 volumes:				# pod级别存储卷
  - name: app-logs		# 存储卷名称
    emptyDir: {}		# 存储卷类型
```

_可以理解为 tomcat 容器将自身的/usr/local/tomcat/logs 目录映射到 pod 的 app-log 存储卷，logreader 容器将自身的/logs 目录映射到 pod 的 app-logs 的存储卷， 通过映射，logreader 就可以读取 tomcat 容器内的文件_

### 6.pod 管理配置

#### 6.1 ConfigMap 应用场景

- 生成容器内环境参数
- 设置容器启动命令的启动参数
- 以 Volume 的形式挂载为容器内部的文件或目录

#### 6.2 创建方式

```sh
kubectl create configMap 				# 通过命令工具

kubectl create -f configMap-name.yaml 	# 通过配置文件
```

##### 6.2.1 yaml 文件创建方式

```yaml
apiVersin: v1
kind: ConfigMap
metadata:
  name: cm-appvars
data:
  apploglevel: info
  appdatadir: /var/data
```
