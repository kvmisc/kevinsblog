---
title: "Swift 笔记：集合类型"
author: "Kevin Wu"
date: "2017/01/04"
category: ["swift"]
---

## 数组

~~~
// 创建数组
var ary1: Array<String>   = []
var ary2: Array<String>   = Array()
var ary3                  = Array<String>()

var ary4: [String]        = []
var ary5                  = [String]()


// 遍历元素
for it in ary {
  print(it)
}
for (idx, it) in ary.enumerated() {
  print("\(idx): \(it)")
}


// 访问元素
ary[0]
ary[1...3]

// 修改元素
ary[1] += "111"
// 替换元素
ary[1] = "111"
// 替换多个元素
ary[1...3] = ["111"]

// 添加元素
ary.append("111")
// 插入元素
ary.insert("111", at: 1)
// 追加数组
ary += ["111"]

// 删除元素
ary.remove(at: 0)
~~~

## 集合

当元素顺序不重要或希望每个元素只出现一次，可以使用集合。能存到集合的类型都必须是可哈希的，即该类型必须提供一个方法来计算它的哈希值，所有基本类型（`String`、`Int`、`Double` 和 `Bool`）都是可哈希的，没有关联值的枚举成员值默认也是可哈希的。

~~~
// 创建集合
var set1: Set<String>   = []
var set2: Set<String>   = Set()
var set3                = Set<String>()


// 遍历元素
for it in set {
  print(it)
}
for it in set.sorted() {
  print(it)
}


// 访问元素
// ...

// 修改元素
// ...

// 添加元素
set.insert("111")

// 删除元素
set.remove("111")


// 集合操作
// 并集
var set3 = set1.union(set2)
// 交集
var set3 = set1.intersection(set2)
// 补集，A-交集
var set3 = set1.subtracting(set2)
// 对称差，A+B-交集
var set3 = set1.symmetricDifference(set2)


// 集合关系
// 相等
print( set1==set2 )
// 是否子集
print( set1.isSubset(of: set2) )
// 是否子集且不相等
print( set1.isStrictSubset(of: set2) )
// 是否包含
print( set1.isSuperset(of: set2) )
// 是否包含且不相等
print( set1.isStrictSuperset(of: set2) )
// 不相交，没有相同的值
print( set1.isDisjoint(with: set2) )
~~~

## 字典

~~~
// 创建字典
var map1: Dictionary<String, Int>   = [:]
var map2: Dictionary<String, Int>   = Dictionary()
var map3                            = Dictionary<String, Int>()

var map4: [String:Int]              = [:]
var map5                            = [String:Int]()


// 遍历字典
for (key, value) in map {
  print("\(key)=\(value)")
}
for key in map.keys {
  print(key)
}


// 访问元素
map["key"]

// 修改元素/添加元素
map["key"] = "value"

// 删除元素
map["key"] = nil
~~~






