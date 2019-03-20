# git 介绍和基本使用

---
git 是一个免费的开源分布式版本控制系统，目的在于快速、高效的处理从小型到大型相关的相关事务

对于每次提交和更新、或在 git 中保存项目状态时，它会对当时的文件制作一个快照，并保存这个快照的索引，git 对待数据像是一个快照流。
其它版本控制系统(如svn)以文件变更列表的方式存储信息，它们将保存的信息看作是一组基本文件和每个文件随时间逐步积累的差异。

git 保存数据完整性。git 中所有数据在存储前都计算校验和，然后以校验和来索引，因此只要文件发生变动，校验和就会改变，所以文件的完整性是可以确定的。git 以 sha-1 哈希来计算校验和。

git 有三种状态：committed（已提交）、modified（已修改）和已暂存（staged）。committed 表示数据已保存在本地数据库中，modified 表示文件已修改，但是还没保存到数据库中，staged 表示对一个已修改的文件的当前版本做了标记，使之包含在下次提交的快照中。

## 设置和配置
安装完 git 后先设置用户名与邮件地址
```sh
git config --global user.name ""        # 设置全局用户名
git config --global user.email ""       # 设置全局邮箱

git config --system user.name ""        # 设置全局用户名
git config --system user.email ""       # 设置全局邮箱

git config --local user.name ""        # 设置全局用户名
git config --local user.email ""       # 设置全局邮箱

git config user.name            # 默认获取本地用户名
git config --list               # 列出所有 git 能找到的配置，可能会有重复的变量名，因为 git 会从不同的文件中读取同一个配置
                                # /etc/gitconfig 文件包含系统上每一个用户以及它们的相关配置
                                # ～/.gitconfig 或 ~/.config/git/config文件只针对当前用户
```

## 开始和创建工程
```sh
git init    # 在某个文件夹内执行 git init 初始化该目录
git clone   # clone 某个仓库到本地
```

## 基本使用
```sh
git status  # 查看当前状态
git add  [.|filename]   # 添加跟踪文件
git diff  [filename]  # 查看跟踪文件修改内容
git commit -n "" # 提交修改
git log     # 查看提交历史
git reset HRAD [filename]    # 撤销已经 add 的文件
git tag tagname     # 给当前状态打标签
git tag             # 列出所有 tag
git show tagname    # 显示标签详细信息
git tag -a tagname commithash   # 给已经提交的打标签
git config --global alias.co checkout   # 设置别名
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
```

## 分支
```sh
git branch branchname   # 创建分支
git checkout -b branchname originbranch # 给予远程分支 originbranch 创建分支 branchname
git branch              # 查看当前所有分支
git branch -r           # 查看远程所有分支
git checkout [branchname|hashNum] # 切换分支，或切换到某个提交的版本
git merge branchname    # 将 branchname 分支合并到当前分支
git branch -d branchname # 删除分支
git push origin --delete branchname # 删除远程分支  
git fetch origin        # 更新远程的更新到本地
git pull                # 更新远程分支到本地
```

## 变基
前提：同一个开发任务分叉到两个不同的分支，每个分支由各自提交了更新。使用 rebase 将某一个分支的修改都移到另一个分支上。
```sh
# 将 master 分支的修改合并到当前 experiment 上，experiment 当前修改的时间节点基于 master 最新的时间节点
git checkout experiment
git rebase master
```

## 工具

```sh
git show [hashNum]      # 显示某次提交详情
git show HEAD^          # 查看前一次提交
git show HEAD^^          # 查看前两次提交
git stash               # 暂存当前修改
git stash save          # 暂存当前修改
git stash list          # 查看所有暂存修改
git stash apply         # 使用最近的暂存
git stash apply stash{2}    # 使用指定暂存

git reset HEAD^         # 撤销上次提交
```