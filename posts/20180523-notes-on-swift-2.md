---
title: "Swift 笔记（二）：高级对象"
author: "Kevin Wu"
date: "2017/05/23"
category: ["swift"]
---


## 元组

~~~
// 无名元组
var va = (404, "Not Found")
print(va.0)
print(va.1)

// 有名元组，也可以用数字下标访问
var va = (code:404, info:"Not Found")
print(va.code)
print(va.info)
~~~

## 可空类型

~~~
var va: String?
print(va) // nil
var vb: String?
vb = "111"
print(vb) // Optional("111")

// 展开可空类型
if va != nil {
  var vb = va!
  print(vb) // 111
}
// 未赋值展开会出现运行时崩溃
var va: String?
print(va) // nil
var vb = va! // 运行时崩溃
print(vb)

// 可空实例绑定
var va: String? = "111"
print(va) // Optional("111")
if var vb = va {
  print(vb) // 111
}
// 多个可空实例绑定
var va: String? = "111"
print(va) // Optional("111")
if var vb = va, var vc = Int(vb) { // 字符串 vb 的值有可能不是数字，所以 Int() 返回的是可空类型
  print("\(vb), \(vc)") // 111, 111
}
// 多个可空实例绑定，附带条件检查
var va: String? = "111"
print(va) // Optional("111")
if var vb = va, var vc = Int(vb), vc == 111 {
  print("\(vb), \(vc)") // 111, 111
}

// TODO: 可空类型和隐式展开可空类型的区别是什么？

// 可空链式调用是一种可以调用属性、方法和下标的过程
var va: String?
print(va) // nil
var vb = va?.uppercased() // va 末尾的问号表明这行代码开始了可空链式调用过程
print(vb) // nil

// nil 合并运算符
var va: String?
//va = "111"
var vb = va ?? "222" // 如果 va 为空，则使用后面的同类型非可空实例
print(vb) // 222
~~~

## 数组

~~~
// 创建数组
var va: Array<String> = []
var vb: Array<String> = Array()
var vc = Array<String>()
var vd = Array() // 编译错误，推断不出类型

var ve = [111, 111, 111] // 可以包含重复的值
print(ve)

var vf = ["111", "222", 333] // 编译错误
print(vf)

// 统计元素
print(va.count) // 3

// 访问元素
print(va[0]) // 111
print(va[1...2]) // ["222", "333"]
print(va[10]) // 运行时崩溃

// 修改元素
va[1] += "asdf" // ["111", "222asdf", "333"]
// 替换元素
va[1] = "asdf" // ["111", "asdf", "333"]

// 添加元素
va.append("444") // ["111", "222", "333", "444"]
va.append("555") // ["111", "222", "333", "444", "555"]
// 插入元素
va.insert("666", at: 1) // ["111", "666", "222", "333", "444", "555"]
// 追加数组
var vb = ["777", "888"]
va += vb  // ["111", "666", "222", "333", "444", "555", "777", "888"]

// 删除元素
va.remove(at: 0) // ["222", "333"]

// 不可变数组
let vb = ["111", "222", "333"]
vb[1] = "asdf" // 编译错误
vb = ["444", "555"] // 编译错误

// 判断相等，相同位置元素相等的数组才算相等
var vb = ["111", "333", "222"]
print(va == vb) // false
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

// 访问元素，返回的是可空类型
print(va["2"]) // Optional("222")

// TODO: 为何能替换却不能修改字典某个元素的值？
// 修改元素
va["2"] += "asdf" // 编译错误
// 替换元素
va["2"] = "asdf" // ["1":"111", "2":"asdf", "3":"333"]
var vb = va.updateValue("asdf", forKey: "3") // ["1":"111", "2":"asdf", "3":"asdf"]
print(vb) // Optional("333")

// 添加元素
va["4"] = "444" // ["1":"111", "2":"222", "3":"333", "4": "444"]

// 删除元素
va["2"] = nil
print(va) // ["1": "111", "3": "333"]
var vb = va.removeValue(forKey: "3") // ["1": "111"]
print(vb) // Optional("333")

// 不可变字典
let vb = ["1":"111", "2":"222", "3":"333"]
vb["2"] = "asdf" // 编译错误
vb = ["4":"444", "5":"555"] // 编译错误

// 遍历字典
for (key, value) in va { // 遍历键值
  print("\(key)=\(value)")
}
for key in va.keys { // 遍历键
  print(key)
}
~~~

## 集合

~~~
// 创建集合
var va: Set<String> = []
var vb: Set<String> = Set()
var vc = Set<String>()
var vd = Set() // 编译错误，推断不出类型

var ve: Set<String> = ["111", "222", "333"]
print(ve)

// 并集，A+B
var vc = va.union(vb)
print(vc) // ["111", "222", "333", "444"]

// 交集
var vc = va.intersection(vb)
print(vc) // ["333"]

// 补集，A-AB交集
var vc = va.subtracting(vb)
print(vc) // ["111", "222"]

// 对称差，A+B-AB交集
var vc = va.symmetricDifference(vb)
print(vc) // ["111", "222", "444"]

// 不相交
print(va.isDisjoint(with: vb)) // false，va 和 vb 有相同的元素，它们是相交的
~~~
