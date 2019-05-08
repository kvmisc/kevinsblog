---
title: "《Swift 编程权威指南》笔记（二）：高级对象"
author: "Kevin Wu"
date: "2018/05/23"
category: ["swift"]
---


## 可空类型

~~~
var va: String?
print(va) // nil
var vb: String?
vb = "111"
print(vb) // Optional("111")

// 展开可空类型
var va: String? = "111"
if va != nil {
  print(va!) // 111
}
// 未赋值展开会出现运行时崩溃
var va: String?
var vb = va! // 运行时崩溃
print(vb)

// 可空实例绑定，能用在 if 或 while 语句中
var va: String? = "111"
if var vb = va {
  print(vb) // 111
}
// 多个可空实例绑定
var va: String? = "111"
if var vb = va, var vc = Int(vb) { // 字符串 vb 的值有可能不是数字，所以 Int() 返回的是可空类型
  print("\(vb), \(vc)") // 111, 111
}
// 多个可空实例绑定，附带条件检查
var va: String? = "111"
if var vb = va, var vc = Int(vb), vc == 111 {
  print("\(vb), \(vc)") // 111, 111
}

// 隐式展开可空类型
// 非常适合那些第一次赋值后就可以确定之后一直有值的可选类型，主要在类初始化期间使用
// 其实就是一个普通的可选选类型，但可以被当成非可空类型值来使用，不用每次都通过展开来获取可空类型里的值
// 可以理解成一种使用时候能自动展开的可空类型，只需在声明的时候用感叹号，而不是每次使用的时候用感叹号
// 如果后面某个时间点值会是 nil，一定不要使用隐式展开可空类型
var va: String? = "111"
var vb: String = va!
print(vb) // 111
var vc: String! = "333"
var vd: String = vc
print(vd) // 333

// 可空链式调用是一种可以调用属性、方法和下标的过程
// 就算方法被定义为返回非可空类型，如果在有值的可空变量上被调用，返回的也是可空类型
var va: String?
var vb = va?.uppercased()
print(vb) // nil

// nil 合并运算符
var va: String? = "111"
var vb = va ?? "222" // 如果 va 为空，则使用后面的同类型非可空实例
print(vb) // 111
~~~

## 元组

~~~
// 无名元组
var va = (404, "Not Found")
print(va.0)
print(va.1)

// 有名元组，用名字访问元素，也可以用数字下标访问
var va = (code:404, info:"Not Found")
print(va.code)
print(va.info)

// 元组解压缩
var va = (404, "Not Found")
var (code, info) = va
print("code=\(code), info=\(info)")
var (_, info) = va // 如果只想提取 info，可用下划线代替 code
~~~

## 数组

~~~
// 创建数组
var va: Array<String> = []
var vb: Array<String> = Array()
var vc = Array<String>()
var vd = Array() // 编译错误，推断不出类型

var ve: [String] = []
var vf = [String]()

var vg = [111, 111, 111] // 可以包含重复的值

var vh = ["111", "222", 333] // 编译错误

// 统计元素
print(va.count) // 3
print(va.isEmpty) // false

// 访问元素
print(va[0]) // 111
print(va[1...2]) // ["222", "333"]
print(va[10]) // 运行时崩溃

// 修改元素
va[1] += "asdf" // ["111", "222asdf", "333"]
// 替换元素
va[1] = "asdf" // ["111", "asdf", "333"]
// 替换多个元素
var[1...2] = ["444"] // ["111", "444"]

// 添加元素
va.append("444") // ["111", "222", "333", "444"]
va.append("555") // ["111", "222", "333", "444", "555"]
// 插入元素
va.insert("666", at: 1) // ["111", "666", "222", "333", "444", "555"]
// 追加数组
var vb = ["777", "888"]
va += vb  // ["111", "666", "222", "333", "444", "555", "777", "888"]

// 删除元素
var vb = va.remove(at: 0) // ["222", "333"]
print(vb) // 111

// 遍历元素
for item in va {
  print(item)
}
for (index, item) in va.enumerated() {
  print("\(index): \(item)")
}

// 判断相等，相同位置元素相等的数组才算相等
var vd = ["111", "333", "222"]
print(va == vd) // false
~~~

## 集合

~~~
// 当元素顺序不重要或者希望每个元素只出现一次，可以使用集合
// 能存在集合的类型都必须是可哈希的，即该类型必须提供一个方法来计算它的哈希值
// 所有基本类型（String、Int、Double 和 Bool）都是可哈希的，没有关联值的枚举成员值也是可哈希的

// 创建集合
var va: Set<String> = []
var vb: Set<String> = Set()
var vc = Set<String>()
var vd = Set() // 编译错误，推断不出类型

var ve: Set<String> = ["111", "222", "333"] // 如果不写类型，会被推断为字符串数组
var vf: Set = ["111", "222", "333"] // 虽然不能推断出集合，但能推断出集合中的元素是字符串

// 统计元素
print(va.count) // 3
print(va.isEmpty) // false

// 访问元素

// 修改元素

// 添加元素
va.insert("444") // ["111", "222", "333", "444"]

// 删除元素
var vb = va.remove("222") // ["111", "333"]
print(vb) // Optional("222")

// 遍历元素
for item in va {
  print(item)
}
for item in va.sorted() {
  print(item)
}

// 集合操作
// 并集
var vc = va.union(vb) // ["111", "222", "333", "444"]
// 交集
var vc = va.intersection(vb) // ["333"]
// 补集，A-交集
var vc = va.subtracting(vb) // ["111", "222"]
// 对称差，A+B-交集
var vc = va.symmetricDifference(vb) // ["111", "222", "444"]

// 集合关系
// 相等
print(va == vb)
// 是否子集
print(va.isSubset(of: vb))
// 是否子集且不相等
print(va.isStrictSubset(of: vb))
// 是否包含
print(va.isSuperset(of: vb))
// 是否包含且不相等
print(va.isStrictSuperset(of: vb))
// 不相交，没有相同的值
print(va.isDisjoint(with: vb))
~~~

## 字典

~~~
// 创建字典
var va: Dictionary<String, String> = [:]
var vb: Dictionary<String, String> = Dictionary()
var vc = Dictionary<String, String>()
var vd = Dictionary() // 编译错误，推断不出类型

var ve: [String:String] = [:]
var vf = [String:String]()

var vg = ["1":"111", "2":"222", "3":"333"]
print(vg) // ["1":"111", "2":"222", "3":"333"]

// 统计元素
print(va.count)
print(va.isEmpty)

// 访问元素，返回的是可空类型
print(va["2"]) // Optional("222")

// TODO: 为何能替换却不能修改字典某个元素的值？
// 修改元素
va["2"] += "asdf" // 编译错误
// 替换元素
va["2"] = "asdf" // ["1":"111", "2":"asdf", "3":"333"]
// 调用方法替换
var vb = va.updateValue("asdf", forKey: "3") // ["1":"111", "2":"asdf", "3":"asdf"]
print(vb) // Optional("333")

// 添加元素
va["4"] = "444" // ["1":"111", "2":"222", "3":"333", "4": "444"]
// 调用方法添加
var vb = va.updateValue("444", forKey: "4") // ["1":"111", "2":"asdf", "3":"333", "4": "444"]
print(vb) // Optional("444")

// 删除元素
va["2"] = nil // ["1": "111", "3": "333"]
// 调用方法删除
var vb = va.removeValue(forKey: "3") // ["1": "111"]
print(vb) // Optional("333")

// 遍历字典
for (key, value) in va { // 遍历键值
  print("\(key)=\(value)")
}
for key in va.keys { // 遍历键
  print(key)
}
~~~
