#一次完整的http请求


#### 一些基本概念
1.TCP/IP: 把与互联网相关联的协议集合起来的总称
2.HTTP是TCP/IP的一个子集
3.TCP/IP分为四层

 - 应用层： HTTP、FTP、DNS服务
 - 传输层： TCP、UPD
 - 网络层： 处理网络上流动的数据包，数据包是网络传输的最小数据单位
 - 链路层(数据链路层、网络链路层)：  处理连接网络的硬件部分

#### 一次完整的HTTP请求流程
**1.客户端通过DNS服务得到目标IP**
**2.HTTP协议：生成针对目标web服务器的HTTP请求**
**3.TCP协议：将HTTP请求报文分割成报文段，按序号分为多个报文段，把每个报文段可靠的传给对方**
**4.IP协议：搜索对方地址一边中转一边传送**
**5.服务器TCP协议：将接受到的报文按顺序组成报文**
**6.服务器HTTP协议：对web服务器请求的内容进行处理**



#### 看下图
![这里写图片描述](http.jpg)