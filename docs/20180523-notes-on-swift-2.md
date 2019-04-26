---
title: "Swift 笔记（二）"
author: "Kevin Wu"
date: "2017/05/23"
category: ["swift"]
---


## 可空类型

~~~
var aaa: String?
aaa = "111"
print(aaa) // Optional("111")
var bbb: String?
print(bbb) // nil

// 展开可空类型
if aaa != nil {
  let bbb = aaa!
  print(bbb)
}
// 未赋值展开会出现运行时错误
var aaa: String?
print(aaa)
let bbb = aaa! // 出错
print(bbb)

// 可空实例绑定
var aaa: String?
aaa = "111"
print(aaa) // Optional("111")
if let bbb = aaa {
  print(bbb) // 111
}
// 多个可空实例绑定
var aaa: String?
aaa = "111"
print(aaa) // Optional("111")
if let bbb = aaa, let ccc = Int(bbb) { // 字符串 bbb 的值有可能不是数字，所以 Int() 返回的是可空类型
  print("\(bbb), \(ccc)") // 111, 111
}
// 多个可空实例，附带条件检查
var aaa: String?
aaa = "111"
print(aaa) // Optional("111")
if let bbb = aaa, let ccc = Int(bbb), ccc == 111 {
  print("\(bbb), \(ccc)") // 111, 111
}

// 隐式展开可空类型与可空类型的区别是：隐式展开可空类型不需要展开
var aaa: String!
aaa = "111"
print(aaa!) // 111

var aaa: String!
print(aaa) // nil
let bbb: String = aaa // 出错，将 String? 类型赋值给 String 类型
print(bbb) // nil
let ccc = aaa // swift 会推断出 ccc 尽可能安全的类型：String?
print(ccc) // nil
let ddd: String! = aaa // 显式声明 ddd 为隐式展开可空类型
print(ddd)

// 可空链式调用是一种可以调用属性、方法和下标的过程
var aaa: String?
print(aaa) // nil
var bbb = aaa?.uppercased() // aaa 末尾的问号表明这行代码开始了可空链式调用过程
print(bbb) // nil

// nil 合并运算符
var aaa: String?
//aaa = "111"
let bbb = aaa ?? "222" // 如果 aaa 为空，则使用后面的同类型非可空实例
print(bbb) // 222
~~~

## 数组

~~~
// 创建数组
var aaa: Array<String> = []
var bbb: Array<String> = Array()
var ccc = Array<String>()
var ddd = Array() // 出错，推断不出类型

var eee = [111, 111, 111] // 可以包含重复的值
print(eee)

var fff = ["111", "222", 333] // 出错
print(fff)

// 统计元素
print(aaa.count)

// 访问元素
print(aaa[0]) // 111
print(aaa[1...2]) // ["222", "333"]

// 修改元素
aaa[1] += "asdf"
print(aaa) // ["111", "222asdf", "333"]
// 替换元素
aaa[1] = "asdf"
print(aaa) // ["111", "asdf", "333"]

// 添加元素
aaa.append("444")
aaa.append("555")
// 插入元素
aaa.insert("444", at: 1)
print(aaa) // ["111", "444", "222", "333"]
// 追加数组
let bbb = ["444", "555"]
aaa += bbb
print(aaa) // ["111", "222", "333", "444", "555"]

// 删除元素
aaa.remove(at: 0)

// 不可变数组
let bbb = ["111", "333", "222"]
bbb[1] = "asdf" // 出错
bbb = ["444", "555"] // 出错

// 判断相等，相同位置元素相等的数组才算相等
var bbb = ["111", "333", "222"]
print(aaa==bbb) // false
~~~

## 字典

~~~
// 创建字典
var aaa: Dictionary<String, String> = [:]
var bbb: Dictionary<String, String> = Dictionary()
var ccc = Dictionary<String, String>()
var ddd = Dictionary() // 出错，推断不出类型
var eee: [String:String] = [:]
var fff = [String:String]()

var ggg = ["1":"111", "2":"222", "3":"333"]
print(ggg) // ["2": "222", "3": "333", "1": "111"]

// 统计元素
print(aaa.count)

// 访问元素，返回的是可空类型
print(aaa["2"]) // Optional("222")

// 修改元素
aaa["2"] += "asdf" // 出错
// 替换元素
aaa["2"] = "asdf"
print(aaa) // ["1": "111", "2": "asdf", "3": "333"]
aaa.updateValue("qwer", forKey: "2") // 返回被替换的可空类型
print(aaa) // ["1": "111", "2": "qwer", "3": "333"]

// 添加元素
aaa["4"] = "444"
print(aaa) // ["3": "333", "1": "111", "2": "222", "4": "444"]

// 删除元素
aaa.removeValue(forKey: "2") // 返回被删除的可空类型
print(aaa) // ["1": "111", "3": "333"]
aaa["3"] = nil
print(aaa) // ["1": "111"]

// 遍历字典
for (key, value) in aaa { // 遍历键值
  print("\(key)=\(value)")
}
for key in aaa.keys { // 遍历键
  print(key)
}

// 不可变字典
let aaa = ["1":"111", "2":"222", "3":"333"]
aaa = ["4":"444", "5":"555"] // 出错
aaa["2"] = "asdf" // 出错

// 字典转数组
let bbb = Array(aaa.keys)
print(bbb) // ["3", "2", "1"]
~~~

## 集合

~~~
// 创建集合
var aaa: Set<String> = []
var bbb: Set<String> = Set()
var ccc = Set<String>()
var ddd = Set() // 出错，推断不出类型

var eee: Set<String> = ["111", "222", "333"]
print(eee)

// 添加元素
aaa.insert("asdf")

// 并集，A+B
var ccc = aaa.union(bbb)
print(ccc) // ["333", "444", "222", "111"]

// 交集
var ccc = aaa.intersection(bbb)
print(ccc) // ["333"]

// 补集，A-AB交集
var ccc = aaa.subtracting(bbb)
print(ccc) // ["111", "222"]

// 对称差，A+B-AB交集
var ccc = aaa.symmetricDifference(bbb)
print(ccc) // ["222", "111", "444"]

// 不相交
print(aaa.isDisjoint(with: bbb)) // false，aaa 和 bbb 有相同的元素，它们是相交的
~~~







