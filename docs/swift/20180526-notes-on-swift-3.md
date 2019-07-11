---
title: "Swift 笔记（三）：函数和闭包"
author: "Kevin Wu"
date: "2018/05/26"
category: ["swift"]
---


## 函数

### 函数参数

~~~

// inout 参数
// 只能传变量给 inout 参数，不能传常量和字面量
// inout 参数不能有默认值
// 可变参数不能标记为 inout
func fh(name: String, error: inout String) {
  print("name: \(name)")
  error = "error occurred"
}
var err = ""
fh(name: "tony", error: &err)
print(err)

// 函数参数
func fi(budget: Int, condition: (Int) -> Bool) {
  if condition(budget) {
    print("111")
  } else {
    print("222")
  }
}
func fj(value: Int) -> Bool {
  return (value>10)
}
fi(budget: 8, condition: fj)
~~~

### 函数返回值

~~~
// 返回函数
func fc() -> (Int, Int) -> Int {
  func fd(a: Int, b: Int) -> Int {
    return (a+b)
  }
  return fd
}
var result: (Int, Int) -> Int = fc()
var value = result(1, 2)
print(value) // 3
~~~

### 嵌套函数

~~~
func fa() -> Int {
  var number = 3
  func fb() -> Int {
    return number * 2
  }
  return fb()
}
var result = fa()
print(result)
~~~

## 闭包

### 基本用法
~~~
// 全局函数是有名字但不会捕获任何值的闭包
// 嵌套函数是有名字并可以捕获其封闭函数域内值的闭包
// 闭包表达式是利用轻量级语法所写的可以捕获其上下文变量或常量值的匿名闭包

// 闭包表达式，一种构建内联闭包的方式，它的语法简洁
// 参数可以标记为 inout，但不能有默认值
// 元组可以作为参数和返回值
{ (parameters) -> returnType in
  // code
}

// 闭包表达式简化
// 数据准备
var va = [1, 3, 40, 32, 2, 53, 77, 13]

// 正常使用
va.sort(by: { (a: Int, b: Int) -> Bool in
  return (a < b)
})

// 使用类型推断，省略参数类型、返回类型
va.sort(by: { a, b in return a < b })

// 单表达式闭包的隐式返回
// 单行表达式闭包可以通过省略 return 关键字来隐式返回表达式的结果
va.sort(by: { a, b in a < b })

// 参数名称缩写
// Swift 自动为内联闭包提供参数名称缩写
va.sort(by: { $0<$1 })

// 运算符方法
// String 类型定义了小于符号的字符串实现，其作为一个函数接受两个 String 类型的参数并返回 Bool 值
va.sort(by: <)

// 尾随闭包，如果闭包是函数的最后一个参数，这闭包可以写在圆括号外，参数标签可以省略，如果函数只有一个参数，圆括号也可以省略
va.sort { $0<$1 }
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
