---
title: "《Swift 编程权威指南》笔记（五）：结构体和类"
author: "Kevin Wu"
date: "2018/05/02"
category: ["swift"]
---


## 异同

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

## 值类型和引用类型

值类型被赋值给变量、常量或传递给函数的时候，其值会被拷贝。所有的基本类型（整数、浮点数、布尔值、字符串、数组和字典）都是值类型，其底层是用结构体实现的。枚举和结构体也是值类型。

标准库中的集合，例如数组、字典和字符串，都对复制进行了优化，新集合不会立即复制，而是跟原集合共享同一份内存。在集合的某个副本要被修改前才会复制它的元素，在代码中看起来就像是立即发生了复制。

引用类型被赋值给变量、常量或传递给函数的时候，其值不会被拷贝。因此，使用的是已存在实例的引用，而不是其拷贝。可以用恒等运算符来判断多个变量或常量是否引用同一个实例。

~~~
// 当值类型的实例被声明为常量的时候，它的所有属性也就成了常量
struct Stt {
  var value = 0
}
let va = Stt()
va.value = 101 // 编译错误

// 把引用类型的实例赋值给常量后，依然可以修改该实例的可变属性
class Cls {
  var value = 0
}
let vb = Cls()
vb.value = 101
~~~

## 初始化

~~~
//////////////////////////////////////////////////////////////////////
// 结构体初始化
//
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
  init(region: String, population: Int, stoplights: Int) { // 参数名称可以随意命名；顺序可以随意排；
    self.population = population
    self.stoplights = stoplights
    self.region = region
  }
  init(population: Int, stoplights: Int) {
    self.init(region: "N/A", population: population, stoplights: stoplights)
  }
}
var va = Town(population: 0, stoplights: 0, region: "") // 编译错误，编译器提供的初始化方法已经不存在了
var vb = Town(region: "", population: 0, stoplights: 0)
vb.region = "South" // 编译出错，region 是常量
var vc = Town(population: 0, stoplights: 0)

//////////////////////////////////////////////////////////////////////
// 类初始化
//
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

## 属性

~~~
class Monster {
  //////////////////////////////////////////////////////////////////////
  // 实例属性

  // 存储属性，可以有默认值
  // 只能用于结构体和类
  var storedProperty = 10
  // 惰性存储属性，必须声明为 var，只在第一次访问的时候会计算并赋值，后面再访问也不会再计算
  // 未初始化的惰性存储属性被多线程同时访问时，无法保证其只被初始化一次
  // 1)使用闭包根据实例当前的情况计算并返回初始化值
  //   末尾的圆括号确保第一次访问此属性时调用闭包并将结果赋给属性，如果省略了圆括号，表示把闭包赋给属性
  lazy var lazyProperty1: Int = { return (self.storedProperty * 2) }()
  // 2)创建某个实例并赋值
  lazy var lazyProperty2: Array<String> = []

  // 计算属性，必须声明为 var，就算是只读计算属性
  // 必须有类型信息编译器才知道 get 方法返回的是什么
  // 可以用于枚举、结构体和类
  // 1)计算属性可以提供 set 方法
  var computedProperty1: Int {
    // get 方法通过当前实例的状态计算出值并返回
    get { return (self.storedProperty * 2) }
    // 如果提供 set 方法的时候不提供参数名，在函数体中可以使用默认参数名 newValue
    set { /**/ }
    //set(newValue) { /**/ }
  }
  // 2)只读计算属性不提供 set 方法，get 方法可以使用快捷语法
  var computedProperty2: Int {
    return (self.storedProperty * 2)
  }

  //////////////////////////////////////////////////////////////////////
  // 类属性

  // 存储类属性，可以是变量或常量
  // 必须有默认值，因为没有初始化方法来初始化
  // 是惰性的，未初始化存储类属性被多线程同时访问也只初始化一次
  static var classStoredProperty = "class stored property"

  // 计算类属性，只能是变量
  // 可以定义为可读可写
  // 可以用 static 或 class 声明，用 static 声明时子类不能重写
  class var classComputedProperty: String {
    // get { return "class computed property" }
    return "class computed property"
  }
}

class Zombie: Monster {
  // 提供自定义的 get 或 set 方法来重写任何继承来的属性，无论属性是存储属性还是计算属性
  // 只读属性能重写为读写属性，但读写属性不能重写为只读属性
  // 如果重写属性时提供了 set 方法，那么一定要提供 get 方法，如果 get 方法没自定义行为，调用父类的 get 方法


