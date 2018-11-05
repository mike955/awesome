#!/bin/env bash

npm config set registry https://registry.npm.taobao.org --global
npm config set disturl https://npm.taobao.org/dist --global

cd /opt/ancc/webnode
npm install pm2 -g	
npm install
pm2 start
consul-template -consul-addr $CONSUL_CLUSTER -config "/opt/config/config.hcl"

while true; do
	echo 'run.sh: sleep'
	sleep 60
done