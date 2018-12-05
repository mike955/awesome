## nginx 配置 mysql 负载均衡

```conf
worker_processes  1;
error_log  /var/log/nginx.error_log  debug;
events {
    worker_connections  1024;
}

stream {
  upstream mysql {
    server 192.168.16.182:13301 max_fails=2 fail_timeout=30s;
    server 192.168.16.182:13302 max_fails=2 fail_timeout=30s;
    zone tcp_mem 64k;
    least_conn;
  }

  server {
    listen 8001;
    proxy_timeout 2s;
    proxy_pass mysql;
    health_check interval=20 fails=1 passes=2;
  }
}
```