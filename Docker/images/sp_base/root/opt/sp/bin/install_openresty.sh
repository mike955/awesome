#! /bin/bash
CD=$(pwd)
tempDir="$(mktemp -d)"
chmod 777 "$tempDir"
cd "$tempDir"

wget http://openresty.org/download/openresty-$OPENRESTY_VERSION.tar.gz \
    && tar -xvf openresty-$OPENRESTY_VERSION.tar.gz \
    && cd openresty-$OPENRESTY_VERSION \
    && ./configure \
        --with-luajit \
        --without-http_redis2_module \
        --with-http_iconv_module \
    && make && make install

cd $CD

if [ -n "$tempDir" ]; then
     rm -rf "$tempDir"
fi