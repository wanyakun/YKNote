## KVC的原理实现

### 一、什么是KVC

官方文档：https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueCoding/index.html#//apple_ref/doc/uid/10000107i

 KVC(Key-Value Coding)是Objective-C提供的一种利用字符串来间接访问对象属性的一种机制，它是通过访问器去访问对象属性的另一个可选方案。非正式协议NSKeyValueCoding对其接口进行了定义，NSObject中提供了接口的默认实现。

### 二、常见方法

```objc

//获取方法
- (nullable id)valueForKey:(NSString *)key;

- (nullable id)valueForKeyPath:(NSString *)keyPath;

- (nullable id)valueForUndefinedKey:(NSString *)key;

//可变集合获取方法
- (NSMutableArray *)mutableArrayValueForKey:(NSString *)key;

- (NSMutableOrderedSet *)mutableOrderedSetValueForKey:(NSString *)key NS_AVAILABLE(10_7, 5_0);

- (NSMutableSet *)mutableSetValueForKey:(NSString *)key;

- (NSMutableArray *)mutableArrayValueForKeyPath:(NSString *)keyPath;

- (NSMutableOrderedSet *)mutableOrderedSetValueForKeyPath:(NSString *)keyPath NS_AVAILABLE(10_7, 5_0);

- (NSMutableSet *)mutableSetValueForKeyPath:(NSString *)keyPath;

//设置方法
- (void)setValue:(nullable id)value forKey:(NSString *)key;

- (void)setValue:(nullable id)value forKeyPath:(NSString *)keyPath;

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key;

- (void)setNilValueForKey:(NSString *)key;

```

### 三、KVC原理

> 通过查找头文件NSKeyValueCoding.h注释可以发现KVC的执行过程

1. valueForKey:（valueForKeyPath:类似）
   - 首先，在对象类中按顺序查找存取器名称为`-get<key>`, `-<key>`, `-is<key>`的方法，如果找到则直接调用，如果方法返回结果类型为指针类型，则直接返回。如果方法返回结果类型是数量类型支持NSNumber转换，则返回NSNumber，否则转化成NSValue并返回（任意类型的结果转换成NSValue，不仅NSPoint，NSRect和NSSize）；
   - 否则（找不到存取器方法），查找`-countOf<Key>`, `-indexIn<Key>OfObject:`, `-objectIn<Key>AtIndex:`和`-<key>AtIndexes:`，如果count方法，index方法和另外两个方法中至少一个方法找到，返回一个能够响应NSOrderedSet所有方法的代理集合对象（*NSKeyValueOrderedSet*）。每个NSOrderedSet消息发送给代理集合对象时，当消息发送给原始接收器的`valueForKey:`都会被转换成`-countOf<Key>`, `-indexIn<Key>OfObject:`, `-objectIn<Key>AtIndex:`和`-<key>AtIndexes:`的组合来返回。如果实现了可选方法`-get<Key>:range:`，方法也将被调用来进行性能优化。
   - 否则（找不到存取器方法和NSOrderedSet访问方法），查找`-countOf<Key>`, `-objectIn<Key>AtIndex:`和`-<key>AtIndexes:`，如果count方法和另外两个方法中至少一个方法找到，返回一个能够响应NSArray所有方法的代理集合对象。每个NSArray消息发送给代理集合对象时（*NSKeyValueArray*），当消息发送给原始接收器的`valueForKey:`都会被转换成`-countOf<Key>`, `-objectIn<Key>AtIndex:`和`-<key>AtIndexes:`的组合来返回。如果实现了可选方法`-get<Key>:range:`，方法也将被调用来进行性能优化。
   - 否则（找不到存取器方法、NSOrderedSet访问方法和array访问方法），查找`-countOf<Key>`, `-enumeratorOf<Key>`和`-memberOf<Key>:`，如果三个方法都找到，返回一个能够响应NSSet所有方法的代理集合对象（NSKeyValueSet）。每个NSSet消息发送给代理集合对象时，当消息发送给原始接收器的`valueForKey:`都会被转换成`-countOf<Key>`, `-enumeratorOf<Key>`和`-memberOf<key>:`的组合来返回。
   - 否则（找不到存取器方法和集合访问方法），如果+accessInstanceVariablesDirectly属性返回YES，则按顺序查找符合名称`_< key >`,` _is< Key >`,` < key >`, 或者 `is< Key >`的实例变量。如果找到实例变量，则返回实例变量的值，转换NSNumber和NSValue同步骤1.
   - 否则（找不到存取器方法，集合访问方法和实例变量），调用`-valueForUndefinedKey:`返回结果。`-valueForUndefinedKey:`的默认实现是抛出一个NSUndefinedKeyException异常，但是你覆盖此方法。

   **注意：**

   对于集合(NSArray, NSSet, NSOrderSet)像使用普通对象一样，则返回代理对象，需要实现以下方法


