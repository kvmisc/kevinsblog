---
title: "《Swift 编程权威指南》笔记（三）：函数和闭包"
author: "Kevin Wu"
date: "2017/05/26"
category: ["swift"]
---


## 函数

### 函数参数

~~~
// 无参数
func fa() {
  print("111")
}
fa()

// 有参数
func fb(name: String) {
  print("name: \(name)")
}
fb(name: "tony")

// label 参数
func fc(label name: String) {
  print("name: \(name)")
}
fc(label: "tony")

// 默认参数
func fd(name: String = "unknown") {
  print("name: \(name)")
}
fd()
fd(name: "tony")

// inout 参数
func fe(name: String, error: inout String) {
  print("name: \(name)")
  error = "error occurred"
}
var err = ""
fe(name: "tony", error: &err)
print(err)

// 变长参数
func ff(names: String...) {
  for name in names {
    print(name)
  }
}
ff(names: "tony", "bill")

// 函数参数
func fg(budget: Int, condition: (Int) -> Bool) {
  if condition(budget) {
    print("111")
  } else {
    print("222")
  }
}
func fh(value: Int) -> Bool {
  return (value>10)
}
fg(budget: 8, condition: fh)
~~~

### 函数返回值

~~~
// 返回元组
func fa() -> (ta: Int, tb: String) {
  return (404, "Not Found")
}
var result = fa()
print("(\(result.ta), \(result.tb))") // (404, Not Found)

// 返回可空类型
func fb() -> String? {
  return "blah blah"
}
var result = fb()
print(result) // Optional("blah blah")

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
// 闭包语法
{ (parameters) -> returnType in
  // code
}

// 闭包用法
// 数据准备
var va = [1, 3, 40, 32, 2, 53, 77, 13]
// 使用闭包
va.sort(by: { (a: Int, b: Int) -> Bool in
  return (a<b)
})
// 简化闭包，使用类型推断简化，省略参数类型、返回类型、return 关键字。
// 如果只有一个表达式，可以省略 return，如果有多个表达式，显式 return 是必需的
va.sort(by: { a, b in a<b })
// 简化闭包
va.sort(by: { $0<$1 })
// 简化闭包，如果闭包是函数的最后一个参数，这闭包可以在括号外内联
va.sort { $0<$1 }
~~~

### 捕获变量

~~~
// TODO: 书中为何要在讲解闭包的章节用嵌套函数来讲解变量捕获？
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
var ffb = ffa
ffb(3) // va=103 total=106
va = ffb(4) // va=110 total=110

var vc = 200
var ffc = fa(count: vc)
ffc(1) // vc=200 total=201
vc = ffc(2) // vc=203 total=203
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
