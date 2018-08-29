### Mysql安装脚本

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