| NSArray                   | NSSet                 | NSOrderSet                |
| ------------------------- | --------------------- | ------------------------- |
| ` -countOf<Key>`          | ` -countOf<Key>`      | ` -countOf<Key>`          |
|                           | ` -enumeratorOf<Key>` | ` -indexIn<Key>OfObject:` |
| *One of*                  | ` -memberOf<Key>:`    | *One of*                  |
| ` -objectIn<Key>AtIndex:` |                       | ` -objectIn<Key>AtIndex:` |
| ` -<key>AtIndexes:`       |                       | ` -<key>AtIndexes:`       |
| *Optional (performance)*  |                       | *Optional (performance)*  |
| ` -get<Key>:range:`       |                       | ` -get<Key>:range:`       |

2. setValue: forKey: （setValue: forKeyPath:类似）

   - 首先，查找类存取器方法`-set<Key>:`。如果找到此方法则检测参数类型。如果参数类型不是对象指针类型但值是nil，则调用`-setNilValueForKey:`方法，`-setNilValueForKey:`方法的默认实现是抛出一个NSInvalidArgumentException异常，但是你可以覆盖此方法。否则如果方法参数类型是对象指针类型，则直接调用此方法并传入value做为参数。如果方法参数类型是其他类型，NSNumber/NSValue的逆转换在方法`-valueFor<Key>`被调用的时候执行。
   - 否则（没有存取器方法），如果+accessInstanceVariablesDirectly属性返回YES，则按顺序查找符合名称`_< key >`,` _is< Key >`,` < key >`, 或者 `is< Key >`的实例变量。如果找到实例变量，并且它的类型是对象指针类型，则对旧值进行release操作，然后对value进行retain操作并赋值给实例变量。如果是其他类型，则同步骤1进行NSNumber/NSValue进行转换然后再赋值。
   - 否则（没有存取器方法和实例变量），调用`setValue:forUndefinedkey:`方法，`setValue:forUndefinedkey:`方法的默认实现是抛出一个NSUndefinedKeyException异常，但是你可以覆盖此方法。

3. 可变集合`-mutableArrayValueForKey:key`，`-mutableOrderedSetValueForKey:key`，`-mutableSetValueForKey:key`

   默认实现存取器方法时和`-valueForKey:key`一样。返回代理对象时需要实现的方法有差别。如下：


| NSMutableArray / NSMutableOrderedSet     | NSMutableSet                             |
| ---------------------------------------- | ---------------------------------------- |
| *At least 1 insertion and 1 removal method* | * At least 1 addition and 1 removal method |
| ` -insertObject:in<Key>AtIndex:`         | ` -add<Key>Object:`                      |
| ` -removeObjectFrom<Key>AtIndex:`        | ` -remove<Key>Object:`                   |
| ` -insert<Key>:atIndexes:`               | ` -add<Key>:`                            |
| ` -remove<Key>AtIndexes:`                | ` -remove<Key>:`                         |
| *Optional (performance) one of*          | * Optional (performance)                 |
| ` -replaceObjectIn<Key>AtIndex:withObject:` | ` -intersect<Key>:`                      |
| ` -replace<Key>AtIndexes:with<Key>:`     | ` -set<Key>:`                            |

### 四、实例

#### 1. 创建YKNoteKVCObject类

```objc
//
//  YKNoteKVCObject.h
//  YKNote
//
//  Created by wanyakun on 2016/11/10.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKNoteKVCObject : NSObject {
    NSInteger _intVar;
    NSString *_strVar;
}

@property (nonatomic, assign) NSInteger intProperty;
@property (nonatomic, copy) NSString *strProperty;

@end

//
//  YKNoteKVCObject.m
//  YKNote
//
//  Created by wanyakun on 2016/11/10.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteKVCObject.h"


@implementation YKNoteKVCObject

@synthesize intProperty = _intProperty;
@synthesize strProperty = _strProperty;

#pragma mark - method for orderSet
- (NSUInteger)countOfOrderSet {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return 5;
}

- (NSInteger)indexInOrderSetOfObject:(id)element {
    return 2;
}

- (id)objectInOrderSetAtIndex:(NSUInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [NSString stringWithFormat:@"orderSet_%ld", index];
}

#pragma mark - method for array
- (NSUInteger)countOfArray {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return 10;
}

- (id)objectInArrayAtIndex:(NSUInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [NSString stringWithFormat:@"array_%ld", index];
}

#pragma mark - mehtod for set
- (NSUInteger)countOfSet {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return 15;
}

- (NSEnumerator *)enumeratorOfSet {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSEnumerator *enumerator = [[NSEnumerator alloc] init];
    return enumerator;
}

- (NSString *)memberOfSet:(NSString *)object {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [NSString stringWithFormat:@"member of set: %@", object];
}

#pragma mark - method for MutableOrderedSet
- (void)insertObject:(NSString *)object inMOrderSetAtIndex:(NSUInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)removeObjectFromMOrderSetAtIndex:(NSUInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - method for MutableArray
- (void)insertObject:(NSString *)object inMArrayAtIndex:(NSUInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)removeObjectFromMArrayAtIndex:(NSUInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - method for mutableSet
- (void)addMSetObject:(NSString *)object {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)removeMSetObject:(NSString *)object {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - private method
- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"%s\nValueForUndefinedKey:%@", __PRETTY_FUNCTION__, key);
    return @"undefinedKeyValue";
}

- (void)setNilValueForKey:(NSString *)key {
    NSLog(@"%s\nNilValueKey:%@", __PRETTY_FUNCTION__, key);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%s\nundefineKey:%@", __PRETTY_FUNCTION__, key);
}

+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}


#pragma mark getter setter
- (NSInteger)intProperty {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return _intProperty;
}

- (void)setIntProperty:(NSInteger)intProperty {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _intProperty = intProperty;
}

- (NSString *)strProperty {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return _strProperty;
}

- (void)setStrProperty:(NSString *)strProperty {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _strProperty = [strProperty copy];
}

@end
```

