
## 换行

行尾添加两个或以上空格会强行换行，就像 `<br />` 元素。比如：

This two-line bullet 
won't break

This two-line bullet  
will break

## 引用

> This is a blockquote with two paragraphs. Lorem ipsum dolor sit amet,consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.
>
> ### title
>
> Donec sit amet nisl. Aliquam semper ipsum sit amet velit. Suspendisse id sem consectetuer libero luctus adipiscing.
> 
> > Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus.
> 
> It doesn't matter what number you use, I will render them sequentially. So you might want to start each line with `1.` and let me sort it out

### 列表

1. This is a list item with two paragraphs. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aliquam hendrerit mi posuere lectus.

   Vestibulum enim wisi, viverra nec, fringilla in, laoreet vitae, risus. Donec sit amet nisl. Aliquam semper ipsum sit amet velit.

2. Suspendisse id sem consectetuer libero luctus adipiscing.

数字开头的非列表要使用转义，否则会被理解为列表，比如：

2001\. What a great season.

## 表格

This is a table:

First Header  | Second Header
------------- | -------------
Content Cell  | Content Cell
Content Cell  | Content Cell

You can align cell contents with syntax like this:

| Left Aligned  | Center Aligned  | Right Aligned |
|:------------- |:---------------:| -------------:|
| col 3 is      | some wordy text |         $1600 |
| col 2 is      | centered        |           $12 |
| zebra stripes | are neat        |            $1 |

## 代码块

Here is an example of AppleScript:

    tell application "Foo"
        beep
    end tell

or fenced code block

```
tell application "Foo"
    beep
end tell
```

or

~~~python
tell application "Foo"
    beep
end tell
~~~

## 水平线

*    *        *

---

## 链接

### 内联链接

This is [an example](http://example.com/ "Optional title") inline link.

### 引用链接

This is [an example][id] reference-style link. Visit [Daring Fireball][] for more information.

[id]: http://example.com/ "Optional Title Here"
[Daring Fireball]: http://daringfireball.net/

### 直接地址

Just put angle brackets around an email <uranusjr@gmail.com> or url <http://macdown.uranusjr.com>

## 图片

### 内联图片

![Alt text](/path/to/img.jpg)

![Alt text](/path/to/img.jpg "Optional title")

### 引用图片

![Alt text][id]

[id]: /path/to/img.jpg "Optional title"

## 强调

*single asterisks*

_single underscores_

**double asterisks**

__double underscores__

un*frigging*believable

un * frigging * believable

\*this text is surrounded by literal asterisks\*

## 反斜杠转义

```
\   backslash
`   backtick
*   asterisk
_   underscore
{}  curly braces
[]  square brackets
()  parentheses
#   hash mark
+   plus sign
-   minus sign (hyphen)
.   dot
!   exclamation mark
```
