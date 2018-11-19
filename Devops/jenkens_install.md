# jenkins 安装脚本

centos
```sh
#!/bin/bash

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

sudo yum install jenkins

sudo service jenkins start
```

docker

```sh
# 查看容器 /var/jenkins_home 目录权限，
docker run -ti --rm --entrypoint="/bin/bash" jenkins -c "whoami && id"

# 修改本地映射权限
chown 1000 /root/dockerVolume/jenkins        # 1000 为容器 /var/jenkins_home 用户权限的 pid


docker run --name jenkins \
    --restart always \
    -p 8001:8080 \
    -p 50000:50000 \
    -v /root/dockerVolume/jenkins:/var/jenkins_home \
    -d jenkins:2.60.3
```