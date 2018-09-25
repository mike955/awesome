FROM registry.docker-cn.com/library/centos:7

ADD root/ /

ENV NODE_VERSION=10.9.0 \
    OPENRESTY_VERSION=1.13.6.2

RUN sh /opt/sp/bin/install_pkg.sh
RUN sh /opt/sp/bin/install_node.sh
RUN sh /opt/sp/bin/install_openresty.sh

