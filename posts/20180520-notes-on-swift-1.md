---
title: "《Swift 编程权威指南》笔记（一）：语言基础"
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

~~~
// 赋值运算符并不返回值，这能避免将 == 写成 =
if va = 111 {} // 编译错误

// 对负数求余时，负号会被忽略
print(9 % 4) // 1
print(9 % -4) // 1

// 比较元组
print( (1, "zebra") < (2, "apple") ) // true
print( (2, "apple") < (2, "bird") ) // true
print( (3, "dog") == (3, "dog") ) // true
print( ("blue", false) < ("purple", true) ) // 编译错误，布尔值不能比较

// 闭区间
1...5 // 1 到 5
// 半开区间
// TODO: 在起点前后添加大于或小于都会编译错误，那么不包括起点的半开区间怎么写？
1..<5 // 1 到 4
// 单侧区间，不能遍历没有初始值的单侧区间，因为起点不知道
1... // 1 到无穷大
...1 // 无穷小到 1
// 半开单侧区间
..<5 // 无穷小到 4
~~~

## 数

~~~
// 类型推断（type inference），赋给变量的值是整数，推断 va 为整数类型
// 整数字面量的默认推断类型是 Int
var va = 5
// 类型注解（type annotation），显式地声明变量是整数类型
var vb: Int = 5
var vc: Int = "5" // 编译错误，虽然有类型注解，也不代表编译器不关注等号两边的真实类型

// 查看数的范围
print(Int8.min) // -128
print(Int8.max) // 127

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
// 多行字符串
var va = """
111
222
"""
// 开始符号之后和结束符号之前没换行符号，下面两个字符串是一样的
var vb = "111"
var vc = """
111
"""
// 换行，方便阅读，但不会在字符串里真正加上换行
var vd = """
111 \
222
"""
// 缩进，为了让编码美观，结束符号前的空格会被认为是缩进，并不会真正加入到字符串
var ve = """
   111
  222
  """

// 不解析转义字符
var va = #"111\n222"#
print(va) // 111\n222

// 字符串插值（string interpolation）
var va = "111"
var vb = 222
var vc = "va=\(va), vb=\(vb)"

// 字符类型
var va = "1" // va 是 String 类型
var vb: Character = "2" // vb 是 Character 类型；用单引号声明字符类型会编译错误；双引号里多于 1 个字符会编译错误

// 遍历字符串的字符
var va = "111"
for chr in va {
  print("'\(chr)'")
}

// 使用 Unicode 标量
var va = "\u{0061}\u{0301}" // 'a' + ' ́'
var vb = "\u{00E1}" // 'á'

// 标准等价
print(va == vb) // true

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
var vb = va[range] // 这里 vb 的类型是 SubSequence
print(vb) // abc

// 子字符串（上例中的 SubSequence）
// 在改变 vb 之前，vb 不会分配内存，而是使用 va 的内存空间，修改 vb 的时候系统为 vb 分配单独的空间
var idx = va.index(after: va.startIndex)
vb.remove(at: idx)
print(va) // abcdef
print(vb) // ac
~~~

## 流程控制

### 循环语句

~~~
// for 循环
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

// 跳过中间值
for i in stride(from: 0, to: 60, by: 5) {
  print(i)
}


// while 循环
var i = 0
while i < 6 {
  print(i)
  i += 1
}

// repeat-while 循环，就算条件为假，也会执行一次
var i = 0
repeat {
  print(i)
  i += 1
} while i < 6
~~~

### 条件语句

~~~
// if 语句
if va < 0 {
  print("< 0")
}

// if else 用法
if va < 0 {
  print("< 0")
} else {
  print(">= 0")
}

// if else if else 用法
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
if case 0...10 = va {
  print("0...10")
} else {
  print("other")
}

// 检查 API 可用性
if #available(iOS 10.0.1, macOS 10.1, tvOS 10, watchOS 10, *) {
  // 当前系统高于 xx 版本，调用从 xx 版本开始支持的 API
} else {
  // 使用旧版本的 API
}


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

~~~
// guard 条件不满足的时候，else 里的语句必须能退出 guard 语句所在的代码段，可以用 return、break、
// continue 或 throw 做这件事，或者调用一个不返回的函数，例如 fatalError()
// 相比于能实现同样功能的 if 语句，guard 语句能增加代码的可读性
// TODO: 加深对 guard 语句的理解
func fa(value: String?) {
  guard var name = value else {
    // 在这个区域不能使用 name 变量
    return // 这里必须要跳出这个代码段，如果 guard 语句在一个花括号中，应该是必须跳出那个花括号
  }
  print("name: \(name)")
}
var name: String?
name = "tony"
fa(value: name)
~~~
