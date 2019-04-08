---
title: "CocoaPods 用法"
author: "Kevin Wu"
date: "2014/12/30"
category: ["ios"]
---


## 安装

CocoaPods 是用 Ruby 实现的，所以使用它需要用到 Ruby 环境。Ruby 的官方软件源使用的是亚马逊的云服务，在国内访问有问题，需要将官方的源替换成国内淘宝提供的源。

~~~
# 更新 Ruby 软件源
gem sources --remove https://rubygems.org/
gem sources -a http://ruby.taobao.org/
gem sources -l
# 淘宝源已不再维护
gem sources -a http://gems.gzruby.org/

# 安装 CocoaPods
sudo gem install cocoapods
pod setup
~~~

## 使用

CocoaPods 的配置文件叫 Podfile，里面包含依赖库名称、项目平台等信息，在使用 CocoaPods 之前创建此文件，并放到项目的根目录里面，事实上 Podfile 文件可以放到任何目录，这样就需要在 Podfile 文件中增加 xcodeproj 行来指定项目工程文件路径。Podfile 文件的具体规则参见 Podfile 语法参考。

Podfile 编辑完成后便可开始配置项目，需要注意的是每次修改 Podfile 后都应该对项目进行更新。

~~~
# 配置项目，当 Podfile 条目有增删时用
pod install

# 更新项目，仅仅用于更新条目到新版本
pod update
~~~

## 查找库

如果不知道 CocoaPods 管理的库中是否有某库，可以通过搜索命令进行检查。

~~~
# 搜索 json 相关的库
pod search json
~~~

## 使用缓存索引

CocoaPods 在配置项目和更新项目时，会默认先更新 podspec 索引。可以禁止其更新索引，从而更快完成任务。

~~~
# 配置项目（使用缓存索引）
pod install --no-repo-update

# 更新项目（使用缓存索引）
pod update --no-repo-update
~~~

## Podfile 语法

Podfile 本质上是用来描述 Xcode 工程中 target 的依赖。如果不显式指定 target，Podfile 会隐式地创建一个名为 default 的 target，这个隐式的 target 与工程中第一个 target 相对应。换句话说，如果 Podfile 文件中没有指定 target，那么只有工程里的第一个 target 能够使用 Podfile 中描述的依赖库。

platform 语句描述静态库编译的平台和版本，支持的平台主要包括移动平台（即 iOS）和桌面平台（即 OS X），目前移动平台默认的编译版本是 4.3，桌面平台是 10.6。

~~~
# 编译版本采用默认值 4.3
platform :ios

# 显示指定编译版本为 5.0
platform :ios, '5.0'


# 使用最新版本
pod 'OpenUDID'

# 使用 0.1 版本
pod 'OpenUDID', '0.1'

# 使用任何大于 0.1 的版本
pod 'OpenUDID', '> 0.1'

# 使用任何大于等于 0.1 的版本
pod 'OpenUDID', '>= 0.1'

# 使用任何小于 0.1 的版本
pod 'OpenUDID', '< 0.1'

# 使用任何小于等于 0.1 的版本
pod 'OpenUDID', '<= 0.1'

# 使用任何大于等于 0.1.2 且小于 0.2 的版本
pod 'OpenUDID', '~> 0.1.2'
~~~

## 发布库

### 发布准备

将需要发布的工具库项目托管到 GitHub，修改代码直到功能完善。然后，针对功能完善的代码新建 tag，标签名字为版本号，如 1.0.2。

~~~
git tag -a 1.0.2 -m "Release 1.0.2"
git push origin --tags
~~~

### 注册

发布流程的第一步是用邮箱地址注册帐号，这会在当前机器上开启一个新的会话。

~~~
pod trunk register kvmisc@163.com "Kevin Wu" --description="home" --verbose
~~~

命令中的描述是可选信息，它在用户查看会话列表的时候会有所帮助，列出所有会话可以用 `pod trunk me`。

### 配置

新建一个 podspec 文件，这个文件包含了 pod 所有的配置信息。

~~~
Pod::Spec.new do |s|
  s.name         = "tapkit"
  s.version      = "1.0.2"
  s.summary      = "An Objective-C library for iPhone developers."
  s.homepage     = "https://github.com/kvmisc/tapkit"
  s.license      = "MIT"
  s.author       = { "Kevin Wu" => "kvmisc@163.com" }
  s.social_media_url = "https://twitter.com/kvmisc"
  s.platform     = :ios, "6.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/kvmisc/tapkit.git", :tag => s.version.to_s }
  s.source_files  = "tapkit/*"
end
~~~

接着验证 podspec 文件的正确性，同时也会验证代码的正确性，代码中的警告会导致验证失败。

~~~
pod lib lint
~~~

### 推送

podspec 文件验证通过以后，可以直接将 pod 推送到公共仓库中。

~~~
pod trunk push tapkit.podspec
~~~

如果发布成功，@CocoaPodsFeed 会在 Twitter 上艾特你。此时可以运行 `pod setup` 来更新本地 Pods 依赖库，再使用 `pod search xxx` 来查找刚刚加入的工具库。
