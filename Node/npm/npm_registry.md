# 搭建 npm registry -- Sinopia

---

### 1. 安装 Sinopia

```sh
npm install sinopia -g
```

### 2. 启动 Sinopia

```sh
sinopia   # 或 pm2 start `which sinopia`

# warn  --- config file - /home/clx/.config/sinopia/config.yaml
# warn  --- http address - http://localhost:4873/
```

### 3. 修改配置文件 ~/config/sinopia/config.yaml

```yaml
#
# This is the default config file. It allows all users to do anything,
# so don't use it on production systems.
#
# Look here for more config file examples:
# https://github.com/rlidwka/sinopia/tree/master/conf
#

# path to a directory with all packages
storage: ./storage

auth:
  htpasswd:
    file: ./htpasswd
    # Maximum amount of users allowed to register, defaults to "+inf".
    # You can set this to -1 to disable registration.
    max_users: -1       # 默认为1000， 修改为 -1， 禁止客户端注册

# a list of other known repositories we can talk to
uplinks:
  npmjs:
    url: https://registry.npmjs.org/    # 拉取公共包的地址源，可以修改为淘宝镜像地址

packages:       # 报权限管理
  '@*/*':       # 内部包
    # scoped packages
    access: $all                        # 表示所有人都可以执行操作
    publish: $authenticated             # 表示只有通过验证的用户才可以执行的操作

  '*':          # 公共包
    # allow all users (including non-authenticated users) to read and
    # publish all packages
    #
    # you can specify usernames/groupnames (depending on your auth plugin)
    # and three keywords: "$all", "$anonymous", "$authenticated"
    access: $all            # 表示

    # allow all known users to publish packages
    # (anyone can register by default, remember?)
    publish: $authenticated

    # if package is not available locally, proxy requests to 'npmjs' registry
    proxy: npmjs        # 如果包寻找不到，则 proxy 到配置文件 uplinks 下 npmjs 对应的地方去寻找

# log settings
logs:
  - {type: stdout, format: pretty, level: http}
  #- {type: file, path: sinopia.log, level: info}

listen: 0.0.0.0:4873    # 修改服务监听，可以从外网访问 sinopia 仓库

#
#  packages 配置说明
#
#  1. 每个过滤器有三项基本配置 
#       access -- 安装(install)
#       publish -- 发布(publish)
#       proxy  -- 路由(对应upliks值)
#
#  2. access、publish 有三种值
#       $all -- 所有人
#       $authenticated  -- 需要鉴权
#       $anonymous  -- 只有匿名者可以操作

```

修改完配置文件后重新启动

### 4. 客户端配置

#### 4.1 安装 nrm 管理 npm registry

```sh
npm install -g nrm
```

#### 4.2 添加sinopia 仓库地址

```sh
nrm add sinopia http://192.168.xx.xx:4873
```

#### 4.3 查看所有仓库地址

```sh
nrm ls

  npm ---- https://registry.npmjs.org/
  cnpm --- http://r.cnpmjs.org/
  taobao - https://registry.npm.taobao.org/
  nj ----- https://registry.nodejitsu.com/
  rednpm - http://registry.mirror.cqupt.edu.cn/
  npmMirror  https://skimdb.npmjs.com/registry/
  edunpm - http://registry.enpmjs.org/
* sinopia  http://192.168.17.209:4873/

```

#### 4.4 切换仓库地址

```sh
nrm use sinopia
```

### 5. 创建用户

#### 5.1 客户端创建

 *前提是配置文件中 max_users 不能设置为 -1*

```sh
npm adduser --registry http://localhost:4873/
```

#### 5.2 手动添加用户

 *在 ～/.config/sinopia/htpasswd 文件添加用户(没有改文件则手动创建)*
```sh
vim htpasswd

# zza00000:{SHA}6CsImV9vbOmL87Hmi2cg0yiuGJA=:autocreated 2018-08-20T23:20:36.085Z
# cai3564423:{SHA}6CsImV9vbOmL87Hmi2cg0yiuGJA=:autocreated 2018-08-20T23:40:32.396Z
```

加密算法为 SHA1 之后转换成 Base64 输出，最后面是时间

#### 5.3 htpasswd-for-sinopia 添加用户

```sh
# install
npm install htpasswd-for-sinopia -g

# add user
sinopia-adduser     # 在 htpasswd 目录下执行，按提示输入用户名和密码
```
可以发现 htpasswd 文件后添加了一条用户信息

### 6.发包

与正常的npm发包一样

```sh
npm publish
```