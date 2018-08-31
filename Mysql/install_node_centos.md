# Mysql安装脚本


## centos
install_mysql57.sh
```sh
#!bin/bash
wget wget http://repo.mysql.com/mysql57-community-release-el7-8.noarch.rpm
yum  localinstall http://repo.mysql.com/mysql57-community-release-el7-8.noarch.rpm
yum install mysql-community-server

# start mysql
service mysqld start

# get temporary passport
grep "temporary password" /var/log/mysqld.log
```

修改初始密码
```sh
alter user root@localhost identified by '@Cai3564423';
```

## docker

```sh
docker run --name mysql \
    -p 3306:3306 \
    -e MYSQL_ROOT_PASSWORD=@Cai3564423
    -v /Users/clx/dockerVolume/mysql:/var/lib/mysql \
    -d mysql:8
```

MySQL8.0.4开始默认采用的caching_sha2_password 密码插件，客户端连接会报错，需要执行下面语句

```sql
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456a?';
```