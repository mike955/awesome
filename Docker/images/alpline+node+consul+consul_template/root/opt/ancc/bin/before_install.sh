#!/bin/env bash

# mofify repository to aliyun
echo http://mirrors.aliyun.com/alpine/v3.8/main/ > /etc/apk/repositories
echo http://mirrors.aliyun.com/alpine/v3.8/community/ >> /etc/apk/repositories

apk update