---
title: "Swift 笔记：流程控制"
author: "Kevin Wu"
date: "2017/01/02"
category: ["swift"]
---


## 循环语句

### for 循环

~~~
// 遍历数组
var ary = ["111", "222", "333"]
for it in ary {
  print(it)
}

// 遍历字典
var map = ["a": 1, "c": 3, "b": 2]
for (key, value) in map {
  print("\(key)=\(value)")
}

// 遍历区间
for index in 0..<5 {
  print(index)
}
~~~

### while 循环

~~~
var i = 0
while i < 5 {
  print(i)
  i += 1
}
~~~

### repeat-while 循环

~~~
var i = 0
repeat {
  print(i)
  i += 1
} while i < 5
~~~

## if 语句

~~~
// 检查 API 可用性
if #available(iOS 10.0.1, macOS 10.1, tvOS 10, watchOS 10, *) {
  // 当前系统高于 xx 版本，调用从 xx 版本开始支持的 API
} else {
  // 调用旧版本的 API
}
~~~

## switch 语句

~~~
// 匹配模式
switch value {
case 0:     print("0: \(value)")      // 匹配单个值
case 1,2,3: print("1,2,3: \(value)")  // 匹配多个值
case 3...9: print("3...9: \(value)")  // 匹配区间，注意，此区间的范围与上一个 case 有重叠
default:    print("other: \(value)")
}

// 匹配元组
...

// 值绑定
...

// where 判断
...
~~~

## 控制转移语句

...

## guard 语句

条件不满足时，`else` 里的语句必须能退出 `guard` 语句所在的代码段，可以用 `return`、`break`、`continue` 或 `throw` 做这件事，或者调用一个不返回的函数，例如 `fatalError(_:file:line:)`。

~~~
func foobar(value: String?) {
  guard var name = value else {
    return
  }
  print("name: \(name)")
}
~~~
