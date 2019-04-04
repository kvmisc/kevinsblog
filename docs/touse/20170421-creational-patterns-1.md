title : 设计模式：创建型模式（一）
author : Kevin Wu
date : 2017/04/21
categories : ["design-pattern", "ios"]


## 简单工厂模式

    @interface Product : NSObject
    @end
    @implementation Product
    @end
    
    @interface ProductA : Product
    @end
    @implementation ProductA
    @end
    
    @interface ProductB : Product
    @end
    @implementation ProductB
    @end
    
    
    @interface Factory : NSObject
    - (Product *)makeProduct:(NSString *)type;
    @end
    @implementation Factory
    - (Product *)makeProduct:(NSString *)type
    {
      if ( [@"ProductA" isEqualToString:type] ) {
        return [[ProductA alloc] init];
      } else if ( [@"ProductB" isEqualToString:type] ) {
        return [[ProductB alloc] init];
      }
      return nil;
    }
    @end
    
    
    // Sample
    Factory *factory = [[Factory alloc] init];
    ProductA *productA = [factory makeProduct:@"ProductA"];
    //ProductB *productB = [factory makeProduct:@"ProductB"];

简单工厂模式实现了生成产品类代码跟客户端代码分离，在工厂类中可以添加生成产品的逻辑代码。但是优秀的代码要符合“开放-封闭”原则，也就是说对扩展开放，对修改关闭，现在如果增加一个产品类 C，就要修改工厂类里面生成产品的代码，增加 if-else 判断。对于这个问题，工厂方法模式可以解决。

## 工厂方法模式

    @interface Product : NSObject
    @end
    @implementation Product
    @end
    
    @interface ProductA : Product
    @end
    @implementation ProductA
    @end
    
    @interface ProductB : Product
    @end
    @implementation ProductB
    @end
    
    
    @interface AbstractFactory : NSObject
    - (Product *)makeProduct;
    @end
    @implementation AbstractFactory
    - (Product *)makeProduct
    {
      return nil;
    }
    @end
    
    @interface ProductAFactory : AbstractFactory
    @end
    @implementation ProductAFactory
    - (Product *)makeProduct
    {
      return [[ProductA alloc] init];
    }
    @end
    
    @interface ProductBFactory : AbstractFactory
    @end
    @implementation ProductBFactory
    - (Product *)makeProduct
    {
      return [[ProductB alloc] init];
    }
    @end


    // Sample
    AbstractFactory *factoryA = [[ProductAFactory alloc] init];
    ProductA *productA = [factoryA makeProduct];
    //AbstractFactory *factoryB = [[ProductBFactory alloc] init];
    //ProductB *productB = [factoryB makeProduct];

工厂方法模式在 Cocoa Touch 框架中几乎随处可见，在 NSNumber 中有一堆 numberWith* 形式的类方法，这些方法并不是用来让子类重载，它们是工厂方法模式的变体，NSNumber 类用它们生成具体的子类实例，而不需调用子类的工厂类来生成子类实例，这个变体叫做类工厂方法。

工厂方法模式把生成产品的时间延迟，就是通过对应的工厂类来生成对应的产品，这样就可以实现“开放-封闭”原则，无论加多少产品类，都不用修改原来类中的代码，而是通过增加工厂类来实现。但是这还是有缺点，如果产品类过多，就要生成很多的工厂类。假如要实现的产品接口不止一个，不同产品接口有对应的产品族。什么是产品族呢？简单的理解就是，不同品牌生产的车里面会有跑车类型，SUV类型，商用类型等的车，不同品牌跑车类型的车可以组成一个产品族。对于这种情况可以采用抽象工厂模式。

## 抽象工厂模式

    @interface Button : NSObject
    @end
    @implementation Button
    @end
    
    @interface WinButton : Button
    @end
    @implementation WinButton
    @end
    
    @interface OSXButton : Button
    @end
    @implementation OSXButton
    @end
    
    
    @interface Label : NSObject
    @end
    @implementation Label
    @end
    
    @interface WinLabel : Label
    @end
    @implementation WinLabel
    @end
    
    @interface OSXLabel : Label
    @end
    @implementation OSXLabel
    @end
    
    
    @interface AbstractGUIFactory : NSObject
    - (Button *)makeButton;
    - (Label *)makeLabel;
    @end
    @implementation AbstractGUIFactory
    - (Button *)makeButton
    {
      return nil;
    }
    - (Label *)makeLabel
    {
      return nil;
    }
    @end
    
    @interface WinGUIFactory : AbstractGUIFactory
    @end
    @implementation WinGUIFactory
    - (Button *)makeButton
    {
      return [[WinButton alloc] init];
    }
    - (Label *)makeLabel
    {
      return [[WinLabel alloc] init];
    }
    @end
    
    @interface OSXGUIFactory : AbstractGUIFactory
    @end
    @implementation OSXGUIFactory
    - (Button *)makeButton
    {
      return [[OSXButton alloc] init];
    }
    - (Label *)makeLabel
    {
      return [[OSXLabel alloc] init];
    }
    @end
    
    
    // Sample
    AbstractGUIFactory *factory = [[WinGUIFactory alloc] init];
    Button *button = [factory makeButton];
    Label *label = [factory makeLabel];
    //AbstractGUIFactory *factory = [[OSXGUIFactory alloc] init];
    //Button *button = [factory makeButton];
    //Label *label = [factory makeLabel];
