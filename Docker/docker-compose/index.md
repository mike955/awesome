# Docker-compose

compose 是一个工具用来声明和运行多个 docker 应用，你能够使用 yaml 文件去配置一个应用服务，运行这个配置文件去开始定义的服务，应用是 docker 层级的，而服务是由多个应用组成的，compose 用来定义个运行服务。

compose 使用有三步:
 - 通过 Dockerfile 来定义应用的运行环境
 - 通过 docker-compose.yaml 文件来定义服务
 - 通过 `docker-compose up` 命令来启动服务