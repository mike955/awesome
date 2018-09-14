# Cfssl

cfssl 是 CloudFlare 开源的一款 PKI 工具，包含一个命令行工具和一个用户签名、验证并且捆绑 TLS 证书的 HTTP API 服务器

## 安装

```sh
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64

mv cfssl_linux-amd64 cfssl
mv cfssljson_linux-amd64 cfssljson
mv cfssl-certinfo_linux-amd64 cfssl-certinfo
chmod +x cfss*
mv cfss* /usr/local/bin
```

## 相关概念

- CA(Certificate Authority): 数字证书认证机构，负责发放和管理数字证书的权威机构，承担公钥体系中公钥的合法性检验和责任，CA 中心为每个使用公开密钥的用户发放一个数字证书，数字证书的作用是证明证书中列出的用户发拥有证书中列出的公开密钥
- X.509: X.509 是密码学里公钥证书的格式标准，X.509 证书里含有公钥、身份信息和签名信息；在 X.509 里，组织机构通过发起证书签名请求(CSR)来得到一份签名的证书。首先需要生成一堆钥匙对，然后利用其中的私钥对 CSR 进行签名，并安全地保存私钥，CSR 进而包含有请求发起者的身份信息、用来对此请求进行验真的公钥以及所请求证书专有名称。CSR 里还可能带有 CA 要求的其它有关身份证明的信息。然后 CA 对这个专有名称发布一份证书，并绑定一个公钥，组织机构可以把受信的根证书分发给所有成员，这样就可以使用 PKI 系统了
- PKI(Publick Key Infrastructure): 公开密钥基础设施，是一组由硬件、软件、参与者、管理策略与流程组成的基础架构，目的在于创建】管理、分配、使用、存储以及撤销数字证书
- CSR(Certificate Signing Request): 证书签名请求文件，证书申请者在申请数字证书是时需要提供该文件，证书颁发机构利用其根证书对 CSR 私钥签名，得到证书公钥文件，也就是颁发给用户的证书
- 根证书: 根证书属于根证书颁发机构 (CA) 的公钥证书，是 PKI 信任链的起点。网站的公众用户通过验证 CA 的签字从而信任 CA，任何人都可以得到 CA 的证书(公钥)，用以验证它所签发的证书
- 证书签名: 发送报文时，发送放用一个 hash 函数从报文文本中生成报文摘要，然后用自己的私钥对摘要进行加密，生成“数字签名”，将数字签名附在报文下面一起发送
- hash(散列): 将任意长度的数据映射到有限长度的域上，即把人意长度的输入通过散列算法变换成固定长度的输出，输出值就是散列值
- salt(盐): 指在散列之前在散列内容的任意固定位置插入特定的字符串，让散列结果和未加盐结果不同
- 公钥和私钥: 也称非对称加密。 需要两个密钥(一一对应)，一个是公开密钥，一个是私有密钥，公开密钥用于加密，私有密钥用于解密；使用一个密钥加密后的报文只能用对应的另一把密钥进行解密，加密的密钥也不能解密；私钥负责签名，公钥负责验证
- .pem: 表示 privacy enhanced mail, 表示带有页眉和页脚的 base64 编码格式的文件
- .key: 可以是任何类型的密钥，通常指私钥
- .csr: 表示 Certificate Signing Request，是你在向第三发申请证书签名时发送的内容，编码可以是 pem 或 der
- .crt: 代表 certificate(证书)，通常是 X509 标准证书，包含公钥和颁发机构对数据和公钥的签名

## cfssl 包含以下功能

- 一组用于构建自定义 TLS PKI 工具的包
- cfssl 命令行工具，用于使用 cffssl 工具包
- multirootca 工具，可以使用多个签名密钥的证书颁发机构服务器
- mkbundle 工具，用于构建证书池
- cfssljson 工具，接受来自 cfssl 和 multirootca 的 json 输出，并将证书、密钥、CSR 和包写入磁盘

