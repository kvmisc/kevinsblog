---
title: "字符编码简介（二）"
author: "Kevin Wu"
date: "2015/01/06"
category: ["encode"]
---


## 组合字符序列

为了和已有的标准兼容，某些字符可以表示成两种形式：1)一个单一的码点；2)两个或多个码点组成的序列。例如，有重音符号的字母 'é' 可以直接表示成 U+00E9（有尖音符号的小写拉丁字母 'e'），也可以表示成由 U+0065（小写拉丁字母 'e'）再加 U+0301（尖音符号）组成的分解形式。组合字符序列不仅仅出现在西方文字里，在谚文（朝鲜、韩国的文字）中，'가' 这个字可以表示成一个码点 U+AC00，也可以表示成 U+1100（'ᄀ'）和 U+1161（'ᅡ'）序列。组合字符序列的英文术语叫 Combining Character Sequence 或 Composite Character Sequence，NSString 类中有部分类似名称的方法。

~~~
NSString *str1 = @"\u00E9";
NSLog(@"str1: [%@]", str1); // str1: [é]
NSString *str2 = @"e\u0301";
NSLog(@"str2: [%@]", str2); // str2: [é]

NSString *str3 = @"\uAC00";
NSLog(@"str3: [%@]", str3); // str3: [가]
NSString *str4 = @"\u1100\u1161";
NSLog(@"str4: [%@]", str4); // str4: [가]
~~~

标准等价（Canonically Equivalence），'é' 可以用一个 U+00E9 或两个 U+0065 U+0301 码点表示，'가' 可以用一个 U+AC00 或两个 U+1100 U+1161 码点表示。在 Unicode 的语境下，这两种形式并不相等（因为两种形式包含不同的码点），但是符合标准等价。总结起来，标准等价的定义就是：码点不同，但外观和意义完全相同。

## 重复的字符

### 假的重复

外观相同，意义不同。拉丁字母 'A'（U+0041）和西里尔字母 'A'（U+0410）完全同形，但事实上，它们是不同的字母，表达着不同的含义。此时 Unicode 会以不同的码点来编码这个字符，以此让 Unicode 的文本保留字符的含义。

### 真的重复

外观相同，意义相同。字母 'Å'（上面带个圆圈的大写拉丁字母 'A'，U+00C5）和字符 'Å'（长度单位埃米符号，U+212B），埃米符号就是定义为这个瑞典大写字母，因此这两个字符的外观和意义是完全相同的。想想标准等价的定义：码点不同，但外观和意义完全相同。

### 广义的重复

