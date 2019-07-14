---
title: "Swift 笔记（四）：枚举"
author: "Kevin Wu"
date: "2018/05/29"
category: ["swift"]
---


## 关联值

## 原始值

## 递归枚举

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
