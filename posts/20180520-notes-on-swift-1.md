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
let va = 5
// 类型注解（type annotation），显式地声明变量是整数类型
let vb: Int = 5
let vc: Int = "5" // 出错，虽然有类型注解，也不代表编译器不关注等号两边的真实类型

// 未初始化的变量
let va: Int
print(va) // 出错

// 不能给变量赋超出范围的值
let va: Int8 = 128 // 出错，Int8 的取值范围是 -128...127
let vb: UInt8 = -1 // 出错，UInt8 的取值范围是 0...255

// 转换整数类型
let va: Int16 = 200
let vb: Int8 = 50
let vc = va + vb // vb 不会隐式转换为 Int16，类型不同，不能相加
let ddd: Int = aaa + Int16(bbb) // 出错，两个 Int16 类型的结果不会隐式转换为 Int
let eee = aaa + Int16(bbb) // 这里 eee 应该是 Int16 类型

// 转换以后超出取值范围的值不能赋值
let aaa: Int = 128
let bbb: Int8 = Int8(aaa) // 出错，Int8 的取值范围是 -128...127
let ccc: Int = -1
let ddd: UInt8 = UInt8(ccc) // 出错，UInt8 的取值范围是 0...255

// 不同整型能比较
let aaa: Int16 = 2
let bbb: UInt8 = 2
if aaa == bbb {
  print("aaa == bbb")
}


// 浮点数有 32 位的 Float 和 64 位的 Double，它们的占位差异并不像整型一样影响最大值和最小值，而是影响精度
// 浮点数字面量的默认推断类型是 Double
// 不同浮点型不能比较
let aaa: Double = 1.1;
let bbb: Float = 1.1;
if aaa == bbb { // 出错
  print("aaa == bbb")
}
// 浮点数比较要用特殊方法
let aaa: Double = 1.1
if aaa + 0.1 == 1.2 { // 不相等，不会打印
  print("aaa + 0.1 == 1.2")
}
~~~

## 字符串

~~~
// 字符串插值（string interpolation）
let aaa = "111"
let bbb = 222
let ccc = "aaa=\(aaa), bbb=\(bbb)"

// 遍历字符串的字符
let aaa = "111"
for c: Character in aaa {
  print("'\(c)'")
}

// 使用 Unicode 标量
let aaa = "\u{0061}\u{0301}" // 'a' + ' ́'
let bbb = "\u{00E1}" // 'á'

// 标准等价
let ccc = (aaa == bbb) // 为真

// 查看字符串中的 Unicode 标量
for scalar in aaa.unicodeScalars { // 97 769
  print("\(scalar.value)")
}
for scalar in bbb.unicodeScalars { // 225
  print("\(scalar.value)")
}

// 字符串长度
let ccc = aaa.count; // 1
let ddd = bbb.count; // 1

// 下标访问字符串
let aaa = "abcdef"
let start = aaa.startIndex
let idx = aaa.index(start, offsetBy: 2);
let bbb = aaa[idx]
print(bbb) // c

// 区间访问字符串
let aaa = "abcdef"
let start = aaa.startIndex
let idx = aaa.index(start, offsetBy: 2);
let range = start...idx
let bbb = aaa[range]
print(bbb)
~~~

## 流程控制

### for 循环

~~~
for i in 0...5 {
  print(i)
}

// 忽略迭代器
for _ in 0...5 {
  print("aaa")
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
if aaa < 0 {
  print("aaa < 0")
}

if aaa < 0 {
  print("aaa < 0")
} else {
  print("aaa >= 0")
}

if aaa < 0 {
  print("aaa < 0")
} else if aaa < 10 {
  print("aaa < 10")
} else {
  print("aaa >= 10")
}

// 当 switch 语句只有一个分支且不关心 default 分支时，可以用 if case 语句来优雅地替代 switch 语句
// if case 语句是具备强大模式匹配功能的 if 语句，所以 if case 语句也可以带有 else 块
// 下例是匹配区间，判断条件相当于 aaa>=0 && aaa<=10
if case 0...10 = aaa {
  print("0...10")
} else {
  print("other")
}
~~~

### switch 语句

~~~
// switch 语句必须全覆盖 
switch aaa {
case 1: print("1: \(aaa)")
case 2: print("2: \(aaa)")
case 3: print("3: \(aaa)")
default:
  print("other: \(aaa)")
}

// 值绑定
switch aaa {
case 1: print("1: \(aaa)")
case 2: print("2: \(aaa)")
case 3: print("3: \(aaa)")
case let bbb: // let 可以换成 var；bbb 的值会被设为 aaa，用 default 能达到同样的效果，值绑定在这里并没有什么用
  print("bbb: \(bbb) \(aaa)")
}

// 匹配
switch aaa {
case 0: print("0: \(aaa)") // 匹配单个值
case 1,2,3: print("1,2,3: \(aaa)") // 匹配多个值
case 4...9: print("4...9: \(aaa)") // 匹配区间
default:
  print("other: \(aaa)")
}
// 匹配元组
let aaa = (401, 401)
switch aaa {
case (404, 404): print("(404, 404)")
case (404, _): print("(404, _)")
case (_, 404): print("(_, 404)")
default:
  print("(other, other)")
}

// 筛选条件
// 第三个 case 和第四个 case 有重叠，当 aaa 等于 3 时，执行先匹配的 case
switch aaa {
case 1: print("1: \(aaa)")
case 2: print("2: \(aaa)")
case 3: print("3: \(aaa)")
case let bbb where aaa>2 && aaa<10: print("bbb: \(bbb)")
default:
  print("other: \(aaa)")
}
~~~

### 控制转移语句

~~~
// 在 C 语言中，如果不在 switch 语句的每个 case 里包含 break 语句，当匹配到某个 case 后，会依次执行这个 case 后面的 case
// swift 中正好相反，默认是不漏下去的，如果要漏下去，要在 case 里面用 fallthrough 语句
switch aaa {
case 1:
  print("1: \(aaa)")
  fallthrough
case 2:
  print("2: \(aaa)")
  fallthrough
case 3:
  print("3: \(aaa)")
default:
  print("other: \(aaa)")
}

// swift 中 continue 和 break 的用法与 C 语言是一样的
~~~
