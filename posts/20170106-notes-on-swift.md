---
title: "Swift 笔记：闭包"
author: "Kevin Wu"
date: "2017/01/06"
category: ["swift"]
---


## 闭包表达式

闭包有三种形式：

  * 全局函数，有名字但不捕获任何值的闭包；
  * 嵌套函数，有名字并可以捕获其封闭函数域内值的闭包；
  * 闭包表达式，利用轻量级语法所写的可以捕获其上下文变量或常量值的匿名闭包；

~~~
// 完整形式
names.sorted(by: { (s1:String,s2:String)->Bool in return s1<s2 } )

// 利用上下文推断参数和返回值类型
names.sorted(by: { s1,s2 in return s1<s2 } )

// 单行表达式闭包隐式返回
names.sorted(by: { s1,s2 in s1<s2 } )

// 参数名称缩写
names.sorted(by: { $0<$1 } )

// 运算符方法
names.sorted(by: < )

// 尾随闭包
names.sorted { $0<$1 }
~~~
