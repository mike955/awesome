# 命令行实现代理

1. 命令行执行下面代码

```sh
export proxy = 'http://localhost:port'

# shadowdsocks
# alias proxy = "export all_proxy = socks5://127.0.0.1:1080"
# alias unproxy = 'unset all_proxy'
```

2. 执行代理

```sh
# socks5
proxy
```

3. 取消代理

```sh
unproxy
```