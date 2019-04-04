title : iOS 项目自动打包教程
author : Kevin Wu
date : 2015/10/22
categories : ["ios"]


## 安装 xctool

xctool 是 facebook 开源的一个命令行工具，用来替代 xcodebuild，它的用法与 xcodebuild 比较相似。

    brew install xctool

## 新建 configuration

工程默认有 Debug 和 Release 两个 configuration，自动打包的时候应该使用 Release 配置，让测试人员使用与上线版本相同的包来测试。有时候会遇到一种情况，给测试人员的包不能使用正式服务器，或者某些其它正式的资源，这时可以用一个介于 Debug 和 Release 之间的 configuration 来解决这个问题。操作步骤如下：

  * 在项目属性 Info 页面的 Configurations 条目下点击加号，选择 Duplicate "Release" Configuration；
  * 修改新 Configuration 的名字为 Daily；
  * 将 Daily 的 Based on Configuration File 设置为 None；
  * 在 Podfile 中添加 project 'PROJECT_NAME', 'Daily' => :release；
  * 运行 `pod update`。

在 Build Settings 下添加 DAILY 宏比较麻烦，我们可以使用更方便的手段来达到此目的。方法是在 Podfile 中添加脚本，脚本会在 CocoaPods 工作结束后运行，此脚本的功能是修改 *.xcconfig 文件，并在其中添加 DAILY 宏的定义，脚本如下：

    # Add daily build macro into xcconfig file
    post_install do |installer|
    
      installer.pods_project.targets.each do |target|
        if target.name =~ /\APods-/
    
          puts "Update #{target.name}.xcconfig"
    
          file_name = "./Pods/Target Support Files/#{target.name}/#{target.name}.daily.xcconfig"
          text = ""
          File.readlines(file_name).each do |line|
            if line =~ /^GCC_PREPROCESSOR_DEFINITIONS.*$/
              new_line = line.gsub("\n", "")
              text += "#{new_line} DAILY=1\n"
            else
              text += line
            end
          end
          File.open(file_name, "w") {|file| file.puts text }
    
        end
      end
    
    end

经过这几个步骤，在编写代码的时候如果检测到 DEBUG 宏，表示给程序员自己测试的版本，他们可以给界面预先填上帐号密码等数据，节省自己输入的时间；如果检测到 DAILY 宏，表示给测试人员的版本，这时就不能填上测试数据，要按照上线版本的要求做；如果两个宏都没检测到，表示要上线的版本，要做出相应的处理。

## 开始编译

    // 编译 project
    xctool build \
      -destination generic/platform=iOS \
      -project ProjectName.xcodeproj \
      -scheme SchemeName \
      -configuration Daily \
      -sdk iphoneos \
      OBJROOT=${BUILD_ROOT} SYMROOT=${BUILD_ROOT}
    
    // 编译 workspace
    xctool build \
      -destination generic/platform=iOS \
      -workspace WorkspaceName.xcworkspace \
      -scheme SchemeName \
      -configuration Daily \
      -sdk iphoneos \
      OBJROOT=${BUILD_ROOT} SYMROOT=${BUILD_ROOT}

## 开始打包

    cd ${BUILD_ROOT}
    mkdir Payload
    cp -r Daily-iphoneos/${APP_NAME}.app Payload
    zip -rq ${APP_NAME}.ipa Payload

## 上传 FTP

    ftp -u ftp://user:password@ftp.xxx.com/aaa/bbb.ipa ${APP_NAME}.ipa

## 发送邮件

    import sys, smtplib, email
    
    # Settings
    SMTP_SERVER = 'smtp.exmail.qq.com'
    SMTP_PORT = 25
    
    SMTP_USERNAME = 'aaa@xxx.com'
    SMTP_PASSWORD = '123456'
    
    SMTP_FROM = 'aaa@xxx.com'
    SMTP_TO = 'bbb@xxx.com'
    SMTP_CC = 'ccc@xxx.com,ddd@xxx.com'
    
    ADDR_TO = ['bbb@xxx.com', 'ccc@xxx.com', 'ddd@xxx.com']
    
    
    # Build message
    message = email.MIMEMultipart.MIMEMultipart()
    body = email.MIMEText.MIMEText(open(sys.argv[2]).read())
    message.attach(body)
    message.add_header('From', SMTP_FROM)
    message.add_header('To', SMTP_TO)
    message.add_header('Cc', SMTP_CC)
    message.add_header('Subject', sys.argv[1])
    
    
    # Send the message
    mailer = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
    mailer.login(SMTP_USERNAME, SMTP_PASSWORD)
    mailer.sendmail(SMTP_FROM, ADDR_TO, message.as_string())
    mailer.quit()

以上代码是 python 脚本，是笔者通过网上代码修改而成，它将第一个参数作为邮件主题，第二个参数作为邮件内容文件。笔者没学过 python，不过，天下武功出少林，大部分程序的代码都是差不多的。使用此脚本的时候要注意一点，SMTP\_TO 和 SMTP\_CC 是用来定义邮件头部信息，并不作为真正接收者，真正的接收者放到 ADDR_TO 中，且不分收件人和抄送人。
