title : Masonry 参考
author : Kevin Wu
date : 2016/08/26
categories : ["ios", "masonry"]


## 固定值与相对值

AutoLayout 允许为 width 和 height 设置固定值，而 left、right 或 centerY 这些布局相关的属性却不能设置固定值，如果用 Masonry 给其设置固定值，固定值会被转化为相对于父视图。

    // view.width = 200
    make.width.equalTo(@200);
    
    // view.left = view.superview.left + 10
    make.left.equalTo(@10);

## 混合约束

Masonry 可以使用一些简便方法创建多个约束，这被称为混合约束。

    // top, left, bottom, right equal superview
    make.edges.equalTo(superview);
    
    // top = superview.top + 5
    // left = superview.left + 10,
    // bottom = superview.bottom - 15
    // right = superview.right - 20
    make.edges.equalTo(superview).insets(UIEdgeInsetsMake(5, 10, 15, 20));
    
    
    // width and height greater than or equal to titleLabel
    make.size.greaterThanOrEqualTo(titleLabel);
    
    // width = superview.width + 100
    // height = superview.height - 50
    make.size.equalTo(superview).sizeOffset(CGSizeMake(100, -50));
    
    
    // centerX and centerY = superview
    make.center.equalTo(superview);
    
    // centerX = superview.centerX - 5
    // centerY = superview.centerY + 10
    make.center.equalTo(superview).centerOffset(CGPointMake(-5, 10));

## UIScrollView 的使用

在 UIScrollView 中顺序排列一些 UIView 并自动计算 contentSize。

    UIView *containerView = [[UIView alloc] init];
    [scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(scrollView);
      make.width.equalTo(scrollView);
    }];
    
    UIView *prevView = nil;
    for ( NSInteger i=0; i<10; ++i ) {
      UIView *view = [[UIView alloc] init];
      [containerView addSubview:view];
    
      view.backgroundColor = [UIColor randColor];
    
      [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(prevView ? prevView.mas_bottom : containerView.mas_top);
        make.left.equalTo(containerView);
        make.right.equalTo(containerView);
        make.height.equalTo(@((i+1)*20));
      }];
      prevView = view;
    }
    
    [containerView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(prevView.mas_bottom);
    }];

## 比例视图

按照宽三高一且撑满父视图的方式放置视图。

    [innerView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.width.equalTo(innerView.mas_height).multipliedBy(3);
    
      make.width.height.lessThanOrEqualTo(superview);
      make.width.height.equalTo(superview).priorityLow();
    
      make.center.equalTo(superview);
    }];

## 数组的操作

可以用数组作为参数，也可以对视图数组中所有的视图进行操作。

    make.height.equalTo(@[greenView, blueView]);
    
    [viewAry updateConstraints:^(MASConstraintMaker *make) {
      make.baseline.equalTo(superview.mas_centerY).offset(10);
    }];

## 优先级辨析

一般讲的优先级是约束的属性，另外，还有抗拉和抗压优先级，它们是控件的属性。有固有尺寸的控件在布局时，抗拉和抗压优先级会与控件其它约束的优先级进行比较，从而得出谁先得到满足。

  * Content Hugging Priority 抗拉优先级，数值越高越不容易被拉伸，默认是251；
  * Content Compression Resistance Priority 抗压优先级，数值越高越不容易被压缩，默认是750。
