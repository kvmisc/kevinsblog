---
title: "《Swift 编程权威指南》笔记（六）：拾遗"
author: "Kevin Wu"
date: "2018/06/05"
category: ["swift"]
---


## 类型转换

~~~
// 数组只能包含一种类型，类实例和它不同子类的实例能保存到同一数组
class Media {
  var name = ""
}
class Movie: Media {
  var director = ""
}
class Song: Media {
  var artist = ""
}
var va = Media()
var vb = Movie()
var vc = Song()
var vd = [va, vb, vc]

// 类型判断，用 is 来检查一个实例是否属于某个特定子类型，Movie 和 Song 都是 Media
for (idx, itm) in vd.enumerated() {
  if itm is Movie {
    print("\(idx): movie")
  } else if itm is Song {
    print("\(idx): song")
  } else {
    print("\(idx): unknown")
  }
}

// 类型转换
for itm in vd {
  if var movie = itm as? Movie {
    print("got movie")
  } else if var song = itm as? Song {
    print("got song")
  } else {
    print("got unknown")
  }
}
~~~

## 扩展

扩展可以给现有的类、结构体、枚举或协议添加新的功能，扩展没有名字。与 Objective-C 分类相比，Swift 扩展还具有：

  * 添加计算实例属性或类属性，不能添加存储属性；
  * 添加实例方法或类方法；
  * 提供新的构造器；
  * 定义下标；
  * 定义和使用新的嵌套类型；
  * 使已存在的类型遵守协议。

~~~
extension SomeType {
  // ...
}

extension SomeType: SomeProtocol, AnotherProtocol {
  // ...
}
~~~

扩展可以给类添加便利构造器，但不能添加指定构造器或析构器，指定构造器或析构器必须始终由类的原始实现提供。

~~~
// 一个模块
struct Point {
  var x = 0.0
  var y = 0.0
}
// 另一个模块
extension Point {
  init(xy: Double) {
    self.x = xy // 编译错误，在调用 init 之前不能访问 self
    self.y = xy // 编译错误，在调用 init 之前不能访问 self
    self.init(x: xy, y: xy)
  }
}
~~~