cfssljson 能够获取 cfssl 的 json输出，并根据需要将其拆分为单独的密钥、证书、CSR 和捆版文件

## cfssl 命令行

| 命令           | 作用               |
| -------------- | ------------------ |
| sign           | 签名证书           |
| bundle         |                    |
| genkey         | 生成私钥和证书请求 |
| gencert        | 生成私钥和证书     |
| serve          | 启动 API 服务器    |
| version        | 输出当前版本       |
| selfsign       | 生成一个自签名证书 |
| print-defaults | 打印默认配置       |

## 使用

### 证书生成策略
可以使用 `cfssl print-defaults config` 查看证书生成策略的默认配置
典型的证书生成策略配置如下
```json
{
  "signing": {              // 表示该证书可用于签名其它证书，生成的 ca.pem 证书中 CA=TRUE
    "default": {            // 默认配置
      "expiry": "87600h"    // 证书过期事件
    },
    "profiles": {            // 其它配置，可以有多个
      "kubernetes": {        //策略名称
        "usages": [          // 用途
            "signing",       //可用于签名其它证书
            "key encipherment",
            "server auth",   // 该证书可以对 server 提供的证书进行验证
            "client auth"    // 改证书可以多 client 提供的证书进行验证
        ],
        "expiry": "87600h"      //过期事件
      }
    }
  }
}
EOF
```

### 生成一个自签名的根 CA 证书和私钥
可以使用 `cfssl print-defaults csr`  查看默认的证书请求配置
典型的 csr 文件如下
```json
{
    "CN": "customer.com",  // common name,浏览器使用改字段验证网站是否合法
    "hosts": [              // 指定授权使用该证书的节点，可以为空或没有该字段
             "customer.com",
             "www.customer.com"
    ],
    "key": {                // 关键字说明
           "algo": "rsa",   // 使用的算法
           "size": 2048     // 算法位数
    },
    "names": [
             {
                    "C": "US",      // country
                    "L": "San Francisco",   // locality
                    "O": "Customer",    // organization name
                    "OU": "Website",    // organization unit name
                    "ST": "California"  // state
             }
    ]
}
```

### 实例
1. 生成一个自定义签名的 CA 证书和私钥
```sh
cat > ca-csr.json <<EOF
{
  "CN": "kubernetes",   
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "k8s",
      "OU": "4Paradigm"
    }
  ]
}
EOF
cfssl genkey -initca ca-csr.json | cfssljson -bare ca
ls ca*
# ca-key.pem  ca.csr  ca.pem
```
有三个文件生成ca-key.pem（私钥）、ca.csr（证书签名请求文件）、ca.pem（证书）

2. 利用 CA 证书对其它请求进行签名
创建 X 证书签名请求
```sh
cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "BeiJing",
      "L": "BeiJing",
      "O": "system:masters",
      "OU": "4Paradigm"
    }
  ]
}
EOF
```
使用`cfssl gencert`生成私钥和证书，`cfssl gencert`参数如下：
```sh
cfssl gencert --help

Flags:
  -initca=false: initialise new CA
  -remote="": remote CFSSL server
  -ca="": CA used to sign the new certificate
  -ca-key="": CA private key
  -config="": path to configuration file    # 证书生成策略配置文件
  -hostname="": Hostname for the cert, could be a comma-separated hostname list
  -profile="": signing profile to use   # 使用证书生成策略中的某个策略
  -label="": key label to use in remote CFSSL server
```
生成证书文件
```sh
cfssl gencert -ca=ca.pem \
    -ca-key=ca-key.pem \
# 此处使用上面配置好的证书生成策略
    -config=ca-config.json \
    -profile=kubernetes admin-csr.json \
    | cfssljson -bare admin

ls admin*
# admin-key.pem(密钥)  admin.csr(证书签名请求)  admin.pem(证书)
```

    