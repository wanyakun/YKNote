# 操作队列

Cocoa操作（operation）是一种面向对象的方式来封装您想要异步执行的工作。操作被设计用来和操作队列（operation queue）一起使用或者由他们自己使用。因为他们是基于Objective-C，操作常用于基于Cocoa的OS X和iOS应用程序。

下面介绍如何定义和使用操作。



### 关于操作对象

操作对象是`NSOperation`类（在Foundation框架中）的实例，使用它来封装您想要您应用程序执行的工作。`NSOperation`类本身是一个抽象基类，必须将其子类化才能做任何有用的工作。尽管是抽象的，这个类确实提供了大量的基础结构，以减少您在自己子类中的工作量。此外，基础框架提供了两个具体子类，您可以和您已经存在的代码一样使用。下标列出了这些类，和一些怎么使用他们的摘要信息。

| 类                     | 描述                                       |
| --------------------- | ---------------------------------------- |
| NSInvocationOperation | 您可以使用此类从您应用程序中基于一个对象（object）和选择器（selector）创建一个操作对象。如果已经存在一个执行任务所需要的方法，您可以使用此类。因为它不需要子类化，您也可以以更动态的方式使用此类创建操作对象。有关如何使用这个类的信息，请参阅[创建NSInvocationOperation对象](#创建NSInvocationOperation对象)。 |
| NSBlockOperation      | 您可以使用此类并发的执行一个或者多个块对象（block object）。因为太可以执行多个块，所以块操作对象使用组语义操作。只有当所有相关联的块都执行完成时，操作本身才被认为完成操作。有关如何使用这个类的信息，请参阅[创建NSBlockOperation对象](#创建NSBlockOperation对象)。 |
| NSOperation           | 用于定义自定义操作对象的基类，子类化`NSOperation`给你完全的控制权来实现您自己的操作，包括改变操作执行的默认行为和记录其状态。有关如何定义自定义操作对象的信息，请参阅[定义自定义操作对象](#定义自定义操作对象)。 |



所有操作对象都支持以下主要特性：

- 支持在操作对象间建立基于图的依赖关系。这些依赖关系阻止给定的操作运行，直到它所依赖的所有操作都运行结束。有关如何配置依赖，请参阅[配置并发执行操作](#配置并发执行操作)。
- 支持一个可选的完成块（completion block），在操作的主任务完成后执行。有关如何设置完成块，请参阅[设置完成块](#设置完成块)。
- 支持使用KVO通知监视操作执行状态变化。有关如何观察KVO通知，请参阅[维持KVO规范](#维持KVO规范)。
- 支持优先级操作，从而影响相对执行顺序。欲了解跟多信息，请参阅[改变操作的执行优先级](#改变操作的执行优先级)。
- 支持取消语义，允许您在执行操作时停止操作。有关如何取消操作，请参阅[取消操作](#取消操作)。有关如何在您自己的操作中支持取消，请参阅[响应取消事件](#响应取消事件)。

操作的设计是为了帮助您在您的应用程序中提高并发的级别。操作也是一个很好的方式将您应用程序的行为组织和封装成简单的离散块。你可以提交一个或多个操作对象到队列，并且让相应的工作在一个或多个单独的线程上异步执行，而不是在您应用程序的主线程上运行一些代码。



### 并发操作与非并发操作

虽然您通常通过添加操作到操作队列中来执行操作，但这并不是必须的。也可以通过调用操作对象的`start`方法来手动执行，但这么做并不能保证该操作和您其他的代码并行运行。`NSOperation`类的`isConcurrent`方法告诉您操作与调用`start`方法的线程是同步还是异步运行。默认情况下，该方法返回NO，这意味着操作在调用线程中同步运行。

如果您想实现并发操作（也就是说一个和调用线程异步执行的操作），您必须写一些额外的代码来异步开始操作。例如，您可能产生一个独立的线程，调用一个异步的系统功能，或者做一些其他事情来确保`start`方法开始执行任务，并且很有可能在任务执行结束之前就立即返回。

大多数开发人员应该从不需要实现并发操作对象。如果您总是添加操作到操作队列，则不需要实现并发操作。当您提交一个非并发操作到操作队列时，队列本身会创建一个线程来运行您的操作。因此，添加一个非并发操作到队列，结果仍然会异步执行您操作对象中的代码。只有在您需要异步执行操作又不添加操作到队列的地方才需要定义并发操作。

有关如何创建并发操作，请参阅[配置并发执行操作](#配置并发执行操作)和[NSOperation类参考](https://developer.apple.com/reference/foundation/operation)



### 创建NSInvocationOperation对象

`NSInvocationOperation`类是`NSOperation`类的具体子类，当运行时，在您指定的对象上调用您指定的选择器（selector）。使用此类来避免在您应用程序中为每个任务定义大量的自定义操作对象。特别是如果您正在修改现有的应用程序，并且已经有了执行必要任务所需要的方法和对象。当您想要根据情况能够改变调用方法时，您也可以使用它。例如，您可能使用一个调用操作，基于用户的输入来动态选择来执行一个选择器（selector）。

创建调用操作的过程是简单的。您创建并初始化此类的一个新的实例，传递需要的对象和需要执行的选择器到初始化方法。下面代码给出了演示创建过程的自定义类的两个方法。`taskWithData:`方法创建一个新的调用对象，并且用另一个方法的名字提供给他，此方法包含任务的实现。

```objc
@implementation MyCustomClass
- (NSOperation*)taskWithData:(id)data {
    NSInvocationOperation* theOp = [[NSInvocationOperation alloc] initWithTarget:self
                    selector:@selector(myTaskMethod:) object:data];
 
   return theOp;
}
 
// 这是执行任务实际工作的方法.
- (void)myTaskMethod:(id)data {
    // 执行任务.
}
@end
```



### 创建NSBlockOperation对象

`NSBlockOperation`类是`NSOperation`类的具体子类，它为一个或多个块对象（block object）充当封装器。这个类为已经使用操作队列并且也不想创建调度队列的应用程序提供一个面向对象的封装器。您也可以使用块操作来利用操作依赖，KVO和可能不适用于调度队列的其他特性。

当您创建一个块操作时，您通常在初始化时添加至少一个块，您稍后可以根据需要添加更多的块。当`NSBlockOperation`对象到了执行的时间时，块操作对象提交它所有的块到一个默认优先级的并发调度队列。块操作对象然后等待，直到所有的块完成执行。当最后一个块结束执行的时候，操作对象标记自己为已完成。因此，您可以使用快操作来跟踪一组执行块，就像使用一个线程连接合并多个线程的结果一样。区别是，因为块操作本身运行在一个独立的线程上，当等待块操作完成时您应用程序的其他线程可以继续工作。

下面代码显示了如何创建`NSBlockOperation`对象的简单例子。块本身没有参数也没有有意义的返回结果。

```objc
NSBlockOperation* theOp = [NSBlockOperation blockOperationWithBlock: ^{
      NSLog(@"Beginning operation.\n");
      // 做一些工作.
   }];
```

创建块操作对象后，你可以使用`addExecutionBlock:`方法添加更多块到操作对象。如果您需要串行的执行块，您必须将他们直接提交到期望的调度队列。



### 定义自定义操作对象

如果块操作和调用操作对象不能够完全满足您应用程序的需求，您可以直接子类化`NSOperation`，并添加您需要的任何行为。`NSOperation`类为所有操作对象提供通用的子类化点。该类也提供大量有意义的基础结构为依赖和KVO通知处理大部分工作。然而，有时可能仍然需要您补充实现现有的基础结构，以确保您的操作行为是正确的。您必须做的额外工作的工作量，取决于您实现的是非并发操作还是并发操作。

定义非并发操作比定义并发操作简单的多。对于非并发操作，所有您只需要执行主要任务并且适当的响应取消事件；现有的类基础结构为您处理其他所有工作。对于并发操作，您必须使用自定义代码替换一些现有的基础结构。以下部分为您说明怎么实现两种类型的对象。



#### 执行主要任务

每个操作对象应该至少实现以下方法：

- 一个自定义的初始化方法
- `main`

您需要一个自定义的初始化方法把您的操作对象放到一个已知的状态，和一个自定义的`main`方法来执行您的任务。当然，您可以根据需要实现其他方法，如下所示：

- 您打算从您实现的`main`方法中调用的自定义方法
- 用于设置数据和访问操作结果的存取方法
- 允许您来归档和解档操作对象的`NSCoding`协议方法

下面代码显示了自定义`NSOperation`子类的一个原始模板。（这个代码并没有显示如何处理取消，但显示了您通常会有的方法，有关处理取消的信息，请参阅[响应取消事件](#响应取消事件)。）这个类的初始化方法使用data参数接收一个对象，并且在操作对象内部存储对它的引用。在返回结果到您的应用程序之前，`main`方法可能表现为处理data对象。

```objc
@interface MyNonConcurrentOperation : NSOperation
@property id (strong) myData;
-(id)initWithData:(id)data;
@end
 
@implementation MyNonConcurrentOperation
- (id)initWithData:(id)data {
   if (self = [super init])
      myData = data;
   return self;
}
 
-(void)main {
   @try {
      // Do some work on myData and report the results.
   }
   @catch(...) {
      // Do not rethrow exceptions.
   }
}
@end
```

对于如何实现一个`NSOperation`子类的详细例子，请参阅[NSOperationSample](https://developer.apple.com/library/content/samplecode/NSOperationSample/Introduction/Intro.html#//apple_ref/doc/uid/DTS10004184)



#### 响应取消事件

操作开始执行后，它将继续执行它的任务直到它结束或者直到您的代码明确的取消操作。取消可以发生在任何时间，即使在操作开始执行之前。虽然`NSOperation`为客户取消操作提供一个方法，识别取消事件必然是自动的。如果操作完全终止，则可能无法回收已经分配的资源。因此，期望操作对象能够检查取消事件，并且在操作中发生取消时能够优雅的退出。

为了在操作对象中支持取消，您所要做的就是在您的自定义代码中适时的调用对象的`isCancelled`方法，如果它返回YES，立即返回。不管您的操作持续的时间、您直接继承`NSOperation`或使用其具体子类之一，支持取消都是很重要的。`isCancelled`方法本身是非常轻量的并且可以被频繁调用而没有任何显著的性能损失。当设计您的操作对象时，您应该在您代码的以下地方考虑调用`isCancelled`方法：

- 执行任何实际工作之前立即调用
- 在循环的每次迭代期间至少调用一次，如果每次迭代相对较长，调用多次
- 在您代码可能比较容易终止操作的任何地方调用

以下代码提供了一个简单例子，显示在操作对象的`main`方法中如何相应取消事件。在这种情况下，`while`循环的每次都调用`isCancelled`方法，在开始工作之前，允许快速退出。

```objc
- (void)main {
   @try {
      BOOL isDone = NO;
 
      while (![self isCancelled] && !isDone) {
          // Do some work and set isDone to YES when finished
      }
   }
   @catch(...) {
      // Do not rethrow exceptions.
   }
}
```

虽然前面的代码不包含清除代码，但您自己的代码应当确保释放由您的自定义代码分配的任何资源。



#### 配置并发执行操作

操作对象默认情况下是以同步方式执行，也就是说，他们在调用`start`方法的线程上执行他们的任务。因为操作队列为非并发操作提供线程，因此，大部分操作还是异步运行。然而，如果您打算手动执行操作，并且想要他们异步执行，您必须采用适当的措施来确保他们是异步执行。您可以通过定义您的操作对象为并发操作来做到这一点。

下表列出了实现并发操作通常覆盖的方法。

| 方法                      | 描述                                       |
| ----------------------- | ---------------------------------------- |
| start                   | （必须）所有并发操作必须覆盖这个方法，并通过自定义实现替换默认行为。通过调用`start`方法来手动执行一个操作。因此，您的这个方法的实现是您的操作的起始点，也是您执行任务而设置线程或者其他操作环境的地方。您的实现任何时候都不能够调用`super`方法。 |
| main                    | （可选）这个方法通常用来实现关联到操作对象的任务。虽然您可以在`start`方法中执行任务，但使用这个方法来实现任务可以将您的设置和任务代码单独分离开。 |
| isExecutiong/isFinished | （必须）并发操作负责设置他们的操作环境，并且向外部客户报告环境状态。因此，一个并发对象必须维护一些状态信息来明确任务什么时候正在执行、什么时候已经执行结束。它然后必须通过这些方法来报告状态。您的这些方法的实现必须能够被其他线程同时安全调用。当这些方法报告的状态值变化时，您必须为期望的键路径（key path）生成适当的KVO通知。 |
| isConcurrent            | （必须）为了标记一个操作是并发的，覆盖这个方法并返回YES            |



剩下的这部分显示了一个实现`MyOperation`类的例子，它示范了实现并发操作需要实现的基本代码。`MyOperation`类在自己创建的一个单独线程上简单执行了自己的`main`方法。`main`方法执行的实际工作无关紧要。这个例子是为了示范在定义并发操作您需要提供的基础结构。

下面代码展示了`MyOperation`类的接口和部分实现。`MyOperation`类的`isConcurrent`,`isExecution`和`isFinished`方法的实现都相当简单。`isConcurrent`方法简单返回YES来标示这是一个并发操作。`isExecution`和`isFinished`方法简单返回存储在类自身中实例变量的值。

```objc
@interface MyOperation : NSOperation {
    BOOL        executing;
    BOOL        finished;
}
- (void)completeOperation;
@end
 
@implementation MyOperation
- (id)init {
    self = [super init];
    if (self) {
        executing = NO;
        finished = NO;
    }
    return self;
}
 
- (BOOL)isConcurrent {
    return YES;
}
 
- (BOOL)isExecuting {
    return executing;
}
 
- (BOOL)isFinished {
    return finished;
}
@end
```



下面代码展示了`MyOperation`的`start`方法。这个方法的实现是最小的，也是为了示范您必须执行的任务。在这种情况下，这个方法简单启动一个线程，并且配置它来调用`main`方法。这个方法还更新成员变量`executing`，并且为`isExecuting`键路径生成KVO通知来反映该值的变化。在它的工作结束后，然后方法简单返回，留下刚才的独立线程来执行实际任务。

```objc
- (void)start {
   // Always check for cancellation before launching the task.
   if ([self isCancelled])
   {
      // Must move the operation to the finished state if it is canceled.
      [self willChangeValueForKey:@"isFinished"];
      finished = YES;
      [self didChangeValueForKey:@"isFinished"];
      return;
   }
 
   // If the operation is not canceled, begin executing the task.
   [self willChangeValueForKey:@"isExecuting"];
   [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
   executing = YES;
   [self didChangeValueForKey:@"isExecuting"];
}
```



下面代码为`MyOperation`类展示了剩余的实现。如上面代码看到的，`main`方法是新线程的入口。它执行关联到操作对象的工作，并在工作结束的时候调用自定义的`completeOperation`方法。`completeOperation`方法然后为`isExecuting`和`isFinished`键路径生成所需的KVO通知来反映操作状态的变化

```objc
- (void)main {
   @try {
 
       // Do the main work of the operation here.
 
       [self completeOperation];
   }
   @catch(...) {
      // Do not rethrow exceptions.
   }
}
 
- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
 
    executing = NO;
    finished = YES;
 
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}
```

即使操作被取消，您应该总是通知KVO监听者您的操作现在已经完成它的工作。当一个操作对象依赖于其他操作对象的结束时，它监视这些对象的`isFinished`键路径。只有当所有对象报告它们已经结束，依赖操作才标示它已经准备运行。不生成结束通知能阻止您应用程序中其他操作的执行。



#### 维持KVO规范

`NSOperation`类的以下键路径是符合KVO规范的：

- isCancelled
- isConcurrent（iOS7之后使用isAsynchronous，iOS7之后concurrent属性由asynchronous替代）
- isExecuting
- isFinished
- isReady
- dependencies
- queuePriority
- completionBlock

如果您覆盖`start`方法，或者除了覆盖`main`方法外做`NSOperation`对象的任何重要自定义，您必须确保您的自定义对象为他们的键路径保持KVO规范。当覆盖`start`方法时，您最需要注意的键路径是`isExecuting`和`isFinished`。它们是重新实现这些方法最经常被影响到的键路径。

除了其他对象，如果您想实现支持依赖一些其他东西，您也可以覆盖`isReady`方法并且强制它返回NO，直到您的自定义依赖都满足（如果您实现自定义依赖关系，且仍然支持`NSOperation`类提供的默认依赖管理系统，请确保在`isReady`方法中调用`super`方法）。当操作对象的准备就绪状态改变时，为`isReady`键路径生成KVO通知来报告这些变化。除非你覆盖`addDependency:`和`removeDependency:`方法，否则您应该不需要为`dependencies`键路径生成KVO通知而担心。

虽然您可以为`NSOperation`的其他键路径生成KVO通知，但不大可能需要您一直这么做。如果您需要取消操作，您可以简单的调用现有的`cancel`方法。同样的，很少需要您修改操作对象的队列优先级信息。最后，除非您的操作有可能动态改变并发状态，否则您不需要为`isConcurrent`键路径提供KVO通知。

有关怎么在您自定义对象中支持键值观察的更多信息，请参阅[键值观察指南](https://developer.apple.com/library/prerelease/content/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html#//apple_ref/doc/uid/10000177i)。



### 自定义操作对象的执行行为

操作对象的配置发生在您已经创建好它们之后，但在您添加它们到队列之前。这一部分描述的配置类型可以被应用到所有的操作对象中，不管是您自己子类的`NSOperation`还是使用现有的子类。



#### 配置相互依赖关系

依赖关系是串行执行离散操作对象的一种方式，一个依赖于其他操作的操作不能够开始执行，直到它依赖的所有操作都已经执行结束。因此，您可以使用依赖关系在两个操作对象之间来创建简单的一到一的依赖关系，或者创建复杂的对象依赖图。

为了在两个操作对象之间建立依赖关系，您可以使用`NSOperation`的`addDependency:`方法。这个方法从当前操作对象到您指定作为参数的目标操作创建一个单向依赖。这个依赖意味着当前操作对象不能够开始执行，直到目标操作对象结束执行。依赖关系也不限制操作在同一个队列。操作对象管理它们自己的依赖关系，所以在操作对象之间建立依赖关系并将它们都添加到不同的队列，它是完全接受的。然而有一件事是不能够接受的，就是在操作之间创建循环依赖关系。这么做是程序员的错误，它将永远阻止受影响的操作执行。

当所有操作的依赖自身都已经结束执行时，操作对象一般会变为准备执行（如果您自定义`isReady`方法的行为，操作的准备就绪由您设置的标准来决定）。如果操作对象在队列中，队列可能随时开始执行操作。如果您打算手动执行操作，将由您来调用操作的`start`方法。

> **重要提示：**在运行操作或者将它们添加到队列之前您应该总是先配置依赖关系。在之后添加依赖关系可能阻止操作对象运行。

每当操作对象的状态改变时，每个操作对象发出适当的KVO通知，依赖关系就依靠这些通知。如果您自定义操作对象的行为，为了避免引发依赖问题，您可能需要从自定义代码发送适当的KVO通知。更多有关KVO通知和操作对象的信息，请参阅[维持KVO规范](#维持KVO规范)。有关配置依赖关系的其他信息，见[NSOperation类参考](https://developer.apple.com/reference/foundation/operation)。



#### 改变操作的执行优先级

对于添加到队列的操作，执行顺序首先由排队的准备就绪的操作来决定，其次取决于他们的相对优先级。准备就绪由操作依赖的其他操作来决定，但是优先级是操作对象本身的一个属性。默认情况下，所有新的操作对象都有一个“标准”优先级，但是您可以根据需要通过调用对象的`setQueuePriority:`方法来增加或者减少优先级。

优先级只适用于同一个操作队列里的操作。如果您的应用程序有多个操作队列，队列自己的每个对象的优先级与其他任何队列无关。因此，在不同队列中，低优先级的操作仍然有可能早于高优先级的操作执行。

优先级并不是依赖的替代者。优先级只决定队列中当前为准备状态的操作开始执行的顺序。例如，如果一个队列包含一个高优先级操作和一个低优先级操作，并且两个操作都为准备状态，队列先执行高优先级操作。然而，如果高优先级操作不是准备状态，而低优先级是准备状态，队列先执行低优先级操作。如果您想要阻止一个操作开始，直到另外一个操作结束，您必须使用依赖关系（如[配置相互依赖关系](#配置相互依赖关系)中所述）代替。



#### 改变底层线程优先级

在OS X v10.6及以后，配置操作的底层线程的优先级成为可能。在系统中线程策略本身由内核管理，但通常高优先级线程比低优先级线程被给予更多的机会来运行。在一个操作对象中，您使用0.0到1.0范围的一个浮点型值来指定线程的优先级，0.0代表最低优先级，而1.0代表最高优先级。如果您不指定一个明确的线程优先级，操作以默认的线程优先级0.5运行。

为了设置线程的优先级，您必须在添加操作对象到队列（或者手动执行）之前调用操作对象的`setThreadPriority:`方法。当需要执行操作时，默认的`start`方法使用您指定的值来改变当前线程的优先级。这个新的优先级只保持操作对象`main`方法持续的时长。所有其他代码（包括操作对象的结束块）使用默认线程优先级运行。如果您创建一个并发操作，因此覆盖`start`方法，您必须自己配置线程优先级。

> **注意：**threadPriority属性在iOS8.0以后被废弃，使用qualityOfService代替。它是位于NSObjCRuntime.h中的`NSQualityOfService`枚举。

```objc
/* 以下服务质量（QoS）分类用于向系统指示工作的性质和重要性。它们被系统用于管理各种资源。在资源争用期间，较高的QoS类别比较低的QoS类别接收更多的资源 */
typedef NS_ENUM(NSInteger, NSQualityOfService) {
  	/* UserInteractive QoS用于直接涉及提供交互式UI的工作，例如处理事件或绘制到屏幕 */
    NSQualityOfServiceUserInteractive = 0x21,
    
  	/* UserInitiated QoS用于执行已经由用户明确请求的工作，并且为了允许进一步的用户交互，必须立即呈现结果。例如，用户在邮件列表中选择电子邮件后加载电子邮件 */
    NSQualityOfServiceUserInitiated = 0x19,
    
  	/* Utility QoS用于执行用户不太可能立即等待结果的工作。该工作可能已经由用户请求或自动启动，不阻止用户进一步交互，通常在用户可见的时间段操作，并且可以通过非模态进度指示器向用户指示其进度。这项工作将以节能的方式运行，以便在资源受到约束时遵循更高的QoS工作。例如，定期内容更新或批量文件操作，如介质导入 */
    NSQualityOfServiceUtility = 0x11,

  	/* Background QoS用于不是用户启动或可见的工作。一般来说，用户甚至不知道这项工作发生，它将以最有效的方式运行，同时给予更高的QoS工作最大的尊重。例如，预取内容，搜索索引，备份以及与外部系统同步数据 */
    NSQualityOfServiceBackground = 0x09,

  	/* Default QoS表示没有QoS信息。随时可能从其他资源推断QoS信息。如果这样的推断是不可能的，将使用UserInitiated和Utility之间的QoS。 */
    NSQualityOfServiceDefault = -1
} NS_ENUM_AVAILABLE(10_10, 8_0);
```



#### 设置完成块

在OS X v10.6及以后，当操作的主任务执行结束的时候可以执行一个完成块。您可以使用一个结束块来执行任何您认为不是主任务部分的工作。例如，您可能使用这个块来通知感兴趣的用户操作本身已经完成。一个并发操作对象可能使用这个块来生成它最后的KVO通知。

使用`NSOperation`的`setCompletionBlock:`方法来设置完成块。传递到这个方法的块不应该有参数和返回值。



### 实现操作对象的小贴士

虽然操作对象的实现相当简单，但当您写自己的代码的时候，有一些事情也应该注意。当为您的操作对象写代码时，您应该考虑下面部分描述的因素。



#### 管理操作对象内存

下面部分描述了在操作对象中内存管理的关键因素。在Objective-C程序中关于内存管理的一般信息，请参阅[高级内存管理编程指南](https://developer.apple.com/library/prerelease/content/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/MemoryMgmt.html#//apple_ref/doc/uid/10000011i)。



##### 避免Per-Thread存储

尽管大多数操作执行在线程上，在非并发操作的情况下，该线程通常是由操作队列提供。如果操作队列为您提供一个线程，您应该认为线程为队列所拥有，而不应被您的操作触碰。特别是，您永远不要关联任何数据到不是您自己创建或者管理的线程上。由操作队列管理的线程根据系统和您的应用程序的需要进出。因此，使用per-thread存储在操作间传递数据是不可靠的而且可能会失败。

在操作对象的时候，在任何情况下都不应该以任何原因来使用per-thread存储。当您初始化一个操作对象时，您应该为对象提供处理工作所需要的所有东西。因此，操作对象自身提供您需要的上下文存储。所有的传入传出数据都应该存储在那里，直到它可以被完整的返回到您的应用程序或者不再需要的时候。



##### 根据需要保留对操作对象的引用

只因为操作对象异步运行，



#### 处理错误和异常

### 确定操作对象的相应范围

### 执行操作

#### 添加操作到操作队列

#### 手动执行操作

#### 取消操作

#### 等待操作完成

#### 暂停与恢复队列