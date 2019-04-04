title : Shell 参考
author : Kevin Wu
date : 2016/10/21
categories : ["linux", "shell"]


## 数组

    # 数组定义
    names=(Andy Bob Louis)
    
    # 遍历数组中所有元素
    for name in ${names[@]}; do
      echo ${name}
    done
    
    # 用下标访问数组元素
    echo ${names[0]}
    
    # @作下标可以获取数组中的所有元素
    echo ${names[@]}
    
    # 获取数组长度
    echo ${#names[@]}
    echo ${#names[*]}
    
    # 获取单个元素长度
    echo ${#names[1]}

## 运算符

    # 变量定义
    a="10"
    b=10
    
    # 算术运算符
    val=`expr $a + $b`  # 加
    val=`expr $a - $b`  # 减
    val=`expr $a \* $b` # 乘
    val=`expr $a / $b`  # 除
    val=`expr $a % $b`  # 取模
    
    # 关系运算符，只支持数字，不支持字符串，除非字符串的值是数字
    if [[ $a -eq $b ]]; then  # 相等
    if [[ $a -ne $b ]]; then  # 不等
    if [[ $a -gt $b ]]; then  # 大于
    if [[ $a -lt $b ]]; then  # 小于
    if [[ $a -ge $b ]]; then  # 大于等于
    if [[ $a -le $b ]]; then  # 小于等于
    
    # 逻辑运算符
    if [[ $a -lt 100 && $b -gt 100 ]]; then   # 且
    if [[ $a -lt 100 || $b -gt 100 ]]; then   # 或
    
    # 字符串运算符
    if [[ $a = $b ]]; then    # 值相同
    if [[ $a != $b ]]; then   # 不相同
    if [[ -z $a ]]; then      # 长度为0
    if [[ -n $a ]]; then      # 长度非0
    
    # 文件测试运算符
    if [[ -b file ]]; then  # 块设备文件
    if [[ -c file ]]; then  # 字符设备文件
    if [[ -d file ]]; then  # 目录
    if [[ -f file ]]; then  # 普通文件（非目录和设备文件）
    
    if [[ -r file ]]; then  # 可读
    if [[ -w file ]]; then  # 可写
    if [[ -x file ]]; then  # 可执行
    
    if [[ -s file ]]; then  # 文件非空
    if [[ -e file ]]; then  # 文件或目录存在

## 参数

    $# 参数个数（不包括脚本名）
    $$ 当前进程号
    $! 后台运行的最后一个进程号
    $? 最后命令的退出状态
    $* 引用所有参数，被双引号括起来时传递一个参数
    $@ 引用所有参数，被双引号括起来时传递n个参数

## 流程控制

    # if 语句
    if [[ $a -gt $b ]]; then
      xxx
    fi
    
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
    
    
    # for 语句
    
    # 提供值集合
    for skill in Ada Coffe Action Java; do
      echo "I am good at ${skill}Script."
    done
    
    # 遍历目录
    #   1)仅文件名 `ls blog`
    #   2)相对路径 blog/*
    #   3)某类文件 blog/*.html
    for file in `ls /etc`; do
      echo ${file}
    done
    
    
    # while 语句
    it=1
    while (( $it<=5 )); do
      echo $it
      let "it++"
    done
    
    
    # case 语句
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
    esac
    
    
    # 无限循环
    while :; do
      xxx
    done
    
    while true; do
      xxx
    done
    
    for (( ; ; )); do
      xxx
    done
