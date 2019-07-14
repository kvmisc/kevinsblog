---
title: "Swift 笔记：字符串"
author: "Kevin Wu"
date: "2017/01/03"
category: ["swift"]
---

## 多行字符串

多行字符串开始符号之后和结束符号之前没有换行符号，下面两个字符串是一样的：

~~~
var a = "111"

var b = """
111
"""
~~~

多行字符串字面量能够缩进来匹配周围的代码。结束符号之前的空格字符数量告诉编译器其它行多少空白字符需要忽略。

~~~
var a = """
    111
    """
~~~

用续行符能在代码中添加换行以方便阅读，但不会在字符串里真正加上换行。

~~~
var a = """
111 \
222
"""
~~~

## 扩展字符串分隔符

...

## 字符类型

~~~
var a: Character = "e"
var b: Character = 'e'                  // 编译错误
var c: Character = "ee"                 // 编译错误
var d: Character = "\u{00E9}"           // é
var e: Character = "\u{0065}\u{0301}"   // é
~~~

## 字符串长度

向字符串添加字符并不一定会改变字符串长度。

~~~
// TODO: 找到正确统计字符串长度的方法

var a = "cafe"
print("a=\(a) length=\(a.count)")   // a=cafe length=4

    a += "\u{0301}"
print("a=\(a) length=\(a.count)")   // a=café length=4
~~~

## 字符串索引

使用 `startIndex` 属性可以获取字符串第一个字符的索引，使用 `endIndex` 属性可以获取最后一个字符后一个位置的索引，所以 `endIndex` 属性不能作为字符串的有效下标，空字符串的 `startIndex` 和 `endIndex` 是相等的。

~~~
var a = "0123456789"
print(a[ a.startIndex ])                        // 0
print(a[ a.index(after: a.startIndex) ])        // 1
print(a[ a.index(before: a.endIndex) ])         // 9
print(a[ a.index(a.startIndex, offsetBy: 3) ])  // 3
~~~

## 连接字符串或字符

~~~
// 拼接字符串
var a = "111"
var b = "222"
var c = a + b

// 追加字符串
var d = "333"
d += "444"
d.append("555")

// 追加字符
var e = "666"
var f: Character = "7"
e.append(f)
~~~

## 插入和删除

~~~
var a = "0123456789"

// 插入字符
a.insert("X", at: a.startIndex)               // X0123456789
// 插入字符串
a.insert(contentsOf: "XXX", at: a.endIndex)   // X0123456789XXX

// 删除字符
a.remove(at: a.startIndex)                    // 0123456789XXX
// 删除字符串
var range = a.index(a.endIndex, offsetBy: -3)..<a.endIndex
a.removeSubrange(range)                       // 0123456789
~~~

## 子字符串

~~~
var a = "0123456789"

var index = a.firstIndex(of: "5") ?? a.endIndex
var b = a[..<index]   // SubString

var c = String(b)     // String
~~~

## 字符串比较

可以使用等于运算符（`==`）和不等运算符（`!=`）来比较两个字符串，编译器会采用标准等价来比较。

~~~
var a = "\u{0061}\u{0301}"  // 'a' + ' ́'
var b = "\u{00E1}"          // 'á'
print(a==b)                 // true
~~~

可以使用 `hasPrefix(_:)` 和 `hasSuffix(_:)` 来判断字符串是否有前后缀。
