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

1. 创建一个YKNoteKVOObject类，用于对它属性进行监听

   ```objc
   //
   //  YKNoteKVOObject.h
   //  YKNote
   //
   //  Created by wanyakun on 2016/11/3.
   //  Copyright © 2016年 com.ucaiyuan. All rights reserved.
   //

   #import <Foundation/Foundation.h>

   @interface YKNoteKVOObject : NSObject

   @property (nonatomic, copy) NSString *name;

   @property (nonatomic, assign) NSInteger age;

   @property (nonatomic, assign) CGFloat salary;

   @property (nonatomic, strong) NSMutableArray *friends;

   @end
   ```

2. 创建一个Controller，添加监听，并打印

   ```objc
   //
   //  YKNoteKVOViewController.m
   //  YKNote
   //
   //  Created by wanyakun on 2016/11/7.
   //  Copyright © 2016年 com.ucaiyuan. All rights reserved.
   //

   #import "YKNoteKVOViewController.h"
   #import "YKNoteKVOObject.h"
   #import "YKNoteRuntimeUtils.h"
   #import <objc/runtime.h>

   @interface YKNoteKVOViewController ()

   @property (nonatomic, strong) YKNoteKVOObject *yKNoteKVOObject;
   @property (nonatomic, strong) YKNoteKVOObject *yKNoteKVOObject2;
   @property (nonatomic, strong) YKNoteKVOObject *yKNoteKVOObject3;
   @property (nonatomic, strong) YKNoteKVOObject *yKNoteKVOObject4;

   @property (nonatomic, strong) UITextView *textView;

   @end

   @implementation YKNoteKVOViewController

   - (void)viewDidLoad {
       [super viewDidLoad];
       // Do any additional setup after loading the view.
       [self.view addSubview:self.textView];
       [self.textView fill];
       
       self.yKNoteKVOObject.name = @"YKNoteKVOObject";
       self.yKNoteKVOObject2.name = @"YKNoteKVOObject2";
       self.yKNoteKVOObject3.name = @"YKNoteKVOObject3";
       self.yKNoteKVOObject4.name = @"YKNoteKVOObject4";
       
       self.yKNoteKVOObject.friends = [[NSMutableArray alloc] initWithCapacity:5];
       
       self.textView.text = @"========before add observer objective detail========\n";
       [self addBeforDetailToTextView];
       
       [self addObserver];
       
       self.textView.text = [self.textView.text stringByAppendingString:@"========after add observer objective detail========\n"];
       [self addAfterDetailToTextView];
       
       
       self.textView.text = [self.textView.text stringByAppendingString:@"============cls supeCls============\n"];
       [self addClsSuperClsToTextView];
       
       self.textView.text = [self.textView.text stringByAppendingString:@"============Object IMP============\n"];
       [self addObjectIMPToTextView];
       
       self.textView.text = [self.textView.text stringByAppendingString:@"============Runtime IMP============\n"];
       [self addRuntimeMethodIMPToTextView];
       
       self.textView.text = [self.textView.text stringByAppendingString:@"============Observer change============\n"];
       //自动触发KVO通知
       self.yKNoteKVOObject.name = @"YKNoteKVOObject Change property";
       [self.yKNoteKVOObject setValue:@"YKNoteKVOObject setValue:forKey:" forKey:@"name"];
       [self.yKNoteKVOObject setValue:@"YKNoteKVOObject setValue:forKeyPath:" forKeyPath:@"name"];
       
       NSMutableArray *array = [self.yKNoteKVOObject mutableArrayValueForKey:@"friends"];
       [array addObject:@"wanyakun"];
       //手动触发KVO通知
       self.yKNoteKVOObject.salary = 1000;
   }

   - (void)didReceiveMemoryWarning {
       [super didReceiveMemoryWarning];
       // Dispose of any resources that can be recreated.
   }

   - (void)dealloc {
       [self removeObserver];
       self.yKNoteKVOObject = nil;
       self.yKNoteKVOObject2 = nil;
       self.yKNoteKVOObject3 = nil;
       self.yKNoteKVOObject4 = nil;
       self.textView = nil;
   }

   #pragma mark - private method

   - (void)addObserver {
       [self.yKNoteKVOObject addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
       [self.yKNoteKVOObject2 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
       [self.yKNoteKVOObject3 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
       [self.yKNoteKVOObject3 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
       
       [self.yKNoteKVOObject addObserver:self forKeyPath:@"salary" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
       [self.yKNoteKVOObject addObserver:self forKeyPath:@"friends" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
   }

   - (void)removeObserver {
       [self.yKNoteKVOObject removeObserver:self forKeyPath:@"name"];
       [self.yKNoteKVOObject2 removeObserver:self forKeyPath:@"age"];
       [self.yKNoteKVOObject3 removeObserver:self forKeyPath:@"name"];
       [self.yKNoteKVOObject3 removeObserver:self forKeyPath:@"age"];
       
       [self.yKNoteKVOObject removeObserver:self forKeyPath:@"salary"];
       [self.yKNoteKVOObject removeObserver:self forKeyPath:@"friends"];
   }

   - (void)addBeforDetailToTextView {
       NSString *beforeDetail =  [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject" objc:self.yKNoteKVOObject];
       NSString *beforeDetail2 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject2" objc:self.yKNoteKVOObject2];
       NSString *beforeDetail3 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject3" objc:self.yKNoteKVOObject3];
       NSString *beforeDetail4 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject4" objc:self.yKNoteKVOObject4];
       
       self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@", beforeDetail, beforeDetail2, beforeDetail3, beforeDetail4]];
   }

   - (void)addAfterDetailToTextView {
       NSString *afterDetail =  [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject" objc:self.yKNoteKVOObject];
       NSString *afterDetail2 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject2" objc:self.yKNoteKVOObject2];
       NSString *afterDetail3 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject3" objc:self.yKNoteKVOObject3];
       NSString *afterDetail4 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject4" objc:self.yKNoteKVOObject4];
       
       self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@", afterDetail, afterDetail2, afterDetail3, afterDetail4]];
   }

   - (void)addClsSuperClsToTextView {
       Class cls = object_getClass(self.yKNoteKVOObject);
       Class superCls = class_getSuperclass(cls);
       
       self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"yKNoteKVOObject isa:%@\nyKNoteKVOObject isa's super class:%@\n", cls, superCls]];
   }

   - (void)addObjectIMPToTextView {
       NSString *objcIMP = [NSString stringWithFormat:@"objcIMP yKNoteKVOObject setName:%p, setAge:%p\n", [self.yKNoteKVOObject methodForSelector:@selector(setName:)], [self.yKNoteKVOObject methodForSelector:@selector(setAge:)]];
       NSString *objcIMP2 = [NSString stringWithFormat:@"objcIMP yKNoteKVOObject2 setName:%p, setAge:%p\n", [self.yKNoteKVOObject2 methodForSelector:@selector(setName:)], [self.yKNoteKVOObject2 methodForSelector:@selector(setAge:)]];
       NSString *objcIMP3 = [NSString stringWithFormat:@"objcIMP yKNoteKVOObject3 setName:%p, setAge:%p\n", [self.yKNoteKVOObject3 methodForSelector:@selector(setName:)], [self.yKNoteKVOObject3 methodForSelector:@selector(setAge:)]];
       NSString *objcIMP4 = [NSString stringWithFormat:@"objcIMP yKNoteKVOObject4 setName:%p, setAge:%p\n", [self.yKNoteKVOObject4 methodForSelector:@selector(setName:)], [self.yKNoteKVOObject4 methodForSelector:@selector(setAge:)]];
       
       self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@", objcIMP, objcIMP2, objcIMP3, objcIMP4]];
   }

   - (void)addRuntimeMethodIMPToTextView {
       NSString *runtimeMethodImpl = [NSString stringWithFormat:@"runtimeMethodImpl yKNoteKVOObject setName:%p, setAge:%p\n", class_getMethodImplementation(object_getClass(self.yKNoteKVOObject), @selector(setName:)), class_getMethodImplementation(object_getClass(self.yKNoteKVOObject), @selector(setAge:))];
       NSString *runtimeMethodImpl2 = [NSString stringWithFormat:@"runtimeMethodImpl yKNoteKVOObject2 setName:%p, setAge:%p\n", class_getMethodImplementation(object_getClass(self.yKNoteKVOObject2), @selector(setName:)), class_getMethodImplementation(object_getClass(self.yKNoteKVOObject2), @selector(setAge:))];
       NSString *runtimeMethodImpl3 = [NSString stringWithFormat:@"runtimeMethodImpl yKNoteKVOObject3 setName:%p, setAge:%p\n", class_getMethodImplementation(object_getClass(self.yKNoteKVOObject3), @selector(setName:)), class_getMethodImplementation(object_getClass(self.yKNoteKVOObject3), @selector(setAge:))];
       NSString *runtimeMethodImpl4 = [NSString stringWithFormat:@"runtimeMethodImpl yKNoteKVOObject4 setName:%p, setAge:%p\n", class_getMethodImplementation(object_getClass(self.yKNoteKVOObject4), @selector(setName:)), class_getMethodImplementation(object_getClass(self.yKNoteKVOObject4), @selector(setAge:))];
       
       self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@", runtimeMethodImpl, runtimeMethodImpl2, runtimeMethodImpl3, runtimeMethodImpl4]];
   }

   - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
       self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"The value of %@ change to : %@\n",keyPath, [change objectForKey:@"new"]]];
       NSLog(@"The value of %@ change to : %@\n", keyPath, [change objectForKey:@"new"]);
   }

   #pragma mark - getter
   - (YKNoteKVOObject *)yKNoteKVOObject {
       if (_yKNoteKVOObject == nil) {
           _yKNoteKVOObject = [[YKNoteKVOObject alloc] init];
       }
       return _yKNoteKVOObject;
   }

   - (YKNoteKVOObject *)yKNoteKVOObject2 {
       if (_yKNoteKVOObject2 == nil) {
           _yKNoteKVOObject2 = [[YKNoteKVOObject alloc] init];
       }
       return _yKNoteKVOObject2;
   }

   - (YKNoteKVOObject *)yKNoteKVOObject3 {
       if (_yKNoteKVOObject3 == nil) {
           _yKNoteKVOObject3 = [[YKNoteKVOObject alloc] init];
       }
       return _yKNoteKVOObject3;
   }

   - (YKNoteKVOObject *)yKNoteKVOObject4 {
       if (_yKNoteKVOObject4 == nil) {
           _yKNoteKVOObject4 = [[YKNoteKVOObject alloc] init];
       }
       return _yKNoteKVOObject4;
   }

   - (UITextView *)textView {
       if (_textView == nil) {
           _textView = [[UITextView alloc] init];
           _textView.contentOffset = CGPointMake(0, 20);
           _textView.editable = NO;
       }
       return _textView;
   }

   @end
   ```

