FROM node:10.13.0-alpine

# node version
# ENV NODE_version=10.13.0
# consul version
ENV CONSUL_VERSION=1.3.0
# consul location
ENV HASHICORP_RELEASES=https://releases.hashicorp.com
# consul server address
ENV CONSUL_CLUSTER='192.168.16.127:8500'
ADD bin/consul-template /usr/local/bin
ADD root/ /

RUN sh /opt/ancc/bin/before_install.sh
RUN sh /opt/ancc/bin/after_install.sh

WORKDIR /opt/ancc

ENTRYPOINT [ "sh","/opt/ancc/bin/run.sh" ]
