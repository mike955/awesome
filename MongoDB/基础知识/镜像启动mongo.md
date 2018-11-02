## 运行 mongo 镜像
```sh
docker run --name mongo \
    --restart always \
    -v /Users/clx/dockerVolume/mongodb/data:/data/db \
    -v /Users/clx/dockerVolume/mongodb/etc:/etc/mongo \
    -p 27017:27017 \
    -d mongo:4
```

创建用户并授权

```mongoshell
db.createUser({
  user: "mongo",
  pwd: "mongo",
  roles: [{
     role: "userAdminAnyDatabase", 
     db: "admin"
  }]
})
```
