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
      return 20
    case .right:
      return 30
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
var aaa = TextAlignment.right
print(aaa.intValue()) // 10
aaa.toNext()
print(aaa.intValue()) // 20
~~~

### 关联值

~~~
enum Shape {
  case square(side: Double)
  case rectangle(width: Double, height: Double)
  case point
  func area() -> Double {
    switch self {
    case let .square(side: side):
      return side * side
    case let .rectangle(width: width, height: height):
      return width * height
    case .point:
      return 0
    }
  }
}
var aaa = Shape.square(side: 10)
print(aaa.area()) // 100.0
var bbb = Shape.rectangle(width: 10, height: 20)
print(bbb.area()) // 200.0
var ccc = Shape.point
print(ccc.area()) // 0.0
~~~

### 递归枚举

~~~
indirect enum FamilyTree {
  case noKnownParents
  case oneKnownParent(name: String, ancestors: FamilyTree)
  case twoKnownParents(fatherName: String, fatherAncestors: FamilyTree,
                      motherName: String, motherAncestors: FamilyTree)
}
let aaa = FamilyTree.twoKnownParents(fatherName: "Fred Sr.",
                                     fatherAncestors: .oneKnownParent(name: "Beth", ancestors: .noKnownParents),
                                     motherName: "Marsha",
                                     motherAncestors: .noKnownParents)
~~~

## 结构体和类

### 值类型传递
~~~
// town 为可空结构体，这里会修改 town
if town != nil {
  town?.updatePopulation(by: -10)
  print("\(name) make population -10")
} else {
  print("\(name) did nothing")
}
// town 为可空结构体，terrorTown 复制了 town，这里修改的是 terrorTown，town 不会被修改
if var terrorTown = town {
  terrorTown.updatePopulation(by: -10)
  print("\(name) make population -10")
} else {
  print("\(name) did nothing")
}
~~~

### mutating 本质

~~~
struct Person {
  var firstName = "Matt"
  var lastName = "Mathias"
  mutating func changeTo(fn: String, ln: String) {
    self.firstName = fn
    self.lastName = ln
  }
}
var person = Person()
let changeName = Person.changeTo
// 按住 Option 键点击 changeName，能显示出 changeName 的定义：
// 有 mutating
//   let changeName: (inout Person) -> (String, String) -> ()
// 无 mutating
//   let changeName: (      Person) -> (String, String) -> ()
// 两种情况都是接受 Person 实例作为参数，返回一个函数，只不过 mutating 的情况下参数是 inout 形式
// 总结起来：mutating 方法的第一个参数是 self，并以 inout 的形式传入。因为值类型在传递的时候会被复制，所以
// 对于非 mutating 方法，self 其实是个副本，为了进行修改，self 需要被声明为 inout。
let changeNameFromMattTo = changeName(&person)
changeNameFromMattTo("John", "Gallagher") // 这里调用会导致函数体内 EXE_BAD_ACCESS，不清楚为何
print("\(person.firstName) \(person.lastName)")
~~~