  //////////////////////////////////////////////////////////////////////
  // 实例属性

  // 重写父类的存储属性
  override var storedProperty: Int {
    get { return super.storedProperty }
    set { super.storedProperty = newValue }
  }

  // 重写父类的计算属性，并改为读写属性
  override var computedProperty2: Int {
    get { return (super.computedProperty2 + 1) }
    set { super.storedProperty = (newValue - 1) / 2 }
  }

  //////////////////////////////////////////////////////////////////////
  // 类属性

  // 重写父类的存储类属性
  // TODO: 文档没说存储类属性重写的事，估计是不能重写吧，具体真相？
  //override static var classStoredProperty: String {
  //  get { return super.classStoredProperty }
  //  set { super.classStoredProperty = newValue }
  //}

  // 重写父类的计算类属性
  override static var classComputedProperty: String {
    return "override class computed property"
  }
}
~~~

## 属性观察者

~~~
class Monster {
  //////////////////////////////////////////////////////////////////////
  // 属性观察者

  // 即使设置的新值等于旧值也会调用 willSet 和 didSet
  // 1)能观察存储属性，不能观察惰性存储属性
  // 2)不必观察非重写的计算属性，因为可以在计算属性的 set 方法中响应变化
  // 3)能在子类中重写属性来观察父类的存储属性和计算属性
  //
  // TODO: 在通知方法内给变量赋值并不会循环调用通知方法，弄清楚这里
  var numberOfVictims1 = 0
  var numberOfVictims2 = 0 {
    // 如果不指定参数名字，Swift 会自动把参数命名为 newValue
    willSet(newNumberOfVictims) { print("WillSetVictims2: \(self.numberOfVictims2) \(newNumberOfVictims)") }
    // 如果不指定参数名字，Swift 会自动把参数命名为 oldValue
    didSet { print("DidSetVictims2: \(oldValue) \(self.numberOfVictims2)") }
  }
}

class Zombie: Monster {
  //////////////////////////////////////////////////////////////////////
  // 属性观察者

  // 不能给继承来的常量存储属性或只读计算属性添加观察者
  // 不能同时提供 set 方法和观察者，在 set 方法中已经可以观察到值的变化
  // 1)给父类未观察的属性添加观察者
  override var numberOfVictims1: Int {
    willSet { print("Override WillSetVictims1: ") }
    didSet { print("Override DidSetVictims1: ") }
  }
  // 2)重写父类已观察属性的观察者
  // TODO: 子类和父类的通知方法都会被调用，为什么？
  override var numberOfVictims2: Int {
    willSet { print("Override WillSetVictims2: ") }
    didSet { print("Override DidSetVictims2: ") }
  }
}
~~~

## 方法

~~~
class Monster {
  //////////////////////////////////////////////////////////////////////
  // 实例方法
  //
  func instanceMethod(value: Int) {
    print("instance method called: \(value)")
  }

  //////////////////////////////////////////////////////////////////////
  // 类方法
  //
  // 声明类方法可以用 static 或 class，用 static 声明时子类不能重写
  class func classMethod() {
    print("class method called")
  }
}

class Zombie: Monster {
  //////////////////////////////////////////////////////////////////////
  // 实例方法
  //
  // 重写父类的实例方法
  override func instanceMethod(value: Int) {
    print("override instance method called: \(value)")
  }

  //////////////////////////////////////////////////////////////////////
  // 类方法
  //
  // 重写父类的类方法
  override class func classMethod() {
    print("override class method called")
  }
}
~~~

## 下标

  * 可以设定为只读或读写，类似于计算属性；
  * 可以定义在枚举、结构体和类中，是访问集合、列表和序列的快捷方式；
  * 可以接受任意数量的入参，入参可以是任意类型，返回值也可以是任意类型；
  * 可以使用变量参数和可变参数，但不能使用 inout 参数，也不能给参数设置默认值；

~~~
class TimesTable {
  var multiplier: Int
  subscript(index: Int) -> Int {
    return (index * multiplier)
  }
  subscript(index: String) -> String {
    return (index + index)
  }
}
var va = TimesTable(multiplier: 3)
print(va[2]) // 6
print(va["asdf"]) // asdfasdf
~~~








### mutating 本质

~~~
// mutating 不仅能改变成员的值，还能把另外一个实例赋值给 self
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
