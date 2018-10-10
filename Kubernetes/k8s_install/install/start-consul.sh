#!/bin/sh

ROOT=$(cd `dirname $0`/../&&pwd)
BIN_DIR=/usr/local/bin

IP=$G_HOST_IP

pushd $ROOT/install/

sh docker_pull.sh consul:0.8.4

CMD="docker run -d --restart=always \$ENV --name=\$NAME --hostname=\$NAME consul:0.8.4 agent \
    -server -disable-host-node-id \
    -client=0.0.0.0 -bootstrap \$ARGS"

ENV="--net=host" && NAME="consul-1a" && ARGS="-bind=$IP -ui"
eval $CMD

popd
