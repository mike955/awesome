# MySQL 数据库迁移

最近公司数据库版本太低，使用起来不方便，需要将开发网数据库迁移一下，原有数据库和新数据库都使用 docker 镜像，下面说一下整个迁移流程

mysql verions
 * old - 5.6
 * new - 8.0

## 部署新数据库

新数据库使用 docker 部署，版本为 8.0
```sh
docker run --name mysql \
    -p 3307:3306 \
    -e MYSQL_ROOT_PASSWORD=@Cai3564423 \
    -v /Users/clx/dockerVolume/mysql:/var/lib/mysql \
    -d mysql:8
```
由于 mysql8.0 客户端启用了密码插件，因此需要进入mysql 将密码设置为使用原始密码
```sql
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'you_root_password';
```

## 备份老的数据库中数据
由于 mysql 使用的是 debian 镜像，默认没有安装 openssh-clients，因此需要先在 mysql 容器中安装 openssl 客户端，然后使用 scp 命令将备份的数据拷贝到目标机器。
```sh
apt-get install openssh-clients -y
```

备份数据库使用 mysqldump 工具进行备份
```sh
mysql --all-databases -u rrot -p > mysql_bak.sql
```
然后使用scp 命令将数据拷贝到目标机器，导入数据
```sh
mysql -u root -p < mysql_bak.sql
```
在导入数据的时候会报 mysql 数据的错误，因为我们在导出数据的时候默认把系统数据库也导出来了，因此需要去掉系统数据库，使用下面的命令导出非系统数据库。
```
mysql -e "show databases;" -u root -p | grep -Ev "mysql|performance_schema|information_schema|Database" | xargs mysqldump -u root -p --databases --add-drop-database --lock-all-tables > mysql_bak.sql
```
将数据拷贝到新数据的 mysql8.0 镜像映射的目录下

## 导入数据到新的数据库
直接使用 mysql 命令导入数据
```
mysql -u root -p < mysql_bak.sql
```
等待导入完成

这忠方法不适用于集群数据库，

## mysqldump 工具介绍

mysqldump 是 mysql 官方推出的一款数据备份工具，mysqldump 用于生成一组 SQL 语句，通过执行生成的 SQL 语句来重现原始数据库中的数据，还可以生成 CSV 或 XML 等格式文件。

基本使用命令如下:
```sh
mysql [options] -u root -p > dump.sql
```