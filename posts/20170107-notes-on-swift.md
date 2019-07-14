---
title: "Swift 笔记：枚举"
author: "Kevin Wu"
date: "2017/01/07"
category: ["swift"]
---


## 基础用法

~~~
// 定义枚举
enum TextAlignment {
  case left
  case center
  case right
}

// 使用枚举
var alignment1: TextAlignment = TextAlignment.center
var alignment2: TextAlignment = .center
var alignment3                = TextAlignment.center
var alignment4                = .center // 编译错误

// 遍历枚举
enum TextAlignment: CaseIterable {
  case left
  case center
  case right
}
print(TextAlignment.allCases)
~~~

## 关联值

~~~
enum Barcode {
  case upc(Int, Int, Int, Int)
  case qrcode(String)
}

var barcode = Barcode.upc(8, 85909, 51226, 3)
    barcode = .qrcode("ABCDEFGHIJKLMNOP")

switch barcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
  print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrcode(let productCode):
  print("QR Code: \(productCode).")
}
~~~

## 原始值

原始值可以是字符串、字符、整型值或浮点型值。如果原始值类型是整数或字符串，则不用显式为每个枚举成员设置原始值。当使用整数原始值时，每个枚举成员的原始值依次递增；当使用字符串原始值时，每个枚举成员的原始值为该枚举成员的名称。

~~~
enum TextAlignment: Int {
  case left   = 10
  case center = 11
  case right  = 12
}
~~~

## 递归枚举

TODO: 加深理解
