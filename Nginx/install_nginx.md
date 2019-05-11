# 手动编译安装nginx

```sh
#!/bin/bash
PATH=$(cd `dirname $0`; pwd)

wget http://nginx.org/download/nginx-1.15.10.tar.gz

tar zxvf nginx-1.15.10.tar.gz -C /usr/local/src

mkdir -p /usr/local/src/nginx-1.15.10/modules
cd /usr/local/src/nginx-1.15.10/modules

wget https://nchc.dl.sourceforge.net/project/pcre/pcre2/10.32/pcre2-10.32.tar.gz
tar zxvf pcre2-10.32.tar.gz
wget https://jaist.dl.sourceforge.net/project/libpng/zlib/1.2.11/zlib-1.2.11.tar.gz
tar zxvf zlib-1.2.11.tar.gz
wget https://www.openssl.org/source/old/1.1.1/openssl-1.1.1.tar.gz
tar zxvf openssl-1.1.1.tar.gz
wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz
tar zxvf LuaJIT-2.0.5.tar.gz
git clone https://github.com/simplresty/ngx_devel_kit.git
git clone https://github.com/openresty/lua-nginx-module.git

cd /usr/local/src/nginx-1.15.10/

export LUAJIT_LIB=/usr/local/luajit/lib
export LUAJIT_INC=/usr/local/luajit/include/luajit-2.0

./configure \
  --prefix=/usr/local/nginx \
  --sbin-path=/usr/local/nginx/sbin/nginx \
  --with-http_ssl_module \
  --with-http_v2_module \
  --with-http_realip_module \
  --with-http_addition_module \
  --with-http_xslt_module \
  --with-http_image_filter_module \
  --with-http_geoip_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_gunzip_module \
  --with-http_gzip_static_module \
  --with-http_auth_request_module \
  --with-http_random_index_module \
  --with-http_secure_link_module \
  --with-http_degradation_module \
  --with-http_slice_module \
  --with-http_stub_status_module \
  --with-mail \
  --with-mail_ssl_module \
  --with-stream \
  --with-stream_ssl_module \
  --with-stream_realip_module \
  --with-stream_geoip_module \
  --with-stream_ssl_preread_module \
  --with-compat \
  --with-pcre \
  --with-zlib=/usr/local/src/nginx-1.15.10/modules/zlib-1.2.11 \
  --with-openssl=/usr/local/src/nginx-1.15.10/modules/openssl-1.1.1 \
  --with-ld-opt="-Wl,-rpath,/usr/local/luajit/lib" \
  --add-module=/usr/local/src/nginx-1.15.10/modules/ngx_devel_kit-0.3.1rc1 \
  --add-module=/usr/local/src/nginx-1.15.10/modules/lua-nginx-module-0.10.13 \
  --add-dynamic-module=/usr/local/nginx
 # --without-http_charset_module \
 # --without-http_gzip_module \
 # --without-http_ssi_module \
 # --without-http_userid_module \
 # --without-http_access_module \
 # --without-http_auth_basic_module \
 # --without-http_mirror_module \
 # --without-http_autoindex_module \
 # --without-http_geo_module \
 # --without-http_map_module \
 # --without-http_split_clients_module \
 # --without-http_referer_module \
 # --without-http_rewrite_module \
 # --without-http_proxy_module \
 # --without-http_fastcgi_module \
 # --without-http_uwsgi_module \
 # --without-http_scgi_module \
 # --without-http_grpc_module \
 # --without-http_memcached_module \
 # --without-http_limit_conn_module \
 # --without-http_limit_req_module \
 # --without-http_empty_gif_module \
 # --without-http_browser_module \
 # --without-http_upstream_hash_module \
 # --without-http_upstream_ip_hash_module \
 # --without-http_upstream_least_conn_module \
 # --without-http_upstream_keepalive_module \
 # --without-http_upstream_zone_module \
 # --with-http_perl_module \
 # --with-ld-opt="-Wl,-E" \
 # --with-http_perl_module=dynamic \
 # --with-perl_modules_path=path \
 # --with-perl=path \
 # --http-log-path=path \
 # --http-client-body-temp-path=path \
 # --http-proxy-temp-path=path \
 # --http-fastcgi-temp-path=path \
 # --http-uwsgi-temp-path=path \
 # --http-scgi-temp-path=path \
 # --without-http \
 # --without-http-cache \
 # --with-mail \
 # --with-mail=dynamic \
 # --with-mail_ssl_module \
 # --without-mail_pop3_module \
 # --without-mail_imap_module \
 # --without-mail_smtp_module \
 # --with-stream \
 # --with-stream=dynamic \
 # --with-stream_ssl_module \
 # --with-stream_realip_module \
 # --with-stream_geoip_module
 # --with-stream_ssl_preread_module \
 # --without-stream_limit_conn_module \
 # --without-stream_access_module \
 # --without-stream_geo_module \
 # --without-stream_map_module \
 # --without-stream_split_clients_module \
 # --without-stream_return_module \
 # --without-stream_upstream_hash_module \
 # --without-stream_upstream_least_conn_module \
 # --without-stream_upstream_zone_module \
#  --with-google_perftools_module \
#  --with-cpp_test_module \
 # --add-module=path \
 # --add-dynamic-module=path \
#  --with-compat \
#  --with-cc=path \
#  --with-cpp=path \
#  --with-cc-opt=parameters \
#  --with-ld-opt=parameters \
#  --with-cpu-opt=cpu \
#  --without-pcre \
#  --with-pcre \
#  --with-pcre=/usr/local/src/nginx-1.15.10/modules/pcre2-10.32 \
#  --with-pcre-opt=parameters \
#  --with-pcre-jit \
#  --with-zlib=/usr/local/src/nginx-1.15.10/modules/zlib-1.2.11 \
#  --with-zlib-opt=parameters \
#  --with-zlib-asm=cpu \
#  --with-libatomic \
#  --with-libatomic=path \
#  --with-openssl=/usr/local/src/nginx-1.15.10/modules/openssl-1.1.1 \
#  --with-luajit \
#  --with-openssl-opt=parameters \
#  --with-debug

```
