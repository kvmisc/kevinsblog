---
title: "Git 参考"
author: "Kevin Wu"
date: "2015/01/20"
category: ["git"]
---



## 配置

~~~
# 列出已有的配置值，后边的值会覆盖前面的值
git config -l

# 设置 ~/.gitconfig 文件中的用户名字段
git config --global user.name "xxx"

# 设置 .git/config 中的邮箱字段
git config --local user.email "xxx"

# 设置 git 记住密码
git config --global credential.helper cache
git config --global credential.helper "cache --timeout=3600"
~~~

## 分支

~~~
# 查看各个分支最后一次提交信息
git branch -v

# 通过远程分支新建本地分支，并且跟踪远程分支，本地分支名称和远程分支名称相同
git checkout --track origin/xxx
# 通过远程分支新建本地分支，并且跟踪远程分支，本地分支名称由参数指定
git checkout -b xxx origin/yyy

# 上传分支到服务器上同名分支
git push origin xxx
# 上传分支到服务器另外一分支
git push origin xxx:yyy

# 删除远程分支
git push origin :xxx
~~~

## 标签

~~~
# 显示标签
git tag
# 查看标签的版本信息
git show xxx

# 创建含附注的标签
git tag -a xxx -m "Release xxx"
# 创建轻量级标签
git tag xxx
# 后期从早先某次提交创建标签
git tag -a xxx 9fceb02

# 上传指定标签到服务器
git push origin xxx
# 上传所有标签到服务器
git push origin --tags

# 删除标签
git tag -d xxx
# 删除远程标签
git push origin :refs/tags/xxx
~~~

## 远程库

~~~
# 添加远程仓库
git remote add xxx git://github.com/aaa/bbb.git

# 用字串 xxx 指代对应的仓库地址，抓取所有远程仓库有的，但本地仓库没有的信息
git fetch xxx

# 列出每个远程库
git remote -v
# 查看远程仓库信息
git remote show xxx

# 远程仓库改名
git remote rename xxx yyy

# 远程仓库删除
git remote rm xxx
~~~

## 临时存储

~~~
# 添加临时存储
git stash

# 查看临时存储列表
git stash list

# 应用但保留栈顶的临时存储
git stash apply
# 应用且删除栈顶的临时存储
git stash pop

# 删除栈顶的临时存储
git stash drop

# 用临时存储创建新分支，且删除临时存储
git stash branch xxx
~~~

## 其它

~~~
# 工作目录和暂存区域的差异
git diff
# 暂存区域和上次提交的差异
git diff --staged
# 查看 ff34043 与 c5ca2d9 的差异
git diff ff34043 c5ca2d9
# 查看未提交的变更
git diff HEAD
# 查看 xxx 文件自 c5ca2d9 以后的变更
git diff c5ca2d9 xxx


# 删除之前修改过并且已经放到暂存区域的文件
git rm -f xxx
# 移除跟踪但不删除文件
git rm --cached xxx

# 每个提交用一行显示
git log --pretty=oneline
# 输出简短且唯一的 SHA-1 缩写
git log --abbrev-commit
# 显示两分支公共结点（不包括）到 yyy 顶端的提交信息
git log xxx..yyy

# 查看 HEAD 和分支引用日志
git reflog
~~~
