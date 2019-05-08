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

## 构造和析构

### 结构体构造
~~~
// 编译器提供的构造器
struct Town {
  var population: Int
  var stoplights: Int = 0
}
// 默认构造器，如果结构体的每个存储属性都有默认值，可以用结构体的默认构造器
var va = Town() // 编译错误，population 没有默认值，不能用默认构造器
// 默认成员初始化方法
var vb = Town(population: 0) // 编译错误，虽然 stoplights 有默认值，也要传
var vc = Town(stoplights: 0, population: 0) // 编译错误，顺序也不能乱
var vd = Town(population: 0, stoplights: 0)

// 自定义初始化方法，如果提供自定义初始化方法，编译器就不再提供初始化方法
struct Town {
  var population: Int
  var stoplights: Int
  let region: String
  // 为存储属性分配默认值或在初始化方法中赋值时，属性观察者并不会触发
  init(region: String, population: Int, stoplights: Int) { // 参数名称可以随意命名；顺序可以随意排；
    self.population = population
    self.stoplights = stoplights
    // 常量属性只能在定义它的类初始化方法中修改，不能在子类中修改
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
~~~

### 类构造

类初始化过程分为两个阶段：

  1. 类中的每个存储属性都赋初始值，主要内容是给本类属性赋值并调用父类初始化方法为父类属性赋值；
  2. 在实例准备使用之前进一步自定义存储属性的值，主要内容是修改父类初始化方法设置的值。

为了确保两段式初始化过程不出错地完成，编译器要做四项检查，以下哪条没达到都会编译错误：

  * 检查一：自己初始化必须在父类初始化之前
  * 检查二：父类初始化必须在修改父类属性前
  * 检查三：便利初始化方法必须先调用其它初始化方法，再修改属性
  * 检查四：初始化方法在第一阶段完成前不能调用实例方法，不能访问属性

默认情况下，子类不会继承父类的初始化方法。当为子类引入的所有新属性都提供了默认值，父类的初始化方法可以被自动继承，规则如下：

  * 规则一：如果子类没有定义指定初始化方法，它将自动继承父类所有的初始化方法；
  * 规则二：如果子类提供了父类所有指定初始化方法的自定义实现，它将继承父类所有的便利初始化方法。

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

// 自定义初始化方法
class Monster {
  var population: Int = 0
  var stoplights: Int = 0
  var computedProperty: Int { return 5 }

  //////////////////////////////////////////////////////////////////////
  // 指定初始化方法，必须调用直接父类的指定初始化方法
  // TODO: 指定初始化方法内部好像不能调用其它指定初始化方法，为什么？
  init(population: Int, stoplights: Int) {
    self.population = population
    self.stoplights = stoplights
  }
  init(population: Int) {
    self.population = population
    self.stoplights = 0
  }

  //////////////////////////////////////////////////////////////////////
  // 便利初始化方法
  // 必须调用同类的其它指定或便利初始化方法，但最终结果必须调用指定初始化方法
  // 不能调用父类的任何初始化方法
  convenience init(fooValue: Int) {
    // 直接调用指定初始化方法
    self.init(population: fooValue+1, stoplights: fooValue-1)
  }
  convenience init(barValue: Int) {
    // 间接调用指定初始化方法，这里调用便利初始化方法，便利初始化方法中调用指定初始化方法
    self.init(fooValue: barValue)
  }

  //////////////////////////////////////////////////////////////////////
  // 可失败初始化方法，不能与非可失败初始化方法拥有相同参数名和参数类型
  init?(value: Int) {
    if value < 0 { return nil }
    self.population = value + 1
    self.stoplights = value - 1
  }

  //////////////////////////////////////////////////////////////////////
  // 必要初始化方法
  required init(foobar: Int) {
    self.population = foobar+1
    self.stoplights = foobar-1
  }
}

class Zombie: Monster {
  let region: String
  //////////////////////////////////////////////////////////////////////
  // 指定初始化方法
  init(region: String, population: Int, stoplights: Int) {
    // 阶段一
    // 必须先初始化自己，再去调用父类的指定初始化方法
    self.region = region
    // 编译错误，在父类指定初始化方法被调用之前，不能修改父类的属性，此时父类是未初始化状态
    self.population = 0
    // 调用父类的指定初始化方法
    super.init(population: population, stoplights: stoplights)

    // 阶段二
    // 父类已经初始化完成，此时可以修改父类设置的值
    self.population = 0
  }
  // 重写父类指定初始化方法
  override init(population: Int, stoplights: Int) {
    self.region = "N/A"
    super.init(population: population, stoplights: stoplights)
  }
  override init(population: Int) {
    self.region = "N/A"
    super.init(population: population)
  }

  //////////////////////////////////////////////////////////////////////
  // 便利初始化方法，虽然与父类便利初始化方法匹配，但子类不能调用父类便利初始化方法，这里并不是重写
  convenience init(fooValue: Int) {
    self.init(population: fooValue+1, stoplights: fooValue-1)
  }

  //////////////////////////////////////////////////////////////////////
  // 可失败初始化方法
  // 可以在子类中重写父类的可失败初始化方法，可以重写为可失败或非可失败
  override init(value: Int) {
    self.region = "N/A"
    var tmpValue = value
    if value < 0 { tmpValue = 0 }
    super.init(value: tmpValue)!
  }

  //////////////////////////////////////////////////////////////////////
  // 重写父类必要初始化方法
  required init(foobar: Int) {
    self.region = "N/A"
    super.init(foobar: foobar)
  }
}
~~~

### 类析构

析构只适用于类，每个类最多只能有一个板构器

~~~
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
  //   如果创建的是非惰性存储属性，闭包里面不能访问 self，因为实例并未初始化完成
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
