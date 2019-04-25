---
title: "Swift 笔记（二）"
author: "Kevin Wu"
date: "2017/05/23"
category: ["swift"]
---


## 可空类型

~~~
var aaa: String?
aaa = "111"
print(aaa) // Optional("111")
var bbb: String?
print(bbb) // nil

// 展开可空类型
if aaa != nil {
  let bbb = aaa!
  print(bbb)
}
// 未赋值展开会出现运行时错误
var aaa: String?
print(aaa)
let bbb = aaa! // 出错
print(bbb)

// 可空实例绑定
var aaa: String?
aaa = "111"
print(aaa) // Optional("111")
if let bbb = aaa {
  print(bbb) // 111
}
// 多个可空实例绑定
var aaa: String?
aaa = "111"
print(aaa) // Optional("111")
if let bbb = aaa, let ccc = Int(bbb) { // 字符串 bbb 的值有可能不是数字，所以 Int() 返回的是可空类型
  print("\(bbb), \(ccc)") // 111, 111
}
// 多个可空实例，附带条件检查
var aaa: String?
aaa = "111"
print(aaa) // Optional("111")
if let bbb = aaa, let ccc = Int(bbb), ccc == 111 {
  print("\(bbb), \(ccc)") // 111, 111
}

// 隐式展开可空类型与可空类型的区别是：隐式展开可空类型不需要展开
var aaa: String!
aaa = "111"
print(aaa) // Optional("111")

var aaa: String!
print(aaa) // nil
let bbb: String = aaa // 出错，将 String? 类型赋值给 String 类型
print(bbb) // nil
let ccc = aaa // swift 会推断出 ccc 尽可能安全的类型：String?
print(ccc) // nil
let ddd: String! = aaa // 显式声明 ddd 为隐式展开可空类型
print(ddd)

// 可空链式调用是一种可以调用属性、方法和下标的过程
var aaa: String?
print(aaa) // nil
var bbb = aaa?.uppercased() // aaa 末尾的问号表明这行代码开始了可空链式调用过程
print(bbb) // nil
~~~









