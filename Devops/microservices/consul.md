# consul 简介

---
consul 是一个服务管理工具，提供服务发现、配置和 segmentation functionality 功能化管理平台，这些功能既可以单独使用，也可以一起使用，consul 需要数据平面支持代理和本机集成模型，consul 还福袋一个简单的内置代理工具，也支持第三方代理，consul 同时也是也分布式、高可用的系统。

consul 主要特征如下：
 - 服务发现: consul client 能够向 service 通过 mysql 或 api 注册服务，其他 client 通过 DNS 或 HTTP 来获取服务信息。
 - 健康检查: consul client 能够提供提供任意数量的健康检查，这些健康检查可以与给定的服务关联，也可以与本地节点相关联。
 - 键值存储: 应用程序可以 将 consul 的分层键/值存储用于任何用途，包括动态配置等，值可以是任何类型的数据，包括 json 等，与 consul-template 搭配起来使用更加好。
 - 保证服务通信安全: consul 可以为服务生成和分发 TLS 证书，以建立相互的 TLS 连接。
 - 多数据中心: consul 支持多数据中心

## consul 术语

 - agent: 一个 agent 是 consul 集群中每个成员上长时间运行的守护程序，通过`consul agent`来启动一个 agent，agent 能够以 client 或 server 模型运行，由于所有的节点都必须运行 agent，因此将 节点成为 client 或 server 更易于理解，所有的 agent 都可以运行 DNS 或 HTTP 接口，并负责运行检查并保持服务同步。
 - client: client 将所有的 RPC 转发到 服务器的代理，client 是无状态的
 - server: server 是一个具有扩展能力的 agent，server 需要参与 raft 仲裁、维护集群状态、相应 RPC 查询、与其他数据中心交换 WAN gossip、将查询转发给 leader 或远程数据中心。

## 基本使用

安装 consul 后，必须运行一个 agent，agent 能够以 client 或 server 方式运行，每个数据中心至少要有一个 server，建议使用 3-5 个 master，如果 server 出现故障，数据可能丢失，因此不建议单个 server 部署。
其他的 agent 都以 client 的方式运行，client 方式运行是一个非常轻量级的进程，它注册服务、进行健康检查，并将查询服务转发给 server，每个节点都必须运行一个 agent。