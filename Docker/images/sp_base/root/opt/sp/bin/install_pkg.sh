#!/bin/bash

set -ex

yum --disableplugin=fastestmirror makecache

rpm --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

yum --disableplugin=fastestmirror install -y \
    cmake \
    pcre-devel \
    openssl-devel \
    make \
    gcc \
    gcc-c++ \
    curl \
    perl \
    python \
    python34 \
    vim \
    zip \
    unzip \
    wget \
    openssl-devel \
    net-tools \
    git \
    supervisor \
    tree \
    pcre-devel \
    readline-devel \

yum clean all
