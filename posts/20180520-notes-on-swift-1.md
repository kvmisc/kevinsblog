---
title: "Swift 笔记（一）：语言基础"
author: "Kevin Wu"
date: "2017/05/20"
category: ["swift"]
---


## 变量和常量

~~~
// 变量
var va = 5
// 常量
let vb = 5
~~~

## 数

~~~
// 类型推断（type inference），赋给变量的值是整数，推断 va 为整数类型
// 整数字面量的默认推断类型是 Int
var va = 5
// 类型注解（type annotation），显式地声明变量是整数类型
var vb: Int = 5
var vc: Int = "5" // 编译错误，虽然有类型注解，也不代表编译器不关注等号两边的真实类型

// 未初始化的变量
var va: Int
print(va) // 编译错误

// 不能给变量赋超出范围的值
var va: Int8 = 128 // 编译错误，Int8 的取值范围是 -128...127
var vb: UInt8 = -1 // 编译错误，UInt8 的取值范围是 0...255

// 转换整数类型
var va: Int16 = 200
var vb: Int8 = 50
var vc = va + vb // 编译错误，vb 不会隐式转换为 Int16，类型不同，不能相加
var vd: Int = va + Int16(vb) // 编译错误，两个 Int16 类型的运算结果不会隐式转换为 Int
var ve = va + Int16(vb) // ve 没有显式指定类型，这里应该推断出 ve 是 Int16 类型

// 转换以后超出取值范围的值不能赋值
var va: Int = 128
var vb: Int8 = Int8(va) // 运行时崩溃，Int8 的取值范围是 -128...127
var vc: Int = -1
var vd: UInt8 = UInt8(vc) // 运行时崩溃，UInt8 的取值范围是 0...255

// 不同整型能比较
var va: Int16 = 2
var vb: UInt8 = 2
print(va == vb) // true


// 浮点数有 32 位的 Float 和 64 位的 Double，它们的占位差异并不像整型一样影响最大值和最小值，而是影响精度
// 浮点数字面量的默认推断类型是 Double
// 不同浮点型不能比较
var va: Double = 1.1;
var vb: Float = 1.1;
print(va == vb) // 编译错误

// 判断浮点数是否相等不能直接比较，要用特殊方法
var va: Double = 1.1
print(va + 0.1 == 1.2) // false
~~~

## 字符串

~~~
// 字符串插值（string interpolation）
var va = "111"
var vb = 222
var vc = "va=\(va), vb=\(vb)"

// 遍历字符串的字符
var va = "111"
for chr: Character in va {
  print("'\(chr)'")
}

// 使用 Unicode 标量
var va = "\u{0061}\u{0301}" // 'a' + ' ́'
var vb = "\u{00E1}" // 'á'

// 标准等价
print(va == vb) // true

// 查看字符串中的 Unicode 标量
for scalar in va.unicodeScalars { // 97 769
  print("\(scalar.value)")
}
for scalar in vb.unicodeScalars { // 225
  print("\(scalar.value)")
}

// 字符串长度
print(va.count) // 1
print(vb.count) // 1

// 下标访问字符串
var va = "abcdef"
var start = va.startIndex
var idx = va.index(start, offsetBy: 2);
var vb = va[idx]
print(vb) // c
// 区间访问字符串
var va = "abcdef"
var start = va.startIndex
var idx = va.index(start, offsetBy: 2);
var range = start...idx
var vb = va[range]
print(vb) // abc
~~~

## 流程控制

### for 循环

~~~
for i in 0...5 {
  print(i)
}

// 忽略迭代器
for _ in 0...5 {
  print("111")
}

// 判断条件，相当于在循环内写一个 if 语句
for i in 0...5 where i % 2 == 0 {
  print(i)
}
~~~

### while 循环

~~~
var i = 0
while i < 6 {
  print(i)
  i += 1
}
~~~

### repeat-while 循环

~~~
// 就算条件为假，也会执行一次
var i = 0
repeat {
  print(i)
  i += 1
} while i < 6
~~~

### if 语句
~~~
if va < 0 {
  print("< 0")
}

if va < 0 {
  print("< 0")
} else {
  print(">= 0")
}

if va < 0 {
  print("< 0")
} else if va < 10 {
  print("< 10")
} else {
  print(">= 10")
}

// 当 switch 语句只有一个分支且不关心 default 分支时，可以用 if case 语句来优雅地替代 switch 语句
// if case 语句是具备强大模式匹配功能的 if 语句
// if case 语句是一种 if 语句，所以它也可以带有 else 块
// 下例是匹配区间，判断条件相当于 va>=0 && va<=10
if case 0...10 = va {
  print("0...10")
} else {
  print("other")
}
~~~

### switch 语句

~~~
// switch 语句必须全覆盖 
switch va {
case 1: print("1: \(va)")
case 2: print("2: \(va)")
case 3: print("3: \(va)")
default:
  print("other: \(va)")
}

// 值绑定
switch va {
case 1: print("1: \(va)")
case 2: print("2: \(va)")
case 3: print("3: \(va)")
case var vb: // var 可以换成 let；vb 的值会被设为 va；值绑定在这里并没有什么用，因为用 default 能达到同样的效果
  print("vb: \(vb) \(va)")
}

// 匹配
switch va {
case 0: print("0: \(va)") // 匹配单个值
case 1,2,3: print("1,2,3: \(va)") // 匹配多个值
case 4...9: print("4...9: \(va)") // 匹配区间
default:
  print("other: \(va)")
}
// 匹配元组
var va = (401, 401)
switch va {
case (404, 404): print("(404, 404)")
case (404, _): print("(404, _)")
case (_, 404): print("(_, 404)")
default:
  print("(other, other)")
}

// 筛选条件
// 第三个 case 和第四个 case 有重叠，当 va 等于 3 时，执行先匹配的 case
switch va {
case 1: print("1: \(va)")
case 2: print("2: \(va)")
case 3: print("3: \(va)")
case var vb where va>2 && va<10: print("vb: \(vb)")
default:
  print("other: \(va)")
}
~~~

### 控制转移语句

~~~
// 在 C 语言中，如果不在 switch 语句的每个 case 里包含 break 语句，当匹配到某个 case 后，会依次执行这个 case 后面的 case
// Swift 中正好相反，默认是不漏下去的，如果要漏下去，要在 case 里面用 fallthrough 语句
switch va {
case 1:
  print("1: \(va)")
  fallthrough
case 2:
  print("2: \(va)")
  fallthrough
case 3:
  print("3: \(va)")
default:
  print("other: \(va)")
}

// Swift 中 continue 和 break 的用法与 C 语言是一样的
~~~
