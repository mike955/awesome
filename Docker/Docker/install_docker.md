### install docker-ce for centos

---
#### 直接安装
```sh
curl -sSL https://get.docker.com/ | sh
```

#### 安装 docker-ce
```sh
#！/bin/bash

sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce
sudo systemctl start docker
```

#### 设置加速器

```sh
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://027f9e95.m.daocloud.io
sudo systemctl restart docker
```

#### 设置开机启动
```sh
systemctl enable docker
```