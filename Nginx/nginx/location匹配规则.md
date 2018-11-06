# location 匹配规则

location [=|~\~*|^~] /uri/{...}

| 模式                | 含义                                                       |
| ------------------- | ---------------------------------------------------------- |
| location = /uri/    | = 表示精确匹配，只有完全匹配才生效                         |
| location ^~ /uri    | ^~ 表示对 uri 进行前缀匹配，优先级高于正则匹配             |
| location ~pattern   | ～ 区分大小写的正则匹配                                    |
| location ~\_pattern | ～\_ 不区分大小写的正则匹配                                |
| location /uri       | 前缀匹配，优先级在正则匹配之后                             |
| location /          | 通用匹配，任何未匹配到其它 location 的请求都会匹配到该请求 |

## 优先级

(location =) > (location 完整路径) > (location ^~) > (location ~,~\* 正则匹配) > (location 部分起始路径) > (/)
