---
title: "SHELL 语法参考（一）"
author: "Kevin Wu"
date: "2016/10/21"
category: ["shell", "linux"]
---


## 变量

~~~
# 声明变量
name="tom"

# 使用变量
echo $name
echo ${name}

# 给变量重新赋值
name="john"
echo $name

# 只读变量
url="http://www.google.com/"
readonly url
url="http://www.apple.com/"

# 删除变量
url="http://www.google.com"
unset url
echo $url
~~~

## 字符串

字符串可以用单引号、双引号，也可以不用引号。单引号里的任何字符都会原样输出，不能出现单独的单引号，转义后也不行；双引号里可以使用变量、转义字符。

~~~
# 字符串拼接
echo "hello "$name"!"
echo "hello ${name}!"
echo 'hello '$name'!'
echo 'hello ${name}!'

# 字符串长度
len=${#name}
echo ${len}

# 提取子字符串
str=${name:1:2}
echo ${str}
~~~

## 数组

Shell 仅支持一维数组，并且没有限定数组大小，初始化时也不需要定义数组大小。

~~~
# 数组定义
names=(Andy Bob Louis)

# 用下标访问数组元素
echo ${names[0]}

# @ 或 * 作下标可以获取数组中的所有元素
echo ${names[@]}
echo ${names[*]}

# 获取数组长度
echo ${#names[@]}
echo ${#names[*]}

# 获取单个元素长度
echo ${#names[2]}

# 遍历数组中所有元素
for name in ${names[@]}; do
  echo ${name}
done
~~~

## 运算符

### 算术运算符

Shell 不支持简单的算术运算，但可以用 expr 或 awk 命令来实现，expr 是最常见的选择。expr 表达式的值和运算符之间要有空格，而乘法运算的符号要进行转义才能避免语法错误。

~~~
var=`expr $a + $b`  # 加 23
var=`expr $a - $b`  # 减 3
var=`expr $a \* $b` # 乘 130
var=`expr $a / $b`  # 除 1
var=`expr $a % $b`  # 模 3
~~~

### 关系运算符

关系运算只支持数字，不支持字符串，除非字符串的值是数字。

~~~
if [[ $a == $b ]]; then   # 相等
if [[ $a != $b ]]; then   # 不等
if [[ $a -eq $b ]]; then  # 相等
if [[ $a -ne $b ]]; then  # 不等
if [[ $a -gt $b ]]; then  # 大于
if [[ $a -lt $b ]]; then  # 小于
if [[ $a -ge $b ]]; then  # 大于等于
if [[ $a -le $b ]]; then  # 小于等于
~~~

### 字符串运算符

~~~
if [[ $a = $b ]]; then    # 值相同
if [[ $a != $b ]]; then   # 不相同
if [[ -z $a ]]; then      # 长度为0
if [[ -n $a ]]; then      # 长度非0
~~~

### 逻辑运算符

~~~
if [[ ! $a -gt 100 ]]; then               # 非
if [[ $a -lt 100 && $b -gt 100 ]]; then   # 且
if [[ $a -lt 100 || $b -gt 100 ]]; then   # 或
~~~

### 文件测试运算符

~~~
if [[ -b file ]]; then  # 块设备文件
if [[ -c file ]]; then  # 字符设备文件
if [[ -d file ]]; then  # 目录
if [[ -f file ]]; then  # 普通文件（非目录和设备文件）

if [[ -r file ]]; then  # 可读
if [[ -w file ]]; then  # 可写
if [[ -x file ]]; then  # 可执行

if [[ -s file ]]; then  # 文件大小大于 0
if [[ -e file ]]; then  # 文件或目录存在

if [[ -g file ]]; then  # 是否设置了 SGID 位
if [[ -u file ]]; then  # 是否设置了 SUID 位
if [[ -k file ]]; then  # 是否设置了粘着位（Sticky Bit）
if [[ -p file ]]; then  # 是否是有名管道
~~~
