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

// 遍历枚举
enum TextAlignment: CaseIterable {
  case left
  case center
  case right
}
print(TextAlignment.allCases)
~~~

### 关联值

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

### 原始值

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

## 结构体和类

### 异同

结构体和类有很多共同点：

  * 定义属性用于存储值；
  * 定义方法用于提供功能；
  * 定义下标操作用于通过下标语法访问它们的值；
  * 定义构造器用于设置初始值；
  * 通过扩展以增加默认实现之外的功能；
  * 遵循协议以提供某种标准功能。

此外，类还有特别的功能：

  * 继承，允许一个类继承另一个类的特征；
  * 类型转换，允许在运行时检查和解释一个类实例的类型；
  * 析构器，允许一个类实例释放任何其分配的资源；
  * 引用计数，允许对一个类的多次引用。









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

### 结构体和类常量

~~~
struct Stt {
  var value = 0
}
class Cls {
  var value = 0
}
let va = Stt()
va.value = 101 // 编译出错
let vb = Cls()
vb.value = 101
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
print("\(person.firstName), \(person.lastName)")
~~~

### 初始化

#### 结构体初始化

~~~
// 编译器提供的初始化方法
struct Town {
  var population: Int
  var stoplights: Int = 0
}
// 默认初始化方法，如果结构体的每个存储属性都有默认值，可以用结构体的默认初始化方法
var va = Town() // 编译错误，population 没有默认值，不能用默初始化方法
// 默认成员初始化方法
var vb = Town(population: 0) // 编译错误，虽然 stoplights 有默认值，也要传
var vc = Town(stoplights: 0, population: 0) // 编译错误，顺序也不能乱
var vd = Town(population: 0, stoplights: 0)

// 自定义初始化方法，如果提供自定义初始化方法，编译器就不再提供初始化方法
struct Town {
  var population: Int
  var stoplights: Int
  let region: String
  init(region: String, population: Int, lights: Int) { // label 可以随意命名；顺序可以随意排；
    self.population = population // 参数名与属性名相同，必须用 self
    stoplights = lights // 参数名与属性名不同，可以不用 self
    self.region = region
  }
  init(population: Int, lights: Int) {
    self.init(region: "N/A", population: population, lights: lights)
  }
}
var va = Town(population: 0, stoplights: 0, region: "") // 编译错误，编译器提供的初始化方法已经不存在了
var vb = Town(region: "", population: 0, lights: 0)
vb.region = "South" // 编译出错，region 是常量
var vc = Town(population: 0, lights: 0)
~~~

#### 类初始化

~~~
// 编译器提供的初始化方法
class Monster {
  var population: Int = 0
  var stoplights: Int = 0
  var computedProperty: Int { return 5 }
}
// 默认初始化方法
// 当类的所有存储属性都有默认值的时候，可以调用这个方法
// 当类的部分存储属性没有默认值，且没有提供自定义初始化方法的时候，编译错误
var va = Monster()
// 类没有默认成员初始化方法
~~~
