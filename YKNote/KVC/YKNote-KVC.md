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
   - 首先，在对象类中按顺序查找访问器名称为`-get<key>`, `-<key>`, `-is<key>`的方法 ，
2. setValue: forKey: （setValue: forKeyPath:类似）