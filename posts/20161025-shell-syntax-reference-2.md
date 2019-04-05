---
title: "SHELL 语法参考（二）"
author: "Kevin Wu"
date: "2016/10/25"
category: ["shell", "linux"]
---


## 流程控制

### if 语句

~~~
if [[ $a -gt $b ]]; then
  xxx
fi

if [[ $a -gt $b ]]; then xxx; fi

if [[ $a -gt $b ]]; then
  xxx
else
  yyy
fi

if [[ $a -gt $b ]]; then
  xxx
elif [[ $a -lt $b ]]; then
  yyy
else
  zzz
fi
~~~

### for 语句

~~~
# 遍历值集合
for var in item1 item2 item3; do
  echo ${var}
done

# 遍历目录：`ls blog`、blog/*、blog/*.html
for file in `ls /etc`; do
  echo ${file}
done
~~~

### while 语句

~~~
it=0
while [[ $it -lt 5 ]]; do
  echo $it
  let "it++"
done
~~~

### untile 语句

until 循环执行一系列命令直至条件为 true 才停止，它与 while 循环的处理方式刚好相反，一般 while 循环优于 until 循环，但在某些极少数情况下，until 循环更加有用。

~~~
it=0
until [[ ! $it -lt 5 ]]; do
  echo $it
  it=`expr $it + 1`
done
~~~

### case 语句

~~~
type="bb"
case $type in
  aa)
    echo "aas"
  ;;
  bb)
    echo "bbs"
  ;;
  cc)
    echo "ccs"
  ;;
  *)
    echo "**s"
  ;;
esac
~~~

### 无限循环

~~~
while true; do
  xxx
done

while :; do
  xxx
done

for (( ; ; )); do
  xxx
done
~~~

### 跳出循环

~~~
# break 跳过所有循环
while true; do
  echo -n "Enter number between 1-5:"
  read num
  case $num in
    1|2|3|4|5)
      echo "The number is: $num"
    ;;
    *)
      echo "Game Over"
      break
    ;;
  esac
done

# continue 跳过本次循环
while true; do
  echo -n "Enter number between 1-5:"
  read num
  case $num in
    1|2|3|4|5)
      echo "The number is: $num"
    ;;
    *)
      continue
      echo "Game Over"
    ;;
  esac
done
~~~

## 函数

  * `$#` 参数个数（不包括函数名）；
  * `$$` 脚本运行的当前进程 ID 号；
  * `$!` 后台运行的最后一个进程 ID 号；
  * `$?` 最后命令的退出状态；
  * `$-` 显示 Shell 使用的当前选项，与 set 命令功能相同；
  * `$*` 引用所有参数，被双引号括起来时传递 "1 2 3"（一个参数）；
  * `$@` 引用所有参数，被双引号括起来时传递 "1" "2" "3"（三个参数）。

~~~
function func1() {
  echo "in func1"
  # 无 return 语句，将以最后一条命令运行结果作为返回值
}

func2() {
  echo "in func2"
  return 101
}

func3() {
  echo "arg1: $1"
  echo "arg2: $2"
  echo "arg3: $3"
}

func1
echo "return code: $?"

func2
echo "return code: $?"

func3 1 2 3 4 5
echo "return code: $?"
~~~
