---
title: "从 Objective-C 到 Swift"
author: "Kevin Wu"
date: "2017/05/20"
category: ["swift"]
---


## 变量和常量

~~~
// 变量
var aaa = 5
// 常量
let aaa = 5
~~~

## 数

~~~
// 类型推断（type inference），赋给变量的值是整数，推断 aaa 为整数类型
// 整数字面量的默认推断类型是 Int
let aaa = 5
// 类型注解（type annotation），显式地声明变量是整数类型
let aaa: Int = 5
let aaa: Int = "5" // 出错，虽然有类型注解，也不代表编译器不关注等号两边的真实类型

// 未初始化的变量
let aaa: Int
print(aaa) // 出错

// 不能给变量赋超出范围的值
let aaa: Int8 = 128 // 出错，Int8 的取值范围是 -128...127
let aaa: UInt8 = -1 // 出错，UInt8 的取值范围是 0...255

// 转换整数类型
let aaa: Int16 = 200
let bbb: Int8 = 50
//let ccc = aaa + bbb // 出错，bbb 不会隐式转换为 Int16，类型不同，不能相加
//let ccc: Int = aaa + Int16(bbb) // 出错，两个 Int16 类型的结果不会隐式转换为 Int
let ccc = aaa + Int16(bbb) // 这里 ccc 应该是 Int16 类型

// 负数不能转换为无符号整型
let aaa: Int = -1
let bbb: UInt8 = UInt8(aaa) // 出错

// 转换以后超出取值范围的值不能赋值
let aaa: Int = 256
let bbb: UInt8 = UInt8(aaa)

// 不同整型能比较
let aaa: Int16 = 2
let bbb: UInt8 = 2
if aaa == bbb {
  print("aaa == bbb")
}


// 浮点数有 32 位的 Float 和 64 位的 Double，它们的长度差异并不像整型一样影响最大值和最小值，而是影响精度
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

## 运算符

~~~
// 比较运算符
<   计算左边的值是否小于右边的值
<=  计算左边的值是否小于等于右边的值
>   计算左边的值是否大于右边的值
>=  计算左边的值是否大于等于右边的值
==  计算左边的值是否等于右边的值
!=  计算左边的值是否不等于右边的值
=== 计算两个实例是否指向同一个引用
!== 计算两个实例是否不指向同一个引用

// 逻辑运算符
&& 逻辑与，当且仅当两者都为真时结果为真
|| 逻辑或，两者任意一个为真时结果为真
!  逻辑非，真变为假，假变为真




// 整数除法总是向 0 舍入
print(11 / 3)  // 3
print(-11 / 3) // -3

// 溢出运算符
let aaa: Int8 = 120
//let bbb = aaa + 10
let bbb = aaa &+ 10
print(bbb=\(bbb))
~~~

## 流程控制

~~~
if aaa < 10 {
  print("aaa < 10")
}

if aaa < 10 {
  print("aaa < 10")
} else {
  print("aaa >= 10")
}
~~~

