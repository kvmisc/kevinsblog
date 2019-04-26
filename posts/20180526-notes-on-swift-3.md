---
title: "Swift 笔记（三）：函数和闭包"
author: "Kevin Wu"
date: "2017/05/26"
category: ["swift"]
---


## 函数

### 函数参数

~~~
// 无参数
func aaa() {
  print("111")
}
aaa()

// 有参数
func bbb(name: String) {
  print("name: \(name)")
}
bbb(name: "tony")

// label 参数
func ccc(label name: String) {
  print("name: \(name)")
}
ccc(label: "tony")

// 默认参数
func ddd(name: String = "unknown") {
  print("name: \(name)")
}
ddd()
ddd(name: "tony")

// inout 参数
func eee(name: String, error: inout String) {
  print("name: \(name)")
  error = "error occurred"
}
var err = ""
eee(name: "tony", error: &err)
print(err)

// 变长参数
func fff(names: String...) {
  for name in names {
    print(name)
  }
}
fff(names: "tony", "bill")

// 函数参数
func ggg(budget: Int, condition: (Int) -> Bool) {
  if condition(budget) {
    print("111")
  } else {
    print("222")
  }
}
func evaluate(value: Int) -> Bool {
  return (value>10)
}
ggg(budget: 8, condition: evaluate)
~~~

### 函数返回值

~~~
// 返回元组
func aaa() -> (ta: Int, tb: String) {
  return (404, "Not Found")
}
var result = aaa()
print("(\(result.ta), \(result.tb))") // (404, Not Found)

// 返回可空类型
func bbb() -> String? {
  return "blah blah"
}
var result = bbb()
print(result) // Optional("blah blah")

// 返回函数
func ccc() -> (Int, Int) -> Int {
  func ddd(a: Int, b: Int) -> Int {
    return (a+b)
  }
  return ddd
}
let result: (Int, Int) -> Int = ccc()
let value = result(1, 2)
print(value) // 3
~~~

### 嵌套函数

~~~
func aaa() -> Int {
  var number = 3

  func double() -> Int {
    return number * 2
  }

  return double()
}
var result = aaa()
print(result)
~~~

### guard 语句

~~~
func aaa(value: String?) {
  guard let name = value else {
    print("No Name")
    return
  }
  print("name: \(name)")
}
var name: String?
name = "tony"
aaa(value: name)
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
var aaa = [1, 3, 40, 32, 2, 53, 77, 13]
print(aaa)
// 使用闭包
aaa.sort(by: { (a: Int, b: Int) -> Bool in
  return (a<b)
})
print(aaa)
// 简化闭包，使用类型推断简化，省略参数类型、返回类型、return 关键字。
// 如果只有一个表达式，可以省略 return，如果有多个表达式，显式 return 是必需的
aaa.sort(by: { a, b in a<b })
print(aaa)
// 简化闭包
aaa.sort(by: { $0<$1 })
print(aaa)
// 简化闭包，如果闭包是函数的最后一个参数，这闭包可以在括号外内联
aaa.sort { $0<$1 }
print(aaa)
~~~

### 捕获变量

~~~
func aaa(count: Int) -> (Int) -> Int {
  var total = count
  func bbb(value: Int) -> Int {
    total += value
    return total
  }
  return bbb
}
var number1 = 100
let result1: (Int) -> Int = aaa(count: number1)
result1(1)
print(number1) // 100
number1 = result1(2)
print(number1) // 103

let result2 = result1
result2(3)
print(number1) // 103
number1 = result2(4)
print(number1) // 110

var number3 = 200
let result3: (Int) -> Int = aaa(count: number3)
result3(1)
print(number3) // 200
number3 = result3(2)
print(number3) // 203
~~~

### 高阶函数

~~~
// 转换（map）
let aaa = [8, 2, 5]
let bbb = aaa.map { (value: Int) -> Int in
  return (value*2)
}
print(bbb) // [16, 4, 10]

// 过滤（filter）
let aaa = [8, 2, 5]
let bbb = aaa.filter { (value: Int) -> Bool in
  return (value>=5)
}
print(bbb) // [8, 5]

// 累积（reduce）
let aaa = [8, 2, 5]
let bbb = aaa.reduce(0) { (result: Int, value: Int) -> Int in
  return (result+value)
}
print(bbb) // 15
~~~
