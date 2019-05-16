---
title: "Swift 笔记（四）：枚举"
author: "Kevin Wu"
date: "2018/05/29"
category: ["swift"]
---



## 基本用法

~~~
// 声明枚举
enum TextAlignment {
  case left
  case center
  case right
}

// 使用枚举
var va: TextAlignment = TextAlignment.center
var vb: TextAlignment = .center
var vc = TextAlignment.center
var vd = .center // 编译错误，推断不出类型

va = .left // va 已经确定为某个枚举类型，重新赋值时可以省略枚举名

// 比较枚举
if va == .right {
  print("right")
}

// switch 枚举
switch va {
case .left:
  print("left")
case .center:
  print("center")
case .right:
  print("right")
}

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
// 不指定名字
enum Barcode {
  case upc(Int, Int, Int, Int)
  case qrcode(String)
}
var va = Barcode.upc(8, 85909, 51226, 3)
var vb = Barcode.qrcode("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

switch va {
case .upc(let numberSystem, let manufacturer, let product, let check):
  print("UPC: \(numberSystem) \(manufacturer) \(product) \(check)")
case .qrcode(var productCode):
  print("QR Code: \(productCode)")
}

// 指定名字
enum Shape {
  case square(side: Double)
  case rectangle(width: Double, height: Double)
  case point
}

var va = Shape.square(side: 10)
var vb = Shape.rectangle(width: 10, height: 20)
var vc = Shape.point
~~~

## 原始值

~~~
// 原始值的类型可以是字符串、字符、整数或浮点数
// 当原始值类型是整数或字符串时，不需要显式给每个成员赋值，
// 整数原始值默认从 0 开始，字符串原始值默认是成员的名字

// 默认原始值
enum TextAlignment: Int {
  case left
  case center
  case right
}
print(va.rawValue) // 1
print(TextAlignment.right.rawValue) // 2

// 指定原始值
enum TextAlignment: Int {
  case left = 10
  case center = 11
  case right = 12
}
print(va.rawValue) // 11
print(TextAlignment.right.rawValue) // 12

// 原始值转枚举
var va = 11

var vb = TextAlignment(rawValue: va)
print(vb) // Optional(TestSwift.TextAlignment.center)

if var vc = TextAlignment(rawValue: va) {
  print(vc) // center
}
~~~

## 递归枚举

~~~
indirect enum FamilyTree {
  case noKnownParents
  case oneKnownParent(name: String, ancestors: FamilyTree)
  case twoKnownParents(fatherName: String, fatherAncestors: FamilyTree,
                      motherName: String, motherAncestors: FamilyTree)
}
var va = FamilyTree.twoKnownParents(fatherName: "Fred Sr.",
                                    fatherAncestors: .oneKnownParent(name: "Beth", ancestors: .noKnownParents),
                                    motherName: "Marsha",
                                    motherAncestors: .noKnownParents)
~~~

## 方法

~~~
enum TextAlignment {
  case left
  case center
  case right

  func intValue() -> Int {
    switch self {
    case .left:
      return 10
    case .center:
      return 11
    case .right:
      return 12
    }
  }

  mutating func toNext() { // 枚举是值类型，值类型的方法不能修改 self，如果希望值类型的方法能修改 self，要标记此方法为 mutating
    switch self {
    case .left:
      self = .center
    case .center:
      self = .right
    case .right:
      self = .left
    }
  }
}

var va = TextAlignment.right
print(va.intValue()) // 12
va.toNext()
print(va.intValue()) // 10
~~~
