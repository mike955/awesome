# 利用consul实现服务注册与发现

 * centos

## consul 介绍

 * consul agent 能够运行在 server 或 client 模式，每一个应用至少应该有一个 server，建议3-5


## 下载并解压 consule，移动解压后的二进制文件到执行目录
```sh
wget https://releases.hashicorp.com/consul/1.2.2/consul_1.2.2_linux_amd64.zip
unzip consul_1.2.2_linux_amd64.zip
sudo cp consul /usr/bin/
```

## 下载并解压 consul-template，移动解压后的二进制文件到执行目录
```sh
wget https://releases.hashicorp.com/consul-template/0.19.5/consul-template_0.19.5_linux_amd64.zip
unzip consul-template_0.19.5_linux_amd64.zip
sudo cp consul-template /usr/bin/
```

### 安装 openresty

```sh
#!bin/bash

# install_openresty
yum install pcre-devel openssl-devel gcc curl

wget https://openresty.org/download/openresty-1.13.6.2.tar.gz

tar -xzvf openresty-1.13.6.2.tar.gz
cd openresty-1.13.6.2/
./configure
make -j2
sudo make install
```

### 启动 consul-server

```sh
consul agent -server -bootstrap-expect 1 -data-dir /tmp/consul -bind 0.0.0.0 -client 0.0.0.0 -ui
# -server 表示以 server 模式启动consul
# -bootstrap-expect
# -data-dir 表示 consul 配置存储路径
# -bind 设置地址为集群通行
# -client 客户端进入地址
# -ui 能够使用 ui 界面
```
