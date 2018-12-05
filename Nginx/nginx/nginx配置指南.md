# nginx 配置文件解释

<!-- TOC -->

- [nginx 配置文件解释](#nginx-%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E8%A7%A3%E9%87%8A)
    - [配置文件结构](#%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E7%BB%93%E6%9E%84)
    - [示例配置文件](#%E7%A4%BA%E4%BE%8B%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6)
    - [配置注意点](#%E9%85%8D%E7%BD%AE%E6%B3%A8%E6%84%8F%E7%82%B9)


## 配置文件结构
```conf
events {    # General connection processing

}

http {      # http traffice handle
    upstream upstream_name {
        
    }

    server {
        listen
        server_name

        location {

        }
    }
}

mail {      # mail traffice handle
    server {}
}

stream {    # tcp and udp traffice handle
    server {}
}
```

## 示例配置文件
```conf
env NAMESPACE
 # 使用的用户和组，默认为 nobody，fork 出的 worker 进程运行在哪个用户和用户组下
user  www www;
# 指定工作衍生进程数, 通常为 cpu 个数
worker_processes  2;
# 指定 master 进程的 pid 存放的路径，默认可不配
pid /var/run/nginx.pid;

# [ debug | info | notice | warn | error | crit ]
# 可以在下方直接使用 [ debug | info | notice | warn | error | crit ]  参数
error_log  /var/log/nginx.error_log  info;  # 错误日志等级和日志存放地方

events {
    # 允许的连接数
    connections   2000;     # 允许连接的最大连接数,可以使用`ulimit -n`查看操作系统支持的最大连接数
    # use [ kqueue | rtsig | epoll | /dev/poll | select | poll ] ;
    # 具体内容查看 http://wiki.codemongers.com/事件模型
    use kqueue;
}

http {
    include       conf/mime.types;
    default_type  application/octet-stream;
    access_log   /var/log/nginx.access_log  main;   # 设置请求日志文件地址
    log_format main      '$remote_addr - $remote_user [$time_local]  '
    '"$request" $status $bytes_sent '
    '"$http_referer" "$http_user_agent" '
    '"$gzip_ratio"';

    log_format download  '$remote_addr - $remote_user [$time_local]  '
    '"$request" $status $bytes_sent '
    '"$http_referer" "$http_user_agent" '
    '"$http_range" "$sent_http_content_range"';

    client_header_timeout  3m;      # 设置读取整个客户端头的超时时间
    client_body_timeout    3m;      # 设置客户端成功读取的两个操作之间的时间间隔
    send_timeout           3m;      # 设置向客户端传输数据的超时时间

    client_header_buffer_size    1k;    # 设置客户端请求头缓存大小，默认为 1kb
    large_client_header_buffers  4 4k;  # 设置最大数量和最大客户端请求头的大小

    # gzip 支持在线实时压缩输出数据流
    gzip             on;            # 是否开启压缩数据流，默认为 off    
    gzip_vary        on;            # 如果 gzip 是活动的，那么盖指令启用或者警用包括 Vary:Accept-Encoding 头的响应     
    gzip_min_length  1100;          # 设置允许压缩的页面最小字节数，从 header 的 content-length 中获取，只有当 content-length 大于该数值时才会启动压缩，默认为 0，建议设置成 1k，小于 1k 可能会约压越大
    gzip_buffers     4 8k;          # 设置几倍的单位大小申请缓存，实例配置表示以 8k 为单位 4 倍申请内存
    gzip_types        text/plain application/x-javascript text/css text/html application/xml;    # 需要压缩的数据类型，配合`include conf/mime.types;` 配置使用
    gzip_comp_level     6;          # 设置压缩比，压缩比约越大，处理越慢，但是传输越快
    gzip_proxied    any;            # nginx 用作反向代理的时候启用，any表示无条件启用
    gzip_disable    "msie6";        # 指定客户端禁用 gzip 功能，设置成 ie6 或更低版本

    output_buffers   1 32k;
    postpone_output  1460;

    sendfile         on;    # 设置可以启用 linux 上的 sendfile 系统调用来发送文件，减少了内核态与用户态之间的两次内存复制，这样就会从磁盘中读取文件后直接在内核态发送到网卡设备，提高了发生文件的效率
    tcp_nopush       on;
    tcp_nodelay      on;
    send_lowat       12000;

    keepalive_timeout  75 20;       # 指定 keep-alive 持续时长，第二个参数(可选)在响应头中设置 keepalive 头

    #lingering_time     30;
    #lingering_timeout  10;
    #reset_timedout_connection  on;


    server {
        listen        one.example.com;  # 指定当前 server 的监听地址和端口号，默认值为 80，也可以为 localhost:80、127.0.0.1:80、*:8000、8000，通常该配置只配置端口号，`server_name`配置域名或 ip
        server_name   one.example.com  www.one.example.com;     # 服务的名字，可以为域名或者 ip，常用

        limit_rate_after;    # 设置向客户端发送的响应长度超过 limit_rate_after 后才开始限速
        limit_rate  10M;     # 限制客户端请求限制每秒传输的字节数

        location / {            # 设置某类请求
            proxy_pass         http://127.0.0.1/;           # 设置请求转发地址
            proxy_redirect     off;                         # 是否对发送给客户端的 url 进行修改，即是否对代理的服务器返回的地址进行重定向，可以指定重定向地址：`proxy_redirect http://localhost:8000/two/ http://frontend/one/;`

            proxy_set_header   Host             $host;      # 设置或添加发往后段服务器的地址头
            proxy_set_header   X-Real-IP        $remote_addr;   # 设置或添加发往后段服务器的地址头
            #proxy_set_header  X-Forwarded-For  $proxy_add_x_forwarded_for;

            client_max_body_size       10m;
            client_body_buffer_size    128k;

            client_body_temp_path      /var/nginx/client_body_temp;

            proxy_connect_timeout      90;
            proxy_send_timeout         90;
            proxy_read_timeout         90;
            proxy_send_lowat           12000;

            proxy_buffer_size          4k;
            proxy_buffers              4 32k;
            proxy_busy_buffers_size    64k;
            proxy_temp_file_write_size 64k;

            proxy_temp_path            /var/nginx/proxy_temp;

            charset  koi8-r;
        }

        error_page  404  /404.html;

        location /404.html {
            root  /spool/www;

            charset         on;
            source_charset  koi8-r;
        }

        location /old_stuff/ {
            rewrite   ^/old_stuff/(.*)$  /new_stuff/$1  permanent;
        }

        location /download/ {

        valid_referers  none  blocked  server_names  *.example.com;

        if ($invalid_referer) {
        #rewrite   ^/   http://www.example.com/;
            return   403;
        }

    #rewrite_log  on;

    # rewrite /download/*/mp3/*.any_ext to /download/*/mp3/*.mp3
        rewrite ^/(download/.*)/mp3/(.*)\..*$
        /$1/mp3/$2.mp3                   break;

        root         /spool/www;
    #autoindex    on;
        access_log   /var/log/nginx-download.access_log  download;
        }

        location ~* ^.+\.(jpg|jpeg|gif)$ {
            root         /spool/www;
            access_log   off;
            expires      30d;
        }
    }
}
```

## 配置注意点

 - 每行配置的结尾需要加上分号
 - 如果配置项中包括语法符号，比如空格符，需要使用单引号或者双引号括住配置项值，否则 nginx 会报错
 - 配置想单位，空间大小默认为**字节**，时间单位默认为**毫秒**
    - 指定空间大小时，k 或者 K 表示千字节，m 或者 M 表示兆字节
    - 指定时间时，ms(毫秒)、s(秒)、m(分钟)、h(小时)、d(天)、w(周，7 天)、M(月，30天)、y(年，365)
 - 在配置相中使用变量时需要在前面加上 $ 符号