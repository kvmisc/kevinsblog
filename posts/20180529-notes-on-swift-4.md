---
title: "Swift 笔记（四）：函数和闭包"
author: "Kevin Wu"
date: "2017/05/29"
category: ["swift"]
---


## 枚举

### 基本用法
~~~
// 声明枚举
enum TextAlignment {
  case left
  case center
  case right
}

// 使用枚举
var aaa: TextAlignment = TextAlignment.center
var bbb = TextAlignment.center
bbb = .left // bbb 已经确定为某个枚举类型，赋值时可以省略枚举名

// 比较枚举
if bbb == .right {
  print("right")
}

// switch 枚举
switch aaa {
case .left:
  print("left")
case .right:
  print("right")
case .center:
  print("center")
}
~~~

### 原始值枚举

~~~
// 默认原始值
enum TextAlignment: Int {
  case left
  case center
  case right
}
print(TextAlignment.right.rawValue) // 2

// 指定原始值
enum TextAlignment: Int {
  case left = 0
  case center = 10
  case right = 20
}
print(TextAlignment.right.rawValue) // 20

// 原始值转枚举
let aaa = 10
let bbb = TextAlignment(rawValue: aaa)
print(bbb) // Optional(TestSwift.TextAlignment.center)
if let ccc = TextAlignment(rawValue: aaa) {
  print(ccc) // center
}

// 字符串原始值，center 使用自身名字作为原始值
enum TextAlignment: String {
  case left = "Left"
  case center
  case right = "Right"
}
var aaa: TextAlignment = TextAlignment.left
print("\(aaa): \(aaa.rawValue)") // left: Left
~~~

### 方法

