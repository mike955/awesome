# docker 安装启动 gitlab

## 安装 gitlab
1. 启动镜像
```sh
docker run --detach \
    --hostname gitlab.example.com \
    --publish 4430:443 --publish 8000:80 --publish 2200:22 \
    --name gitlab \
    --restart always \
    --volume /Users/clx/dockerVolume/gitlab/config:/etc/gitlab \
    --volume /Users/clx/dockerVolume/gitlab/logs:/var/log/gitlab \
    --volume /Users/clx/dockerVolume/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest
```

2. 修改配置(修改配置后重启镜像)
修改/Users/clx/dockerVolume/gitlab/config/gitlab.rb文件
将
 external_url 值
修改为
 http://宿主机ip

3. 访问 8000 端口可以访问服务

## 安装 gitlab-runner

1. 启动 gitlab-runner 镜像
```sh
docker run -d --name gitlab-runner --restart always \
  -v /Users/clx/dockerVolume/gitlab-runner/config:/etc/gitlab-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  gitlab/gitlab-runner:latest
```

2.注册 runner
```sh
docker exec -it gitlab-runner gitlab-ci-multi-runner register
```
下面 json 为选项
```json
{
    "Please enter the gitlab-ci coordinator URL":"http://192.168.16.127:8000",
    "Please enter the gitlab-ci token for this runner":"MyP3qKbFp5zFK1z8rxkS",
    "Please enter the gitlab-ci description for this runner:":"test-runner",
    "Please enter the gitlab-ci tags for this runner (comma separated)":"clx",
    "Please enter the executor: parallels, ssh, kubernetes, docker, docker-ssh, shell, virtualbox, docker+machine, docker-ssh+machine":"docker",
    "Please enter the default Docker image (e.g. ruby:2.1)":"node"
}
```

3. 启动 runner

```sh
docker exec -it gitlab-runner gitlab-ci-multi-runner start
```