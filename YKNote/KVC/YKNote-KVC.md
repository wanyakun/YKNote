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
   - 否则（找不到存取器方法），查找`-countOf<Key>`, `-indexIn<Key>OfObject:`, `-objectIn<Key>AtIndex:`和`-<key>AtIndexes:`，如果count方法，index方法和另外两个方法中至少一个方法找到，返回一个能够响应NSOrderedSet所有方法的代理集合对象。每个NSOrderedSet消息发送给代理集合对象时，当消息发送给原始接收器的`valueForKey:`都会被转换成`-countOf<Key>`, `-indexIn<Key>OfObject:`, `-objectIn<Key>AtIndex:`和`-<key>AtIndexes:`的组合来返回。如果实现了可选方法`-get<Key>:range:`，方法也将被调用来进行性能优化。
   - 否则（找不到存取器方法和NSOrderedSet访问方法），查找`-countOf<Key>`, `-objectIn<Key>AtIndex:`和`-<key>AtIndexes:`，如果count方法和另外两个方法中至少一个方法找到，返回一个能够响应NSArray所有方法的代理集合对象。每个NSArray消息发送给代理集合对象时，当消息发送给原始接收器的`valueForKey:`都会被转换成`-countOf<Key>`, `-objectIn<Key>AtIndex:`和`-<key>AtIndexes:`的组合来返回。如果实现了可选方法`-get<Key>:range:`，方法也将被调用来进行性能优化。
   - 否则（找不到存取器方法、NSOrderedSet访问方法和array访问方法），查找`-countOf<Key>`, `-enumeratorOf<Key>`和`-memberOf<Key>:`，如果三个方法都找到，返回一个能够响应NSSet所有方法的代理集合对象。每个NSSet消息发送给代理集合对象时，当消息发送给原始接收器的`valueForKey:`都会被转换成`-countOf<Key>`, `-enumeratorOf<Key>`和`-memberOf<key>:`的组合来返回。
   - 否则（找不到存取器方法和集合访问方法），如果+accessInstanceVariablesDirectly属性返回YES，则按顺序查找符合名称`_< key >`,` _is< Key >`,` < key >`, 或者 `is< Key >`的实例变量。如果找到实例变量，则返回实例变量的值，转换NSNumber和NSValue同步骤1.
   - 否则（找不到存取器方法，集合访问方法和实例变量），调用`-valueForUndefinedKey:`返回结果。`-valueForUndefinedKey:`的默认实现是抛出一个NSUndefinedKeyException异常，但是你覆盖此方法。
2. setValue: forKey: （setValue: forKeyPath:类似）
   - 首先，查找类存取器方法`-set<Key>:`。如果找到此方法则检测参数类型。如果参数类型不是对象指针类型但值是nil，则调用`-setNilValueForKey:`方法，`-setNilValueForKey:`方法的默认实现是抛出一个NSInvalidArgumentException异常，但是你可以覆盖此方法。否则如果方法参数类型是对象指针类型，则直接调用此方法并传入value做为参数。如果方法参数类型是其他类型，NSNumber/NSValue的逆转换在方法`-valueFor<Key>`被调用的时候执行。
   - 否则（没有存取器方法），如果+accessInstanceVariablesDirectly属性返回YES，则按顺序查找符合名称`_< key >`,` _is< Key >`,` < key >`, 或者 `is< Key >`的实例变量。如果找到实例变量，并且它的类型是对象指针类型，则对旧值进行release操作，然后对value进行retain操作并赋值给实例变量。如果是其他类型，则同步骤1进行NSNumber/NSValue进行转换然后再赋值。
   - 否则（没有存取器方法和实例变量），调用`setValue:forUndefinedkey:`方法，`setValue:forUndefinedkey:`方法的默认实现是抛出一个NSUndefinedKeyException异常，但是你可以覆盖此方法。