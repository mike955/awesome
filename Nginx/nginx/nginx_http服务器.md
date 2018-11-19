# http 核心模块

## server 指令
```conf
server {
    listen 127.0.0.1:80;
    server_name default.example.com;
    server_name_in_redirect on;
}
```

## 域名解析
| 指令     | 作用                                                                                                                                  |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| resolver | 配置一个或多个域名服务器，用与解析上游服务器，将上游服务器的名字解析为 IP 地址，有一个可选的 valid 参数，它将会覆盖掉域名记录中的 TTL |

```conf
server {
    resolver 192.168.100.2 valid=300s;      # valid 为缓存解析结果的时间
    resolver_timeout 3s;    # 指定 dns 解析的超时时间

    location /{
        proxy_pass http://upstream;         # 将 http://upstream 解析为 http://192.168.100.2
    }
}
```

## 使用 limit 对请求进行限制

|http limit 指令|说明|
|----|-----|
|limit_conn|指定一个共享内存域(由指令 limit_conn_zone 配置)，并且指定每个键-值对的最大连接数|
|limit_conn_log_level|配置 limit_conn 后，请求达到限制后生成的错误日志级别|
|limit_conn_zone|指定一个 key，限制在 limit_conn  指令中作为第一个参数，第二个参数 zone，表明用与存储 key 的共享内存区名字、当前每个 key 的链接数量以及 zone 的大小(name:size)|
|limit_rate|限制客户端下载内容的速率(单位为字节/秒)，速率限制在连接级别，意味着一个单一的客户端可以打开多个连接增加其吞吐量 |
|limit_rate_after|完成设定的字节数之后，该指令启用 limit_rate 限制|
|limit_req|在共享内存(同 limit_req_zone 一起配置)中，对特定 key 设置并发请求能力的限制，并发数量可以通过第二个参数指定，如果要求在两个请求之间没有延时，那么需要配置第三个参数 nodelay|
|limit_req_log_level|在 nginx 使用了 limit_req 指令限制请求数量后，通过该指令指定在什么级别下报告日志记录，在这里延时(delay)记录级别要小于指示 (indicated) 级别|
|limit_req_zone|该指令指定 key，限制在 limit_req 指令中作为第一个参数，第二个参数 zone，表明用与存储 key 的共享内存名、当前 key 的请求数量，以及 zone 的大小 (name:size)，第三个参数 rate，表明配置在收到限制之前，每秒 (r/s) 请求数，或者每分钟请求数 (r/m)|
|max_range|该指令设置在 byte-range 请求中最大的请求数量，设置为 0 ，禁用对 byte-range 的支持|

```conf
http {
    limit_conn_zone $binary_remote_addr zone=connections:10m;
    limit_conn_log_level notice;    # 限制报告日志级别为 notice

    server {
        limit_conn connections 10;      # 限制每一个唯一 IP 地址
    }
}

http {
    limit_conn_zone $binary_remote_addr zone=requests:10m rate=1r/s;    # 设置用户请求速率为每秒一次
    limit_conn_log_level notice;    # 限制报告日志级别为 notice

    server {
        limit_req zone=requests burst=10 nodelay;       # 消除两次请求之间的延时
    }

    location /downloads {
        limit_rate_after 1m;    # 当下载文件大小超过 1M 时，开始下载限速
        limit_rate  500k;       # 限制下载速率为 500 k
    }
}
```

## 对请求进行约束

|指令|说明|
|---|---|
|allow|允许设置的值访问|
|auth_basic|启用 http 基本认证，以字符串作为域的名字|
|auth_basic_user_file|指定一个文件的位置，文件的格式为 username:password:comment|
|deny|禁止访问的地址|
|satisfy|表示用户必须来自于一个特定的网络地址|