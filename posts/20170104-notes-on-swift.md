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


// 访问元素
print(ary[0])
print(ary[1...3])

// 遍历元素
for it in ary {
  print(it)
}
for (idx, it) in ary.enumerated() {
  print("\(idx): \(it)")
}


// 修改元素
ary[1] += "111"
// 替换元素
ary[1] = "111"
// 替换多个元素
ary[1...3] = ["111"]

// 追加元素
ary.append("111")
// 插入元素
ary.insert("111", at: 1)
// 追加数组
ary += anotherAry

// 删除元素
ary.remove(at: 0)
~~~

## 集合

当元素顺序不重要或希望每个元素只出现一次，可以使用集合。能存到集合的类型都必须是可哈希的，即该类型必须提供一个方法来计算它的哈希值，所有基本类型（`String`、`Int`、`Double` 和 `Bool`）都是可哈希的，没有关联值的枚举成员值默认也是可哈希的。

~~~
~~~








