# RPC

 * rpc(Remote Proceduce Call远程过程调用协议)是一个计算机通信协议，该协议允许运行与一台计算机的程序调用另一台计算机的子程序，程序员无需额外地为这个交互作用编程
 * rpc 最核心要解决的问题就是在分布式系统间，如何执行另外一个地址空间上的函数、方法、就像在本地调用一样
 * rpc 远程调用使用 C/S模式，请求程序是一个 Client。服务程序是一个 Serve，远程过程调用是同步操作，在调用远程程序时，当前请求会暂停，等待返回结果
 * rpc 通信基于 TCP、UDP、HTTP等，通常基于 TCP
 * rpc 跨越传输层和应用层
 * rpc 调用协议包括传输协议与编码协议，传输协议扮包括 http 等，编码协议包括 protobuf 等