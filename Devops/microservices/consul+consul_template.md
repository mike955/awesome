# consul

## 容器启动consul

```sh
docker run -d \
-p 8500:8500 \
-v /Users/clx/dockerVolume/consul:/consul/data \
-e CONSUL_CLIENT_INTERFACE='eth0' \
-e CONSUL_BIND_INTERFACE='eth0' \
consul agent -server -bootstrap-expect=1 -ui
```

## 编写模版文件

```ctmpl
# test.lua.ctmpl
return {
    secret = '{{ keyOrDefault "/test/session_auth_secret" "623q4hR325t36VsCD3g567922IC0073T" }}',
    storage = '{{ keyOrDefault "/test/session_auth_storage" "redis" }}',
    cookie = {
        secure = {{ keyOrDefault "/test/session_auth_cookie_secure" "false" }},
        httponly = {{ keyOrDefault "/test/session_auth_cookie_httponly" "true" }}
    }
}
```

## 启动 consul-template 来监听文件

```sh
consul-template -consul-addr 127.0.0.1:8500 -template "test.lua.ctmpl:test.lua:echo kkkkk" -once

# 上面的命令会通过 test.lua.ctmpl 模版生成 test.lua，然后输出 kkkkk

# -consul-addr 监听的 consul 地址
# -template 模版文件，上面命令中 该参数的值含义为 “模版文件：输出文件:执行脚本”
# -once 只执行一次
```

## 通过配置文件使用 consul-template

1. 编写配置文件 config.hcl
```hcl
consul {                    
  address = "127.0.0.1:8500"     // consul 监听地址
}

template {
  source = "/Users/clx/consul/test.lua.ctmpl"       // 模版文件地址
  destination = "/Users/clx/consul/test.lua"        // 模版文件输出地址
  command = "echo restart"                          // 文件生成后执行命令
}
```

2. 启动 consule-template

```sh
consul-template -config "config.hcl"
```

## consul-templata 命令
range 用户遍历 ervice/redis 目录下所有配置
```ctmpl
{{ range tree "service/redis" }}
{{ .Key }}:{{ .Value }}{{ end }}
```