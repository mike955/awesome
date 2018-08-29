# NVM 方式安装 Node.js

安装脚本
```sh
#!bin/bash

### node_install.sh
v=

while getopts "v:V:" arg
do
    case $arg in
        v)
            v=$OPTARG;;
        V)
            v=$OPTARG;;
        *)
            echo 'usage:sh build.sh -v x.x.x.x'
            exit;;
    esac
done

wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install v$v
```

使用方式

```sh
sh node_install.sh -v 10
```