3. 输出的内容

   ```
   ========before add observer objective detail========
   yKNoteKVOObject:<YKNoteKVOObject: 0x60800024edf0>
   	class YKNoteKVOObject
   	objcClass YKNoteKVOObject
   	implementmethod 
   		setFriends:,
   		setSalary:,
   		setAge:,
   		age,
   		salary,
   		friends,
   		subObject,
   		setSubObject:,
   		.cxx_destruct,
   		name,
   		setName:,
   		init
   yKNoteKVOObject2:<YKNoteKVOObject: 0x60800024eee0>
   	class YKNoteKVOObject
   	objcClass YKNoteKVOObject
   	implementmethod 
   		setFriends:,
   		setSalary:,
   		setAge:,
   		age,
   		salary,
   		friends,
   		subObject,
   		setSubObject:,
   		.cxx_destruct,
   		name,
   		setName:,
   		init
   yKNoteKVOObject3:<YKNoteKVOObject: 0x60800005bc30>
   	class YKNoteKVOObject
   	objcClass YKNoteKVOObject
   	implementmethod 
   		setFriends:,
   		setSalary:,
   		setAge:,
   		age,
   		salary,
   		friends,
   		subObject,
   		setSubObject:,
   		.cxx_destruct,
   		name,
   		setName:,
   		init
   yKNoteKVOObject4:<YKNoteKVOObject: 0x60800024e0d0>
   	class YKNoteKVOObject
   	objcClass YKNoteKVOObject
   	implementmethod 
   		setFriends:,
   		setSalary:,
   		setAge:,
   		age,
   		salary,
   		friends,
   		subObject,
   		setSubObject:,
   		.cxx_destruct,
   		name,
   		setName:,
   		init
   ========after add observer objective detail========
   yKNoteKVOObject:<YKNoteKVOObject: 0x60800024edf0>
   	class YKNoteKVOObject
   	objcClass NSKVONotifying_YKNoteKVOObject
   	implementmethod 
   		setFriends:,
   		setAge:,
   		setName:,
   		class,
   		dealloc,
   		_isKVOA
   yKNoteKVOObject2:<YKNoteKVOObject: 0x60800024eee0>
   	class YKNoteKVOObject
   	objcClass NSKVONotifying_YKNoteKVOObject
   	implementmethod 
   		setFriends:,
   		setAge:,
   		setName:,
   		class,
   		dealloc,
   		_isKVOA
   yKNoteKVOObject3:<YKNoteKVOObject: 0x60800005bc30>
   	class YKNoteKVOObject
   	objcClass NSKVONotifying_YKNoteKVOObject
   	implementmethod 
   		setFriends:,
   		setAge:,
   		setName:,
   		class,
   		dealloc,
   		_isKVOA
   yKNoteKVOObject4:<YKNoteKVOObject: 0x60800024e0d0>
   	class YKNoteKVOObject
   	objcClass YKNoteKVOObject
   	implementmethod 
   		setFriends:,
   		setSalary:,
   		setAge:,
   		age,
   		salary,
   		friends,
   		subObject,
   		setSubObject:,
   		.cxx_destruct,
   		name,
   		setName:,
   		init
   ============cls supeCls============
   yKNoteKVOObject isa:NSKVONotifying_YKNoteKVOObject
   yKNoteKVOObject isa's super class:YKNoteKVOObject
   ============Object IMP============
   objcIMP yKNoteKVOObject setName:0x1004c145d, setAge:0x1004c7c16
   objcIMP yKNoteKVOObject2 setName:0x1004c145d, setAge:0x1004c7c16
   objcIMP yKNoteKVOObject3 setName:0x1004c145d, setAge:0x1004c7c16
   objcIMP yKNoteKVOObject4 setName:0x1003af810, setAge:0x1003af870
   ============Runtime IMP============
   runtimeMethodImpl yKNoteKVOObject setName:0x1004c145d, setAge:0x1004c7c16
   runtimeMethodImpl yKNoteKVOObject2 setName:0x1004c145d, setAge:0x1004c7c16
   runtimeMethodImpl yKNoteKVOObject3 setName:0x1004c145d, setAge:0x1004c7c16
   runtimeMethodImpl yKNoteKVOObject4 setName:0x1003af810, setAge:0x1003af870
   ============Observer change============
   The value of name change to : YKNoteKVOObject Change property
   The value of name change to : YKNoteKVOObject setValue:forKey:
   The value of name change to : YKNoteKVOObject setValue:forKeyPath:
   The value of friends change to : (
       wanyakun
   )
   The value of salary change to : 1000
   ```

   从输出能容可以得出：

   > class = [objc class],
   >
   > objcClass = object_getClass(objc)
   >
   > ```objc
   > Class object_getClass(id obj)
   > {
   >     if (obj) return obj->getIsa();
   >     else return Nil;
   > }
   > ```

   - 添加observer之前，所有对象的class和objcClass均为YKNoteKVOObject。
   - 添加observer之后，添加了observer的对象的class为YKNoteKVOObject， objecClass为NSKVONotifying_YKNoteKVOObject
   - 添加observer之后，对象的isa指针已经被替换为NSKVONotifying_YKNoteKVOObject，为YKNoteKVOObject子类，即动态生成子类（在原类添加前缀NSKVONotifying_），并使用子类替换对象的isa指针。
   - 子类NSKVONotifying_YKNoteKVOObject重载了被添加了observer的属性的set方法。