#### 2. 创建Controller，用来调用setValue:ForKey:和valueForKey:等

```objc
//
//  YKNoteKVCViewController.m
//  YKNote
//
//  Created by wanyakun on 2016/11/11.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteKVCViewController.h"
#import "YKNoteKVCObject.h"
#import <objc/runtime.h>

@interface YKNoteKVCViewController ()

@property (nonatomic, strong) YKNoteKVCObject *yKNoteKVCObject;

@end

@implementation YKNoteKVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"KVC";
    self.view.backgroundColor = [UIColor whiteColor];
    //通过存取器访问
    [self.yKNoteKVCObject setValue:[NSNumber numberWithInteger:10] forKey:@"intProperty"];
    NSInteger intProperty = [[self.yKNoteKVCObject valueForKey:@"intProperty"] integerValue];
    NSLog(@"intProperty = %ld", intProperty);
    
    [self.yKNoteKVCObject setValue:@"I am strProperty" forKey:@"strProperty"];
    NSString *strProperty = [self.yKNoteKVCObject valueForKey:@"strProperty"];
    NSLog(@"strProperty = %@", strProperty);
    
    //通过实例变量访问
    [self.yKNoteKVCObject setValue:[NSNumber numberWithInteger:20] forKey:@"intVar"];
    NSInteger intVar = [[self.yKNoteKVCObject valueForKey:@"intVar"] integerValue];
    NSLog(@"intVar = %ld", intVar);

    [self.yKNoteKVCObject setValue:@"I am strVar" forKey:@"strVar"];
    NSString *strVar = [self.yKNoteKVCObject valueForKey:@"strVar"];
    NSLog(@"strVar = %@", strVar);

    //set undefineKey
    [self.yKNoteKVCObject setValue:@"undefine value" forKey:@"undefinedKey"];

    //为非Object pointer参数类型设置nil
    [self.yKNoteKVCObject setValue:nil forKey:@"intProperty"];

    //NSOrderSet, NSArray, NSSet代理对象
    id orderSet = [self.yKNoteKVCObject valueForKey:@"orderSet"];
    id array = [self.yKNoteKVCObject valueForKey:@"array"];
    id set = [self.yKNoteKVCObject valueForKey:@"set"];
    NSLog(@"\norderSet class:%@\narray class:%@\nset class:%@", object_getClass(orderSet), object_getClass(array), object_getClass(set));
    
    //NSMutableOrderSet, NSMutableArray, NSMutableSet代理对象
    id mutableOrderSet = [self.yKNoteKVCObject mutableOrderedSetValueForKey:@"mOrderSet"];
    id mutableArray = [self.yKNoteKVCObject mutableArrayValueForKey:@"mArray"];
    id mutableSet = [self.yKNoteKVCObject mutableSetValueForKey:@"mSet"];
    NSLog(@"\nmutableOrderSet class:%@\nmutableArray class:%@\nmutableSet class:%@", object_getClass(mutableOrderSet), object_getClass(mutableArray), object_getClass(mutableSet));
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - getter
- (YKNoteKVCObject *)yKNoteKVCObject {
    if (_yKNoteKVCObject == nil) {
        _yKNoteKVCObject = [[YKNoteKVCObject alloc] init];
    }
    return _yKNoteKVCObject;
}

@end
```

#### 3. 输出结果

```objective-c
-[YKNoteKVCObject setIntProperty:]
-[YKNoteKVCObject intProperty]
intProperty = 10
-[YKNoteKVCObject setStrProperty:]
-[YKNoteKVCObject strProperty]
strProperty = I am strProperty
intVar = 20
strVar = I am strVar
-[YKNoteKVCObject setValue:forUndefinedKey:]
undefineKey:undefinedKey
-[YKNoteKVCObject setNilValueForKey:]
NilValueKey:intProperty
orderSet class:NSKeyValueOrderedSet
array class:NSKeyValueArray
set class:NSKeyValueSet
mutableOrderSet class:NSKeyValueFastMutableOrderedSet2
mutableArray class:NSKeyValueFastMutableArray2
mutableSet class:NSKeyValueFastMutableSet2
```

