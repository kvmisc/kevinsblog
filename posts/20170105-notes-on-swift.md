---
title: "Swift 笔记：函数"
author: "Kevin Wu"
date: "2017/01/05"
category: ["swift"]
---


## 参数

### 忽略参数标签

~~~
func foo(_ name: String) {
  print(name)
}
////////////////////////////////////////
foo("aaa")
foo(name: "bbb")  // 编译错误
~~~

### 参数默认值

~~~
func foo(a: Int, b: Int = 2, c: Int = 3) {
  print(a + b + c)
}
////////////////////////////////////////
foo(a:1, b:2, c:3)
foo(a:1, c:3)
foo(a:1, c:3, b:2)  // 编译错误
~~~

### 可变参数

一个函数最多只能拥有一个可变参数。

~~~
func average(_ numbers: Double...) -> Double {
  var total: Double = 0
  for it in numbers {
    total += it
  }
  return total / Double(numbers.count)
}
~~~

### 输入输出参数

  * 函数参数默认是常量，试图在函数体中更改参数值将会导致编译错误；
  * 输入输出参数不能接受常量或字面量；
  * 输入输出参数不能有默认值
  * 输入输出参数不能标记可变参数；

~~~
func swap(_ a: inout Int, _ b: inout Int)
{
  let tmp = a
  a = b
  b = tmp
}
~~~

### 函数类型参数

~~~
func add(_ a: Int, _ b: Int) -> Int {
  return a+b
}

func perform(_ algorithm: (Int,Int)->Int, _ a: Int, _ b: Int) {
  let result = algorithm(a, b)
  print("result is: \(result)")
}

////////////////////////////////////////
perform(add, 1, 2)
~~~

## 返回值

### 隐式返回值

如果函数的整个函数体是一个单行表达式，这个函数可以隐式地返回这个表达式。任何可以被写成一行 `return` 语句的函数都可以忽略 `return`。

~~~
// TODO: 在编译器中，这个隐式返回会编译错误，为何？
func foo() -> Int {
  1 + 1
}

func bar() -> Int {
  return 1 + 1
}
~~~

### 函数类型返回值

~~~
func forward(_ input: Int) -> Int {
  return input + 1
}
func hold(_ input: Int) -> Int {
  return input
}
func backward(_ input: Int) -> Int {
  return input - 1
}

func chooseMoveMethod(direction: Int) -> (Int)->Int {
  if direction>0 {
    return forward
  } else if direction<0 {
    return backward
  }
  return hold
}

////////////////////////////////////////
let move = chooseMoveMethod(direction: -2)
print(move(5))
~~~

## 嵌套函数

~~~
func chooseMoveMethod(direction: Int) -> (Int)->Int {

  func forward(_ input: Int) -> Int {
    return input + 1
  }
  func hold(_ input: Int) -> Int {
    return input
  }
  func backward(_ input: Int) -> Int {
    return input - 1
  }

  if direction>0 {
    return forward
  } else if direction<0 {
    return backward
  }
  return hold
}

////////////////////////////////////////
let move = chooseMoveMethod(direction: -2)
print(move(5))
~~~
