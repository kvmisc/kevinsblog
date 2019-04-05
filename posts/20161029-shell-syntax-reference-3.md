---
title: "Shell 语法参考（三）"
author: "Kevin Wu"
date: "2016/10/29"
category: ["shell", "linux"]
---


## 脚本参数

  * `$0` 脚本文件名；
  * `$1` 第一个参数；
  * `$#` 参数个数（不包括脚本名）；
  * `$$` 脚本运行的当前进程 ID 号；
  * `$!` 后台运行的最后一个进程 ID 号；
  * `$?` 最后命令的退出状态；
  * `$-` 显示 Shell 使用的当前选项，与 set 命令功能相同；
  * `$*` 引用所有参数，被双引号括起来时传递 "1 2 3"（一个参数）；
  * `$@` 引用所有参数，被双引号括起来时传递 "1" "2" "3"（三个参数）。

~~~
for name in "$*"; do
  echo ${name}
done
# 1 2 3

for name in "$@"; do
  echo ${name}
done
# 1
# 2
# 3
~~~

## 文件包含

文件包含可以使用两种方式：`source filename` 或 `. filename`。

~~~
# defines.sh file
#!/bin/bash
url="http://www.google.com/"

# test.sh file
#!/bin/bash
source defines.sh
echo "Site is: ${url}"
~~~

## 重定向

### 输出重定向

~~~
# 输出重定向到文件，覆盖文件内容
command >file

# 输出重定向到文件，追加到文件末尾
command >>file

# 错误输出重定向到文件
command 2>file
command 2>>file
~~~

### 输入重定向

~~~
# 输入重定向为文件
command <file

# 同时将输入和输出重定向
command <infile >outfile

# 将输出和错误输出合并后重定向
command >file 2>&1
command >>file 2>&1
~~~

### Here Document

Here Document 是 Shell 中一种特殊的重定向方式，用来将输入重定向到一个交互式 Shell 脚本或程序。

~~~
command <<delimiter
  document
delimiter
~~~

开始 delimiter 前后的空格会被忽略掉，结尾 delimiter 一定要顶格写，前面不能有任何字符，后面也不能有任何字符。

~~~
cat >/etc/xxx.conf <<EOF
aaaa bbbb
cccc
EOF
~~~

### /dev/null 文件

/dev/null 是一个特殊的文件，写入到它的内容都会被丢弃。如果尝试从该文件读取内容，那么什么也读不到。如果希望执行某个命令，但又不希望在屏幕上显示输出结果，那么可以将输出重定向到 /dev/null。

~~~
command >/dev/null
~~~
