# nginx 用作反向代理

## 反响代理简介
nginx 通过`proxy_pass`将客户端的请求转发到上有服务器，带有 URI 部分的`proxy_pass`指令会使用该 URI 替代`request_uri`部分，有两种特殊情况（正则匹配规则、rewrite）不会替代，看下面的代码
```conf
# 前缀匹配
location /uri {
    proxy_pass http://localhost:8080/newuri;    # /uri 请求在转发到上游服务器的时候会被替换为 /newuri
}

# 正则前缀优先匹配
location ~^ /local {
    proxy_pass http://localhost:8080/foreign;   # location 定义的匹配规则为正则，匹配该规则的请求的 uri 不会被替换为 /foreign，而是使用原来的 uri
}

#
location / {
    rewrite /(.*)$  /index.php?page=$1 break;   # break 标记用于立即停止 rewrite 模块的所有指令
    proxy_pass http://localhost:8080/index;    # location 内有 rewrite 规则改变了 URI，请求转发到上游服务器时，URI 为/index.php?page=<match>，match为 rewrite 前面括号中的参数
}
```

## proxy 模块常用指令
| 指令                           | 含义                                                                                 |
| ------------------------------ | ------------------------------------------------------------------------------------ |
| proxy_connect_timeout          | 设置接受请求到连接至上游服务器的最长等待时间                                         |
| proxy_cookie_domain            | 设置内容将会替换从上游服务器来的 set-Cookie 头中的 domain 属性                       |
| proxy_cookie_path              | 设置内容将会替换从上游服务器来的 set-Cookie 头中的 path 属性                         |
| proxy_headers_hash_bucket_size | 设置头名字的最大值                                                                   |
| proxy_headers_hash_max_size    | 设置从上游服务器接受到的头的总大小                                                   |
| proxy_hide_header              | 设置不应该传递给客户端头的列表                                                       |
| proxy_http_version             | 设置同上游服务通信的 http 版本                                                       |
| proxy_ignore_client_abort      | 设置为 on 时表示当客户端放弃连接后，nginx 将不会放弃同上游服务器的连接               |
| proxy_ignore_headers           | 处理来自于上游服务器的相应时，设置哪些头可以被忽略                                   |
| proxy_intercept_errors         | 启用该指令时，nginx 将会显示配置的 error_page 错误，而不是来自于上游服务器的直接响应 |
| proxy_max_temp_file_size       | 在写入内存缓冲区时，当响应与内存缓冲区不匹配时，该指令给出溢出文件的最大值           |
| proxy_pass                     | 上游服务器地址，格式为 URL                                                           |
| proxy_pass_header              | 该指令覆盖掉在 proxy_hide_header 指令中设置的头，允许这些头传递到客户端              |
| proxy_pass_request_body        | 设置为 off 时将会阻止请求体发送到上游服务器                                          |
| proxy_pass_request_headers     | 设置为 off 时将会阻止请求头发送到上游服务器                                          |
| proxy_read_timeout             | 设置连接关闭前，从上游服务器两次成功的读操作耗时                                     |
| proxy_redirect                 | 重写来自于上游服务器的 Location 和 Refresh 头                                        |
| proxy_send_timeout             | 设置连接关闭前，向上游服务器两次写成功的操作完成所需的时间长度                       |
| proxy_set_body                 | 设置发送到上游服务器的请求体                                                         |
| proxy_set_header               | 设置发送到上游服务器的头                                                             |
| proxy_temp_file_write_size     | 设置同一时间内缓冲到一个临时文件的数据量，以使得 nginx 不会过长地阻止单个请求        |
| proxy_temp_path                | 设置临时文件的缓冲，用于缓冲从上游服务器来的文件                                     |

## proxy 模块常见配置

```conf
location / {

    # 可以将下面的配置写进一个文件中，通过 include 来多次使用
    proxy_redirect              off;    # 关闭重写 location 头
    proxy_set_header            Host        $host;          # 设置 Host 头
    proxy_set_header            X-Real-IP   $remote_addr;   # 转发连接的客户端 IP 地址到上游服务器
    proxy_set_header            X-Forwarded-For $proxy_add_x_forwarded_for;     # 转发连接的客户端 IP 地址到上游服务器
    
    client_max_body_size        10m;    # 设置客户端请求体大小
    client_body_buffer_size     128k;   # 
    
    proxy_connect_timeout       30;     # 设置连接上游服务器超时时间
    proxy_send_timeout          15;     # 设置同上游服务器连接成功的两次操作时间
    proxy_read_timeout          15;
    proxy_send_lowat            12000;  # 只在 FreeBSD 系统下有效
    proxy_buffer_size           4k;     # 设置缓冲控制，缓冲设置控制了 nginx 如何快速响应用户请求
    proxy_buffers               32 4k;
    proxy_busy_buffers_size     64k;
    proxy_temp_file_write_size  64k;    # 设置 worker 进程阻塞后台数据的时间，值越大，处理阻塞的时间约长

}
```

