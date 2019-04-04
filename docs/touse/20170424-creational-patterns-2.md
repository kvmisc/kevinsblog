title : 设计模式：创建型模式（二）
author : Kevin Wu
date : 2017/04/24
categories : ["design-pattern", "ios"]


## 原型模式

原型模式（Prototype Pattern）用于创建重复的对象，同时又能保证性能。它使用原型实例指定创建对象的种类，并通过复制这个原型创建新的对象。

这种模式实现了一个原型接口，该接口用于创建当前对象的克隆。当直接创建对象的代价比较大时，则采用这种模式。与通过对一个类进行实例化来构造新对象不同的是，原型模式是通过拷贝一个现有对象生成新对象的。

    @interface Prototype : NSObject <NSCopying>
    @property (nonatomic, assign) NSInteger foobar;
    @end
    
    @implementation Prototype
    - (id)copyWithZone:(NSZone *)zone
    {
      Prototype *cpy = [[[self class] allocWithZone:zone] init];
      cpy.foobar = _foobar;
      return cpy;
    }
    @end
    
    
    // Sample
    Prototype *obj1 = [[Prototype alloc] init];
    Prototype *obj2 = [obj1 copy];

## 建造者模式

建造者模式（Builder Pattern）使用多个简单的对象一步一步构建成一个复杂的对象。将一个复杂对象的构建与它的表现分离，使得同样的构建过程可以创建不同的表现。

建造者模式能帮助构建涉及部件与表现的各种组合对象，如果没有这一模式，知道构建对象所需细节的 Director 可能最终会变成一个庞大的“神”类，带有无数用于构建同一个类各种表现的内嵌算法。

    // Product
    @interface Pizza : NSObject
    @property (nonatomic, copy) NSString *dough;
    @property (nonatomic, copy) NSString *sauce;
    @property (nonatomic, copy) NSString *topping;
    @end
    @implementation Pizza
    @end
    
    
    // Abstract Builder
    @interface AbstractPizzaBuilder : NSObject
    @property (nonatomic, strong, readonly) Pizza *pizza;
    - (void)prepareNewPizza;
    - (void)buildDough;
    - (void)buildSauce;
    - (void)buildTopping;
    @end
    @implementation AbstractPizzaBuilder
    - (void)prepareNewPizza
    {
      _pizza = [[Pizza alloc] init];
    }
    - (void)buildDough
    {
    }
    - (void)buildSauce
    {
    }
    - (void)buildTopping
    {
    }
    @end
    
    // Concrete Builder
    @interface HawaiianPizzaBuilder : AbstractPizzaBuilder
    @end
    @implementation HawaiianPizzaBuilder
    - (void)buildDough
    {
      self.pizza.dough = @"cross";
    }
    - (void)buildSauce
    {
      self.pizza.sauce = @"mild";
    }
    - (void)buildTopping
    {
      self.pizza.topping = @"ham+pineapple";
    }
    @end
    
    // Concrete Builder
    @interface SpicyPizzaBuilder : AbstractPizzaBuilder
    @end
    @implementation SpicyPizzaBuilder
    - (void)buildDough
    {
      self.pizza.dough = @"pan baked";
    }
    - (void)buildSauce
    {
      self.pizza.sauce = @"hot";
    }
    - (void)buildTopping
    {
      self.pizza.topping = @"pepperoni+salami";
    }
    @end
    
    
    // Director
    @interface Waiter : NSObject
    @property (nonatomic, strong) AbstractPizzaBuilder *builder;
    - (void)makePizza;
    - (Pizza *)getPizza;
    @end
    @implementation Waiter
    - (void)makePizza
    {
      [_builder prepareNewPizza];
      [_builder buildDough];
      [_builder buildSauce];
      [_builder buildTopping];
    }
    - (Pizza *)getPizza
    {
      return _builder.pizza;
    }
    @end
    
    
    // Sample
    Waiter *waiter = [[Waiter alloc] init];
    AbstractPizzaBuilder *hawaiianPizzaBuilder = [[HawaiianPizzaBuilder alloc] init];
    //AbstractPizzaBuilder *spicyPizzaBuilder = [[SpicyPizzaBuilder alloc] init];
    waiter.builder = hawaiianPizzaBuilder;
    [waiter makePizza];
    Pizza *pizza = [waiter getPizza];

## 单例模式

单例模式（Singleton Pattern）是最简单的设计模式之一。它保证一个类仅有一个实例，并提供一个访问它的全局访问点。

    @interface Singleton : NSObject
    + (id)sharedObject;
    @end
    
    @implementation Singleton
    + (id)sharedObject
    {
      static Singleton *SharedSingleton = nil;
      @synchronized([Singleton class]) {
        if ( !SharedSingleton ) {
          SharedSingleton = [[self alloc] init];
        }
        return SharedSingleton;
      }
      return nil;
    }
    @end
