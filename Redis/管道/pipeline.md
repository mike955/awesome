## Pipeline

由于 redis 使用的是 TCP 连接，并且使用的是 C/S 模式，因此请求是阻塞的，通常的模式是 client 发送一次请求，然后线程挂起，等待响应结果，等待的时间被称为(Round Trip Time)，如果网络不好，这个时间会比较长。

Redis 中能够实现 request/response server，client 在前一个的响应未到达之前继续向 server 发送多个请求，无需等待每次响应结果，client 最后只需要一次读取最后的响应即可。这在 redis 中被称为 pipeline。 

**注意:**当客户端使用 pipeline 发送命令时，server 将会强制使用内存对回复进行排队，因此，如果需要使用 pipeline 发送大量请求时，最好是每次发送合理数量的请求，例如 10k 命令，读取回复，然后再次发送另外10k命令，依此类推。速度几乎相同，但使用的额外内存将最多为排队 10k 命令的回复所需的数量。

如果使用场景是 client 需要操作每次 response，那么 pipeline 将会不适用用，因为 pipeline 只会在最后返回一个结果。