## 重写 cookie 的域和路径
```conf
server {
    server_name app.example.com;
    location /legacy1 {
        proxy_cookie_domain legacy1.example.com app.example.com;
        proxy_cookie_path   $uri    /legacy1$uri;
        proxy_redirect  default;
        proxy_pass  http://legacy1.example.com/;
    }

    location /legacy2 {
        proxy_cookie_domain legacy2.example.org app.example.com;
        proxy_cookie_path   $uri    /legacy2$uri;
        proxy_redirect default;
        proxy_pass  http://legacy2.example.org;
    }

    location / {
        proxy_pass  http://localhost:8080;
    }
}
```

## upstream 模块
该模块通常与 proxy 模块搭配使用，upstream 模块将会启用一个新的配置区段，在该区段定义一组上游服务器，这些服务器可以设置不同的权重，也可能是不同的类型(TCP 与 UNIX 域)，也可能出于需要对服务器进行维护，标记为 down;

```conf
http{
    upstream node {
        least_conn;          # 将默认的轮询(round-robin)负载算法切换为 least_conn（将请求发送到活跃连接数最少的那台服务器），与 ip_hash 不能同时使用
        ip_hash;             # 将负载算法切换为 ip_hash, 通过 IP 地址的 hash 值确保客户端均匀地连接所有服务器，键值基于 C 类地址
        server localhost:3000;
        server localhost:4000;
        server localhost:5000;

        keepalive 32;       # 指定 每一个 worker 进程缓存到上游服务器的连接数，在使用 HTTP 连接时，proxy_version 应该设置为 1.1，并且将 proxy_set_header 设置为 Connection ""，nginx将会为每一个 worker 打开 32 个握手连接，如果请求多于 32 个，nginx 会增加连接数，当请求少于 32 个连接数时，会保持 32 个连接
    }

    server{
        proxy_http_version  1.1;
        proxy_set_header    Connection "";
        proxy_pass          http://node;
    }
}

```

## 使用错误文件处理上游服务器问题
1.指定错误响应为本地磁盘的一个文件
```conf
server {
    error_page 500 502 503 504 /50x_error_handle;

    location = /50x_error_handle {
        root share/examples/nginx/html;
    }
}
```

2.指定错误响应由外部网站提供
```conf
server {
    proxy_intercept_errors  on;     # 由于错误码涵盖了大于等于 500 的错误码，需要设置该字段为 on，才能使得 nginx 也支持 error_page 指定 400 或更大的错误代码的转向
    error_page 500 502 503 504 /50x_error_handle;

    location = /50x_error_handle {
        proxy_pass http://www.example.com/error.html;
    }
}
```

3.将错误响应转发到后备服务器
```conf
upstream app {
    server 127.0.0.1:3000;
}

server {

    location  / {
        error_page 500 502 503 504 = @fallback;
        proxy_pass http://app;
    }

    location @fallback {
        proxy_pass http://127.0.0.1:8080;
    }
}
```

## 确定客户端真实 IP 地址
使用代理服务器时，客户端不能连接到上游服务器，因此上游服务器不能直接从客户端获取信息，通过下面的设置，将客户端 IP 地址传递给上游服务器
```conf
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;
```

## 反向代理服务器的性能调优
通常通过 缓冲、缓存和压缩 三个方面进行性能调优

## 缓冲
缓冲是最重要的性能考虑因素。在 nginx 将响应返回给客户端时，会尽可能快、尽可能多地从上游服务器尝试读取，代理会尽可能地将响应缓存在本地，以便一次性全部投递给客户，但是将来自于上游服务器的所有响应全部写到磁盘上，会降低性能。下面是缓冲的配置指令:

| 指令                    | 作用                                                                           |
| ----------------------- | ------------------------------------------------------------------------------ |
| proxy_buffer_size       | 设置缓存大小，该缓冲用与将上游服务器响应的第一部分缓冲到本地，该部分包含响应头 |
| proxy_buffering         | 设置是否启用代理内容缓冲，如果禁用，代理一收到内容后就同步发送给客户端         |
| proxy_buffers           | 设置用于响应上游服务器的缓冲数量和大小                                         |
| proxy_busy_buffers_size | 在从上游服务器读取响应时，该指令指定分配给发送客户端响应的缓冲空间大小         |

除了上面的指令，上游服务器设置 X-Accel-Buffering 头会影响缓冲，X-Accel-Buffering 头的默认值为 yes，意味着响应被缓冲，设置为 no，则对 Comet 和 HTTP 流应用程序有用；

proxy_buffers 指令的默认值(8 个 4KB 或 8 个 8KB，这依赖于具体的操作系统)能够接受一个大的并发连接数。

## 缓存数据
nginx 将上游服务的响应缓存起来，使得同样的请求不会再次返回到上游服务器。缓存配置指令如下：

