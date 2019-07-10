---
title: "Swift 笔记（二）：高级对象"
author: "Kevin Wu"
date: "2018/05/23"
category: ["swift"]
---


## 可空类型

~~~
var va: String?
print(va) // nil
var vb: String?
vb = "111"
print(vb) // Optional("111")

// 展开可空类型
var va: String? = "111"
if va != nil {
  print(va!) // 111
}
// 未赋值展开会出现运行时崩溃
var va: String?
var vb = va! // 运行时崩溃
print(vb)

// 可空实例绑定，能用在 if 或 while 语句中
var va: String? = "111"
if var vb = va {
  print(vb) // 111
}
// 多个可空实例绑定
var va: String? = "111"
if var vb = va, var vc = Int(vb) { // 字符串 vb 的值有可能不是数字，所以 Int() 返回的是可空类型
  print("\(vb), \(vc)") // 111, 111
}
// 多个可空实例绑定，附带条件检查
var va: String? = "111"
if var vb = va, var vc = Int(vb), vc == 111 {
  print("\(vb), \(vc)") // 111, 111
}

// 隐式展开可空类型
// 非常适合那些第一次赋值后就可以确定之后一直有值的可选类型，主要在类初始化期间使用
// 其实就是一个普通的可选选类型，但可以被当成非可空类型值来使用，不用每次都通过展开来获取可空类型里的值
// 可以理解成一种使用时候能自动展开的可空类型，只需在声明的时候用感叹号，而不是每次使用的时候用感叹号
// 如果后面某个时间点值会是 nil，一定不要使用隐式展开可空类型
var va: String? = "111"
var vb: String = va!
print(vb) // 111
var vc: String! = "333"
var vd: String = vc
print(vd) // 333

// 可空链式调用是一种可以调用属性、方法和下标的过程
// 就算方法被定义为返回非可空类型，如果在有值的可空变量上被调用，返回的也是可空类型
var va: String?
var vb = va?.uppercased()
print(vb) // nil

// nil 合并运算符
var va: String? = "111"
var vb = va ?? "222" // 如果 va 为空，则使用后面的同类型非可空实例
print(vb) // 111
~~~

## 元组

~~~
// 无名元组
var va = (404, "Not Found")
print(va.0)
print(va.1)

// 有名元组，用名字访问元素，也可以用数字下标访问
var va = (code:404, info:"Not Found")
print(va.code)
print(va.info)

// 元组解压缩
var va = (404, "Not Found")
var (code, info) = va
print("code=\(code), info=\(info)")
var (_, info) = va // 如果只想提取 info，可用下划线代替 code
~~~

## 数组

~~~
// 统计元素
print(va.count) // 3
print(va.isEmpty) // false

// 判断相等，相同位置元素相等的数组才算相等
var vd = ["111", "333", "222"]
print(va == vd) // false
~~~

## 集合

~~~
// 统计元素
print(va.count) // 3
print(va.isEmpty) // false

~~~

## 字典

~~~
// 统计元素
print(va.count)
print(va.isEmpty)


~~~
