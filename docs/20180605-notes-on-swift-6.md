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

// 类型判断，用 is 来检查一个实例是否属于某个特定子类型
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
