## KVO的原理实现

### 一、什么是KVO

[KVO](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html)和Notification是Objective-C语言中[观察者模式](https://zh.wikipedia.org/wiki/%E8%A7%82%E5%AF%9F%E8%80%85%E6%A8%A1%E5%BC%8F)的两种实现机制。KVO指定一个被观察对象，当被观察对象某个属性发生改变时，观察对象会获得通知，你不需要给被观察的对象添加任何额外代码。

> KVO和Notification区别：KVO是被观察者直接发送消息给观察者，是对象间的交互，而Notification则是观察者和被观察者通过通知中心对象之间进行交互，即消息由被观察者发送到通知中心对象，再由中心对象发给观察者，两者之间并不进行直接的交互。

### 二、实现原理

Apple官方文档描述：

> # Key-Value Observing Implementation Details
>
> Automatic key-value observing is implemented using a technique called *isa-swizzling*.
>
> The `isa` pointer, as the name suggests, points to the object's class which maintains a dispatch table. This dispatch table essentially contains pointers to the methods the class implements, among other data.
>
> When an observer is registered for an attribute of an object the isa pointer of the observed object is modified, pointing to an intermediate class rather than at the true class. As a result the value of the isa pointer does not necessarily reflect the actual class of the instance.
>
> You should never rely on the `isa` pointer to determine class membership. Instead, you should use the `class` method to determine the class of an object instance.

从文档中可以看出KVO是通过一项叫做isa-swizzling技术来实现的。当为被观察者属性注册观察者时，被观察者的isa指针被修改，指向一个中间类，而不是真正的类。所以isa指针其实不需要指向实例对象真实的类。我们不要依赖isa指针来确定类成员，相反应该使用类方法来确定实例对象的类。

从网上查到总结如下内容：

当观察某对象时，KVO机制动态创建一个被观察对象类的子类，并为这个新的子类重写了被观察属性keyPath的setter 方法。setter 方法随后负责通知观察对象属性的改变状况。

### 三、使用举例

使用KVO分三步：

- 注册观察者: 

  ```objc
  - (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
  ```

- 观察者中实现

  ```objc
  - (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context;
  ```

- 移除观察者


  ```objc
  - (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context NS_AVAILABLE(10_7, 5_0);
  - (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
  ```

从以上三步可以看出，使用KVO，不需要对被观察者对象做任何修改。






