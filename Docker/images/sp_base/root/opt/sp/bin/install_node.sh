#!bin/bash

set -ex

DIST=https://npm.taobao.org/mirrors/node
ARCH=x64

curl -SLO "$DIST/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz"
curl -SLO --compressed "$DIST/v$NODE_VERSION/SHASUMS256.txt"
grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c -
tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner
rm -rf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt
ln -s /usr/local/bin/node /usr/local/bin/nodejs

npm set registry https://registry.npm.taobao.org
npm set disturl https://npm.taobao.org/dist
npm install -g pm2@2.10.3 --dd