---
title: "Swift 笔记（三）：函数和闭包"
author: "Kevin Wu"
date: "2018/05/26"
category: ["swift"]
---


## 函数

### 函数参数

### 函数返回值

### 嵌套函数




## 闭包

### 基本用法
~~~
// 闭包表达式，一种构建内联闭包的方式，它的语法简洁
// 参数可以标记为 inout，但不能有默认值
// 元组可以作为参数和返回值
{ (parameters) -> returnType in
  // code
}
~~~

### 捕获变量

~~~
// 上面已经讲到嵌套函数其实是一种闭包，嵌套函数可以捕获其外部函数所有的参数以及定义的常量和变量
func fa(count: Int) -> (Int) -> Int {
  var total = count
  func fb(value: Int) -> Int {
    total += value
    return total
  }
  return fb
}
var va = 100
var ffa = fa(count: va)
ffa(1) // va=100 total=101
va = ffa(2) // va=103 total=103
var ffb = ffa // 闭包是引用类型，ffb 和 ffa 指向同一个闭包
ffb(3) // va=103 total=106
va = ffb(4) // va=110 total=110

var vc = 200
var ffc = fa(count: vc)
ffc(1) // vc=200 total=201
vc = ffc(2) // vc=203 total=203
~~~

### 逃逸闭包

~~~
// TODO: 加深对逃逸闭包的理解

// 当闭包作为参数传到函数但调用却在函数返回之后时，我们称该闭包从函数中逃逸


var CompletionHandlers: [() -> Void] = []

func FunctionWithEscapingClosure(handler: @escaping () -> Void) {
  CompletionHandlers.append(handler) // 将参数中的闭包保存到全局数组中，如果不加 @escaping 则会编译错误
}

func FunctionWithNonescapingClosure(handler: () -> Void) {
  handler() // 直接执行闭包
}

class SomeClass {
  var x = 10
  func doSomething() {
    FunctionWithEscapingClosure { self.x = 100 } // 逃逸闭包要显式地引用 self
    FunctionWithNonescapingClosure { x = 200 }
  }
}

var instance = SomeClass()
instance.doSomething()
print(instance.x) // 200

CompletionHandlers.first?()
print(instance.x) // 100
~~~

### 自动闭包

~~~
// TODO: 加深对自动闭包的理解
~~~

### 高阶函数

~~~
// 转换（map）
var va = [8, 2, 5]
var vb = va.map { (value: Int) -> Int in
  return (value * 2)
}
print(vb) // [16, 4, 10]

// 过滤（filter）
var va = [8, 2, 5]
var vb = va.filter { (value: Int) -> Bool in
  return (value >= 5)
}
print(vb) // [8, 5]

// 累积（reduce）
var va = [8, 2, 5]
var vb = va.reduce(0) { (result: Int, value: Int) -> Int in
  return (result + value)
}
print(vb) // 15
~~~