相容等价（Compatibility Equivalence），相容等价的典型例子是连字（ligature），连字并不是一个字符，详见[维基百科](https://zh.wikipedia.org/wiki/%E5%90%88%E5%AD%97)。字母 'ﬀ'（小写拉丁连字 'ﬀ'，U+FB00，一个字符）和 "ff" 序列（两个小写拉丁字母 'f'，U+0066 U+0066，两个字符）就符合相容等价但不符合标准等价，虽然它们也可能以完全一致的样子呈现出来，这取决于环境、字体以及文本的渲染系统。总结起来，相容等价的定义就是：码点不同，外观不一定相同，但意义完全相同。

~~~
NSString *str1 = @"\uFB00";
NSLog(@"str1: [%@]", str1); // str1: [ﬀ]

NSString *str2 = @"ff";
NSLog(@"str2: [%@]", str2); // str2: [ff]
~~~

## 正规形式

从上面可以看出，Unicode 字符串的等价性并不是一个简单的概念。通过逐个比较码点的方式可以判断两个字符串是否完全等价，另外，我们还需要鉴定两个字符串是否标准等价或相容等价。为此，Unicode 定义了几个正规化算法。正规化就是将字符串中的 `"\u00E9"` 和 `"e\u0301"` 统一转化为仅含 `"\u00E9"` 或 `"e\u0301"` 的字符串，对两个使用相同方式正规化的字符串进行逐字的二进制比较所得出的结果才是有意义的。

Normalization Forms       | Composed (é)                                   | Decomposed (e + ´)                           
------------------------- | ---------------------------------------------- | ---------------------------------------------
Canonically Equivalence   | C (precomposed​String​With​Canonical​Mapping)      | D (decomposed​String​With​Canonical​Mapping)     
Compatibility Equivalence | KC (precomposed​String​With​Compatibility​Mapping) | KD (decomposed​String​With​Compatibility​Mapping)

如果仅仅为了比较的话，先把字符串正规化成分解形式（D）还是合成形式（C）并不重要。但 C 形式的算法会先分解字符再重新组合起来，因此 D 形式要更快一些。如果一个字符序列里含有多个组合标记，那么组合标记的顺序在分解后会是唯一的。另一方面，Unicode 联盟推荐用 C 形式来存储，因为它能和从旧编码系统转换过来的字符串更好地兼容。

两种等价对于字符串比较来说都很有用，尤其在排序和查找时。但是，如果要永久保存一个字符串，一般情况下不应该用相容等价的方式去将它正规化，因为这样会改变文本的含义。

## NSString 和 Unicode

### 字符串的组成

Unicode 是一种 21 位的编码方案，NSString 的 `characterAtIndex:` 方法返回的类型是 unichar，unichar 被定义为无符号短整型（unsigned short），无符号短整型是 16 位的，显然无法表示所有的 Unicode，当我发现这些事实的时候完全刷新了以前的认识，以前的理解都是错的。用上边的组合字符来做个测试吧。

~~~
NSString *str = @"ae\u0301z";
NSLog(@"str = [%@]", str);                         // str = [aéz]
NSLog(@"length = %lu", [str length]);              // length = 4
NSLog(@"char_0 = [%c]", [str characterAtIndex:0]); // char_0 = [a]
NSLog(@"char_1 = [%c]", [str characterAtIndex:1]); // char_1 = [e]
NSLog(@"char_2 = [%c]", [str characterAtIndex:2]); // char_2 = []
NSLog(@"char_3 = [%c]", [str characterAtIndex:3]); // char_3 = [z]
~~~

从这个例子看出，NSString 的一部分方法并不会像我们想象的那样工作，其结果与实际相去甚远。为了确保 Unicode 字符不会从中间被分开，可以使用 `rangeOfComposedCharacterSequenceAtIndex:` 方法来取得该位置完整字符的范围。

~~~
NSRange range0 = [str rangeOfComposedCharacterSequenceAtIndex:0];
NSLog(@"range0 = (%lu %lu), char_0 = [%@]", range0.location, range0.length, [str substringWithRange:range0]);
// range0 = (0 1), char_0 = [a]

NSRange range1 = [str rangeOfComposedCharacterSequenceAtIndex:1];
NSLog(@"range1 = (%lu %lu), char_1 = [%@]", range1.location, range1.length, [str substringWithRange:range1]);
// range1 = (1 2), char_1 = [é]

NSRange range2 = [str rangeOfComposedCharacterSequenceAtIndex:2];
NSLog(@"range2 = (%lu %lu), char_2 = [%@]", range2.location, range2.length, [str substringWithRange:range2]);
// range2 = (1 2), char_2 = [é]

NSRange range3 = [str rangeOfComposedCharacterSequenceAtIndex:3];
NSLog(@"range3 = (%lu %lu), char_3 = [%@]", range3.location, range3.length, [str substringWithRange:range3]);
// range3 = (3 1), char_3 = [z]
~~~

### 字符串长度

计算字符串长度的正确方法如下：

~~~
__block NSUInteger length = 0;
[str enumerateSubstringsInRange:NSMakeRange(0, [str length])
                        options:NSStringEnumerationByComposedCharacterSequences
                     usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                       length += 1;
                     }];
NSLog(@"length = %lu", length); // length = 3
~~~

### 比较字符串

判断字符串是否标准等价，应先将它们正规化为 C 形式，再逐字比较。

~~~
NSString *str1 = [s1 precomposedStringWithCanonicalMapping];
NSString *str2 = [s2 precomposedStringWithCanonicalMapping];
[str1 isEqualToString:str2];
~~~

## 最后的话

记住，BMP 里所有的字符在 UTF-16 里都可以用一个码元表示，BMP 以外的所有字符都需要两个码元（一个代理对）来表示。基本上所有现代使用的字符都在 BMP 里，因此在实际中很难遇到代理对。然而，这几年随着 emoji 被引入 Unicode（在 1 号平面），而且被广泛使用，遇到代理对的机会越来越大了，你的代码必须能够正确处理它们。

不过，当我们处理 URL 参数名字、某些交互协议命令名字或字典键名字的时候，还是可以不用正规化而直接进行比较、取长度等操作，因为大概不会有人用英文字符和阿拉伯数字字符以外的字符来定义这些字段吧，至于参数内容，自己看着办吧。
