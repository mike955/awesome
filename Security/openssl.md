# OpenSSL

---
OpenSSL 是一个安全套接字层密码软件库包，适用于传输层安全性（TLS）和安全套接字层（SSL）协议。它包括主要的密码算法、常用的密钥和证书封装管理功能及 SSL 协议，并提供测试；应用程序可以使用这个包来进行安全通信、避免窃听、确认另一端连线者的身份，主要库以 C语言便编写

OpenSSL 支持多种不同的加密算法

 * 加密：AES、Blowfish、Camellia、SEED、CAST-128、DES、IDEA、RC2、RC4、RC5、TDES、GOST 28147-89
 * hash函数：MD5、MD4、MD2、SHA-1、SHA-2、RIPEMD-160、MDC-2、GOST R 34.11-94, BLAKE2、Whirlpool
 * 密钥加密：RSA、DSA、迪菲-赫尔曼密钥交换、椭圆曲线

OpenSSL 有两种工作模式: 交互模式和批处理模式

直接输入 openssl 进入交互模式，输入 opensll 进入批处理模式

## openssl 常见命令
```sh
# 对 md5.txt 文件内容以 hex 字符集进行加密，加密结果以流的形式输出
openssl dgst -md5 -d -hex md5.txt

# 对 123 以 hex 字符集形式进行加密
echo 123 | openssl dgst -md5 -hex

# 对 123 进行 base64 加密
echo 123 | openssl base64         # MTIzCg==

# 进行 base64 解密
echo MTIzCg== | openssl base64 -d  # 123
echo MTIzCg== | openssl base64 -d -out base64.txt   # 解密结果输出到 base64.txt 文件
```