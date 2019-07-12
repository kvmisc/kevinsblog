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

## 值捕获

~~~
func makeIncrementer(increment: Int) -> ()->Int {
  var runningTotal = 0

  func incrementer() -> Int {
    runningTotal += increment
    return runningTotal
  }

  return incrementer
}
////////////////////////////////////////
let incrementByOne = makeIncrementer(increment: 1)
print(incrementByOne())
print(incrementByOne())

let incrementByTen = makeIncrementer(increment: 10)
print(incrementByTen())
print(incrementByTen())

print(incrementByOne())
print(incrementByTen())
~~~

## 逃逸闭包

当闭包作为参数传到函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸。常用于函数发起异步操作，操作完成后调用闭包进行回调。

闭包会强引用它捕获的所有对象，如果闭包中访问了当前对象中的任意属性或实例方法，闭包会持有当前对象，因为这些属性和方法都隐性地携带了 self 参数，这种方式很容易导致循环引用。然而，非逃逸闭包不会产生循环引用，编译器可以保证函数返回时闭包会释放它捕获的所有对象。因此，编译器只要求在逃逸闭包中明确对 self 的强引用，这能使程序员注意到潜在的循环引用。

## 自动闭包

TODO: 加深理解
