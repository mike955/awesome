# openresty安装(centos)

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