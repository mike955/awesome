# nginx配置为静态文件服务器

1.nginx.conf添加配置文件
```conf
server {
        listen 8002;
        server_name localhost;
        root /data/file;
        autoindex on;             #开启索引功能
        autoindex_exact_size on; # 关闭计算文件确切大小（单位bytes），只显示大概大小（单位kb、mb、gb）
        autoindex_localtime on;   # 显示本机时间而非 GMT 时间
    }
```

2.浏览器打开 nginx_ip:8002 可以看见 /data/file 目录下面的所有文件