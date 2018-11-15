# nginx 内置变量解释及实例

# 内置变量说明

| 参数                   | 含义                                                                                       |
| ---------------------- | ------------------------------------------------------------------------------------------ |
| \$arg_name             | 请求中的 name 参数                                                                         |
| \$args                 | 请求中的参数                                                                               |
| \$binary_remote_addr   | 远程地址的二进制表示                                                                       |
| \$body_bytes_sent      | 以发送的消息体字节数                                                                       |
| \$content_length       | http 请求信息里的 "content-length"                                                         |
| \$content_type         | 请求信息里的 "content-type"                                                                |
| \$document_root        | 针对当前请求的根路径设置值                                                                 |
| \$document_uri         | 与 \$uri 相同；比如 /test2/test.php                                                        |
| \$host                 | 请求信息中的 "host", 如果请求忠没有 Host 行，则等于设置的服务器名                          |
| \$hostname             | 机器名使用 gethostname 系统调用的值                                                        |
| \$http_cookie          | cookie 信息                                                                                |
| \$http_referer         | 引用地址                                                                                   |
| \$http_user_agent      | 客户端代理信息                                                                             |
| \$http_via             | 最后一个访问服务器的 ip 地址                                                               |
| \$http_x_forwarded_for | 相当网络访问路径                                                                           |
| \$is_args              | 如果请求行待有参数，返回"?"，否则返回空字符串                                              |
| \$limit_rate           | 对连接速率的限制                                                                           |
| \$nginx_version        | 当前运行的 nginx 版本号                                                                    |
| \$pid                  | work 进程的 pid                                                                            |
| \$realpath_root        | 按 root 指令或 alias 指令算出的当前请求的绝对路径，其中的符号链接都会解析成真实文件路径    |
| \$remote_addr          | 客户端 ip 地址                                                                             |
| \$remote_port          | 客户端端口号                                                                               |
| \$remote_user          | 客户端用户名，认证用                                                                       |
| \$request              | 用户请求                                                                                   |
| \$request_body         | 这个变量包含请求的主要信息，在使用 proxy_pass 活 fastcgi_pass 指令的 location 中比较有意义 |
| \$request_body_file    | 客户端请求主体信息的临时文件                                                               |
| \$request_completion   | 如果请求成功，设置为"OK",如果请求未完成或者不是一系列请求中最后一部分则设为空              |
| \$request_filename     | 当前请求的文件路径名，比如 /opt/nginx/www/test.php                                         |
| \$request_method       | 请求方法,比如"GET"、"POST"等                                                               |
| \$request_uri          | 请求的 URI，带参数                                                                         |
| \$scheme               | 所用的协议，比如 http 或者是 https                                                         |
| \$server_addr          | 服务器地址，如果没有用 listen 指明服务器，使用这个变量将发起一次系统调用以取得地址         |
| \$server_name          | 请求到达的服务器名                                                                         |
| \$server_port          | 请求到达的服务器端口号                                                                     |
| \$server_protool       | 请求的协议版本, "HTTP/1.0"或"HTTP/1.1"                                                     |
| \$uri                  | 请求的 URI，可能和最初的值有不同，比如经过重定向之类的                                     |

## 以制定配置文件启动 nginx 实例

```sh
docker run --name nginx \
    -v /root/dockerVolume/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
    -p 8080:8080 \
    -d nginx:1.15
```
