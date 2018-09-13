# Systemd unit
systemd 是 Linux 下的一款系统和服务管理器，而 Units 是Systemd 所能够管理的对象，是对系统资源的标准化表示，可以被 systemd 套件的守护进程所管理，同时也可以被提供的命令工具所操作。

Unit 文件通常以下面这种方式命名
```sh
unit_name.type_extension
# unit_name 表示 unit 名称
# type_extension 表示 unit 类型
```

## unit 文件结构
unit 文件由三部分组成

 * [Unit] - 包含不依赖与单元类型的通用选项，这些选项提供单元描述，指定单元的行为，并设置与其他单元的依赖关系
 * [unit type] - 如果一个单元具有特定与类型的指令，则这些指令将按照以单元类型命名的部分进行分组
 * [Install] - 包含有关 systemctl 启动和禁止命名使用的单元安装信息

unit 文件结构如下，其中 type 以 service 进行说明，其他类型的单元 unit 和 install 类型
```s
[Unit]
Description=Kubernetes API Server       # 当前 service 描述
Documentation=https://github.com/GoogleCloudPlatform/kubernetes # 当前 service 藐视
After=network.target            # 当前 service 应该在 network.target 之后启动
Requires=network.target         # 当前 service 强依赖 network.target，如果 network.target 退出，当前 service 也会退出
Wants=docker.service            # 当前 service 若依赖 docker.service，如果 docker.service 推出，当前 service 不退出

[Service]
ExecStart=/opt/k8s/bin/kube-apiserver   # 启动当前 service 得命令
Restart=on-failure                      # 什么情况下 service 重启
RestartSec=5                            # 重启之前需要等待的秒数
Type=notify                             # 启动类型，有 simple、forking、oneshot、dbus、notify、idle
User=k8s                                # 使用那个账户运行
LimitNOFILE=65536                       # 进程打开最大文件

[Install]
WantedBy=multi-user.target              # 表示当前 service 得 target 是 multi-user.target,multi-user.taeget 是系统默认的 target ，系统默认的 target 会开启自启动
EOF
```

## unit 文件类型

|文件类型|后缀名|描述|
|----|----|----|
|service|.service|系统类别|
|target|.target|服务组|
|automount|.automount|文件系统自动挂载点|
|device|.device|内核识别的设备文件|
|mount|.mount|文件系统挂载|
|path|.path|文件路径|
|scope|.scope|外部创建的进程|
|slice|.slice|一组管理系统进程的分成组织单元|
|snapshot|.snapshot|系统管理状态的快照|
|socket|.socket|内部通信进程|
|swap|.swap|一个交换设备或交换文件|
|timer|.timer|系统时钟|