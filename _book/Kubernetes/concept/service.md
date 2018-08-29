## 深度掌握service


<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

* [深度掌握service](#深度掌握service)
	* [1.service理解](#1service理解)
	* [2.service定义](#2service定义)
	* [3.多端口Service](#3多端口service)
	* [4.外部Service](#4外部service)

<!-- /code_chunk_output -->

---
### 1.service理解

 - service定义一系列Pod以及访问这些Pod的策略的一层抽象
 - service用与将一组label相同的pod组成一个服务，创建一个DNS入口，提供负载均衡和服务发现
 - 每个service会分配一个ClusterIP和DNS名，其它容器可以通过该地址和DNS来访问该服务

### 2.service定义

```yaml
apiVersion: v1              # 必须，版本号
kind: Service               # 必须，类型
metadata:                   # 必须，元数据
 name: string               # 必须，服务名称
 namespace: string          # 必须，服务所属命名空间，不指定时默认为default
 labels:                    # 服务自定义标签列表
  - name: string
 annotations:               # 服务自定义注解列表
  - name: string
spec:                       # 必须，详细描述
 selector: []               # 必须，选择指定label标签的pod作为管理范围
 type: string               # 必须，指定service的访问类型，默认为ClusterIP，还有NodePort、loadBalancer两种方式
 clusterIP: string          # type为ClunsterIP时，不指定则系统分配，type为loadBalancer时，需制定
 sessionAffinity: string    # 是否支持session，可选值为ClientIP，默认为空，clientIP表示将同一个客户端的访问请求都转发到同一个pod
 ports:                     # service暴露的端口号列表
 - name: string             # 端口名称
   protocol: string         # 端口协议
   port: int                # 端口号
   targetPort: int          # 需要转发到后端的端口号，为pod端口号(pod内容器端口号)，将Service port端口号的请求转发到pod的targetPort端口号
   nodePort: int            # 当spec.type为NodePort时，指定映射到物理机的端口号
 status:                    # 当spec.type=loadBalancer时，设置外部负载均衡器的地址，用于公有云环境
  loadBalancer:             # 外部负载均衡器
   ingress:                 # 外部负载均衡器
    ip: string              # 外部负载均衡器IP地址
    hostname: string        # 外部负载均衡器主机名
```

### 3.多端口Service

```yaml
...
sepc:
 ports:
 - name: web
   port: 8001
   targetPort: 8005
   protocol: TCP
 - name: dns
   port: 8801
   targetPort: 8805
   protocol: UDP
```

### 4.外部Service

某些环境中，系统需要一个外部数据库或将另一个集群作为后端，这时需要创建一个无label selector的service来实现

```yaml
apiVersion: v1
kind: Service
metadata:
 name: my-service
spec:
 ports:
 - protocol: TCP
   port: 80
   targetPort: 80
```

*上述yaml文件创建的是一个不带选择器的Service，无法选择后端pod，系统无法创建EndPoint，因此需要手动创建一个和该Service同名的EndPoint，用于指向实际的后端访问地址，创建EndPoint配置文件内容如下：*

```yaml
apiVersion: v1
kind: Endpoints
metadata:
 name: my-service       # 需要和上面service的name名称一样
subsets:
- addresses:
 - IP: 1.2.3.4
 ports:
 - port: 80
```