| 指令                     | 作用                                                                                                                                                                             |
| ------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| proxy_cache              | 设置用与缓存的共享内存区域                                                                                                                                                       |
| proxy_cache_bypass       | 设置一个或者多个字符串变量，变量的值为非空或者非零将会导致响应从上游服务器获取而不是缓存                                                                                         |
| proxy_cache_key          | 设置缓存 key 的一个字符串，用与存储或者获取缓存值，可能会使用变量，避免缓存的同一个内容有多个副本                                                                                |
| proxy_cache_lock         | 开启这个指令，在一个缓存没有命中后将会阻止多个请求到上游服务器，这些请求将会等待第一个请求返回并且在缓存中写入 key, 这个锁时每个 worker 一个                                     |
| proxy_cache_lock_timeout | 设置等待一个请求将出现在缓存或者 proxy_cache_lock 指令释放的时间长度                                                                                                             |
| proxy_cache_min_uses     | 设置一个响应被缓存为一个 key 之前需要请求的最小词数                                                                                                                              |
| proxy_cache_use_stale    | 在访问上游服务器发生错误时，该参数指定在这种情况下接受提供过期的缓存数据，参数 updating 表示当数据刷新后再被载入                                                                 |
| proxy_cache_valid        | 该参数指定对 200、301 或者 302 有效响应代码缓存的时间长度，如果在时间参数前面给定一个可选的响应代码，那么将会仅对这个响应代码设置缓存时间，特定参数 any 表示对任何响应代码都缓存 |
| proxy_cache_path         | 该指令设置一个放置缓存响应和共享内存 zone (keys_zone=name:size) 的目录，用户存储活动的 key 和响应的元数据，可选参数如下六种：                                                    |

 - levels: 指定冒号用与分割在每个级别(1 或 2)的子目录长度，最多三级深
 - inactive: 指定在一个不活动的响应被驱除出缓存之前待在缓存中的最大时间长度
 - max_size: 指定缓存的最大值，当大小超过这个值时，缓存管理器金星村移除最近最少使用的缓存条目
 - loader_files：指定缓存的最大数量，它们的元数据被每个缓存载入进程迭代载入
 - loader_sleep: 指定每一个缓存载入进程的迭代之间停顿的毫米数
 - loader_threshold: 指定缓存载入进迭代花去时间的最大值

下面是一个模版配置

下面的配置设计缓存所有的响应为 6 个小时，缓存大小为 1 G，任何条目保持刷新，就是说，在 6 个小时内被调用为超时，有效期为 1 天，在次时间后，上游服务器将再次调哟哦牛鸽提供响应，如果上游服务器由于错误、超时、无效头或者是由于缓存条目被升级而无法响应，那么就会使用过期的缓存元素。共享内存区、CACHE 被定义为 10 MB，并且在 location 中使用，在这里设置缓存 key，并且也可以从这里查询。
同时 nginx 会在 /var/spool/设置一系列目录，nginx 将会首先区分 URI MD5 哈希值的最后一个字符，然后区分接下来的两个字符，直到最后一个，例如"/this-is-a-typical-url"响应被存储为 /var/spool/nginx/3/f1/614c16873c96c9db2090134be91cbf13
```conf
http {
    proxy_temp_path     /var/spool/nginx;
    proxy_cache_path    /var/spool/nginx   keys_zone=CACHE:10m levels=1:2 inactive=6h max_size=1g;

    server {
        location / {
            include proxy.conf;
            proxy_cache CACHE;
            proxy_cache_valid   any 1d;
            proxy_cache_use_stale error timeout invalid_header updating http_500 http_502 http_503 http_504;
            proxy_pass http://upstream;
        }
    }
}
```

## 压缩数据
nginx 将来自于上游服务器的响应在传递到客户端之前对其进行压缩，指令如下:

|指令|说明|
|---|---|
|gzip|on 表示开启压缩；off 表示禁用压缩|
|gzip_buffers|该指令用与压缩响应锁使用的缓冲数据和大小|
|gzip_comp_level|设置 gzip 压缩级别|
|gzip_disable|设置一个 User-Agents 的正则表达式，凡事符合该表达式的都禁用压缩，特定值 msie6 是 MSIE[4-6]\. 的简写|
|gzip_min_length|设置压缩响应的最小长度，只有当响应长度大于（content-length）改值时才启用压缩|
|gzip_http_version|当 http 高于该版本时启用压缩|
|gzip_proxied|如果请求通过了代理，该指令启用或禁用压缩功能，参数有:off、expired、no-cache、no-store、private、no_last_modified、no_etag、auth、any|
|gzip_types|除了默认的 text/html 外，该指令设置被压缩的 MIME 类型|
|gzip_vary|如果 gzip 是开启的，那么该指令启用或者禁用包含 Vary:Accept-Encoding 头的响应|

示例配置如下:
```conf
http {
    gzip on;
    gzip_min_length 1024;
    gzip_buffers 40 4k;
    gzip_comp_level 5;
    gzip_types text/plain application/x-javascript text/css text/html application/xml;
}
```