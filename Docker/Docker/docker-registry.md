
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->
### 搭建私有registry仓库

* [搭建私有 registry 仓库](#搭建私有registry仓库)
* [拉取docker-registry镜像](#拉取docker-registry镜像)
* [拉取docker-registry镜像](#拉取docker-registry镜像)
* [运行 docker-registry](#运行-docker-registry)
* [查看私库镜像](#查看私库镜像)
* [推送镜像到私库](#推送镜像到私库)


require
 * docker 1.6.0+

##### 拉取docker-registry镜像

```sh
docker pull registry:latest
```

##### 运行 docker-registry

```sh
docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  -v /mnt/registry:/var/lib/registry \
  --privileged=true \
  registry
```

##### 查看私库镜像

```sh   
curl localhost:5000/v2/_catalog

```

##### 推送镜像到私库

###### 1. docker-registry 机器拉取镜像推送到仓库

```sh
docker pull centos

docker images tag centos localhost:5000/centos

docker  push localhost:5000/centos
```

###### 2.其它机器推动镜像到私库

当前机器 docker 添加 insecure-registry 地址

 * mac、windows在客户端中 insecure-registry 中添加 192.168.16.47:5000
 * linux 在 /etc/sysconfig/docker 中添加如下配置
  ```sh
  ADD_REGISTRY='--insecure-registry 192.168.16.47:5000'
  ```
 * push 可能会出现retry，多试几次

```sh
docker pull centos

docker images tag centos 192.168.16.47:5000/centos

docker push 192.168.16.47:5000/centos
```