### 四、KVO Compliance

官方文档：https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOCompliance.html#//apple_ref/doc/uid/20002178-SW3

其中涉及到到两种技术：自动发射key-value change通知和手动发射key-value change通知

- 自动发射key-value change通知

  NSObject实现了自动发射key-value change通知，使用存取器、KVC方法都会自动发射变化通知，对于集合属性，可以通过代理对象来达到自动发射变化通知。

  ```objc
  // Call the accessor method.
  self.yKNoteKVOObject.name = @"YKNoteKVOObject Change property";
  // Use setValue:forKey:
  [self.yKNoteKVOObject setValue:@"YKNoteKVOObject setValue:forKey:" forKey:@"name"];
  // Use a key path, where 'yKNoteKVOObject' is a kvc-compliant property of 'name'.
  [self.yKNoteKVOObject setValue:@"YKNoteKVOObject setValue:forKeyPath:" forKeyPath:@"name"];
  // Use mutableArrayValueForKey: to retrieve a relationship proxy object
  NSMutableArray *array = [self.yKNoteKVOObject mutableArrayValueForKey:@"friends"];
  [array addObject:@"wanyakun"];
  ```

- 手动发射key-value change通知

  手动发射key-value change通知需要实现automaticallyNotifiesObserversForKey:方法。

  ```objc
  /*
   手动实现KVO发射通知，需要重载automaticallyNotifiesObserversForKey:,或者实现automaticallyNotifiesObserversOf<key>, 对于不需要自动发射KVO通知的属性需要返回NO，然后在setter方法中添加willChangeValueForKey:和didChangeValueForKey:方法的调用代码
   */
  + (BOOL)automaticallyNotifiesObserversOfSalary {
      return NO;
  }

  + (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
      if ([key isEqualToString:@"salary"]) {
          return NO;
      } else {
          return [super automaticallyNotifiesObserversForKey:key];
      }
  }

  - (void)setSalary:(CGFloat)salary {
      [self willChangeValueForKey:@"salary"];
      _salary = salary;
      [self didChangeValueForKey:@"salary"];
  }
  ```

### 五、总结

使用Clang对addObserver代码进行编译，对编译结果代码查看，其中并无NSKVONotifying_YKNoteKVOObject任何代码。更说明，NSKVONotifying_YKNoteKVOObject子类是在runtime时动态生成的。由于这种继承方式的注入是在运行时而不是编译时实现的，如果给定的实例没有观察者，那么KVO不会有任何开销。