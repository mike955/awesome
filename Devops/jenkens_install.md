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
docker run --name jenkins \
    --restart always \
    -p 8001:8080 \
    -p 50000:50000 \
    -v /root/dockerVolume/jenkins:/var/jenkins_home \
    -d jenkins
```