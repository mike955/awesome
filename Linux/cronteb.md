# crontab
 - crontab命令常见于Unix和类Unix的操作系统之中，用于设置周期性被执行的指令。该命令从标准输入设备读取指令，并将其存放于“crontab”文件中，以供之后读取和执行;
 - rontab储存的指令被守护进程激活，定时检查是否有作业需要执行，需要执行的作业称为 crontab job

### crontab job 使用

1. crontab job 文件存放在 /etc/crontab 文件，打开如下：

```sh
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name  command to be executed
```

前面三行用于配置定时任务的执行环境

2. 添加定时任务

shell 输入 *crontab -e* 编辑配置 /etc/crontab 文件，添加如下配置

```sh
0 * * * * /bin/ls           # 每天零点执行 /bin/ls 命令
0 1-22 * * * /bin/ls        # 1点到22点整执行 /bin/ls 命令
```

3. 其它命令

```sh
crontab -l          # 列出所有正在执行的定时任务
crontab file        # 执行 file 文件里面的定时认为
```