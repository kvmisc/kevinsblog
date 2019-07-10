---
title: "Swift 笔记（一）：语言基础"
author: "Kevin Wu"
date: "2018/05/20"
category: ["swift"]
---


## 变量和常量

全局或局部存储变量为特定类型的值提供存储空间，并允许读取和写入，存储变量能定义观察者。另外，在全局和局部范围内还可以定义计算变量，计算变量返回一个计算结果而不存储值。

全局的变量和常量都是惰性的，但不需要标记为 lazy。局部范围的变量和常量从不延迟计算。

~~~
// 全局或局部存储变量
var va = 5, vb = 5.0, vc = "111"
// 全局或局部存储常量
let vd = 5

// 全局或局部计算变量
var va: Int {
  return (2 * 2)
}
print("va: \(va)")


// 观察全局或局部存储变量
var va = 0 {
  willSet { print("WillSet: \(newValue)") }
  didSet { print("DidSet: \(oldValue)") }
}
va = 1
va = 2
~~~

## 运算符

## 数

## 字符串


## 流程控制

### 循环语句

### 条件语句

~~~
// 当 switch 语句只有一个分支且不关心 default 分支时，可以用 if case 语句来优雅地替代 switch 语句
// if case 语句是具备强大模式匹配功能的 if 语句
// if case 语句是一种 if 语句，所以它也可以带有 else 块
if case 0...10 = va {
  print("0...10")
} else {
  print("other")
}
~~~

### 控制转移语句

~~~

// Swift 中 continue 和 break 的用法与 C 语言是一样的
// 给 if 或 switch 语句添加标签，可以用 break 加标签来指定跳出哪个条件语句
// 给循环语句添加标签，可以用 break 或 continue 加标签来指定跳出哪个循环语句
la: for i in 1...5 {
  for j in 1...5 {
    print("\(i) \(j)")
    if i + j > 6 {
      break la
    }
  }
}
~~~

### guard 语句

