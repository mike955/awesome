1. 设置三台机器主机名， 然后 *重新登陆*
```sh
hostnamectl set-hostname kube-node1
```

```sh
hostnamectl set-hostname kube-node2
```

```sh
hostnamectl set-hostname kube-node3
```

2. 修改三台机器的 /etc/hosts 文件，修改内容如下
```sh
192.168.17.179 kube-node1 kube-node1
192.168.17.196 kube-node2 kube-node2
192.168.17.51 kube-node3 kube-node3
```
然后退出重新 ssh 登陆

3. 无密码 ssh 登录其它节点

```sh
ssh-keygen -t rsa
ssh-copy-id root@kube-node1
ssh-copy-id root@kube-node2
ssh-copy-id root@kube-node3

# ssh-copy-id k8s@kube-node1
# ssh-copy-id k8s@kube-node2
# ssh-copy-id k8s@kube-node3
```

4. 在每台机器上关闭防火墙

```sh
systemctl stop firewalld
systemctl disable firewalld
iptables -F && sudo iptables -X && sudo iptables -F -t nat && sudo iptables -X -t nat
iptables -P FORWARD ACCEPT
```

5. 修改 install/environment.sh 文件中机器 IP

6. 执行 install.sh 脚本