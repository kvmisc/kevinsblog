---
title: "《Swift 编程权威指南》笔记（四）：枚举、结构体和类"
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
~~~

### 原始值枚举

~~~
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
  case center = 20
  case right = 30
}
print(va.rawValue) // 20
print(TextAlignment.right.rawValue) // 30

// 原始值转枚举
var va = 20

var vb = TextAlignment(rawValue: va)
print(vb) // Optional(TestSwift.TextAlignment.center)

if var vc = TextAlignment(rawValue: va) {
  print(vc) // center
}

// 字符串原始值
enum TextAlignment: String {
  case left = "Left"
  case center // center 使用自身名字作为原始值
  case right = "Right"
}
var va = TextAlignment.left
print("\(va): \(va.rawValue)") // left: Left
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
var va = TextAlignment.right
print(va.intValue()) // 30
va.toNext()
print(va.intValue()) // 10
~~~

### 关联值

~~~
enum Shape {
  case square(side: Double)
  case rectangle(width: Double, height: Double)
  case point
  func area() -> Double {
    switch self {
    case var .square(side: s):
      return s * s
    case var .rectangle(width: w, height: h):
      return w * h
    case .point:
      return 0
    }
  }
}
var va = Shape.square(side: 10)
print(va.area()) // 100.0
var vb = Shape.rectangle(width: 10, height: 20)
print(vb.area()) // 200.0
var vc = Shape.point
print(vc.area()) // 0.0
~~~

### 递归枚举

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

## 结构体和类

### 值类型传递
~~~
struct Town {
  var population = 100

  mutating func changePopulation(by: Int) {
    self.population += by
  }
}

// town 为可空结构体
var town: Town? = Town()

// 这里会修改 town.population 的值
if town != nil {
  town?.changePopulation(by: -10)
}
// terrorTown 复制了 town，这里修改的是 terrorTown.population，town.population 不会被修改
if var terrorTown = town {
  terrorTown.changePopulation(by: -10)
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
var fChangeTo = Person.changeTo
// 按住 Option 键点击 fChangeTo，能显示出 fChangeTo 的定义：
// 有 mutating
//   var fChangeTo: (inout Person) -> (String, String) -> ()
// 无 mutating
//   var fChangeTo: (      Person) -> (String, String) -> ()
// 两种情况都是接受 Person 实例作为参数，返回一个函数，只不过 mutating 的情况下参数是 inout 形式
// 总结起来：mutating 方法的第一个参数是 self，并以 inout 的形式传入。因为值类型在传递的时候会被复制，所以
// 对于非 mutating 方法，self 其实是个副本，为了进行修改，self 需要被声明为 inout。
var changeTo = fChangeTo(&person)
changeTo("John", "Gallagher") // TODO: 这里会导致函数体内 EXE_BAD_ACCESS，为什么？
print("\(person.firstName) \(person.lastName)")
~~~

