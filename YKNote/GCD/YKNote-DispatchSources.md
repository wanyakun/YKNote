## 调度源

当和底层系统交互时，必须花费大量时间为任务做好准备。调用内核或者其他系统层需要切换上下文，这也是比在进程内部调用昂贵的原因。因此，许多系统库提供异步接口，允许您的代码提交请求到系统，且请求执行时继续做其他工作。GCD允许您使用块和调度队列提交请求并将结果返回到您的代码来建立这种行为。



### 关于调度源

调度源是协调特殊低级别系统事件处理的基本数据类型。GCD支持以下类型的调度源：

- Timer（定时器）调度源，生成周期性的通知
- Signal（信号）调度源，当UNIX信号到达时通知
- Descriptor（描述符）源，通知一些基于文件和套接字的操作，例如：
  - 当数据可读取时
  - 当可以写入数据时
  - 当文件系统中的文件被删除、移动或者重命名时
  - 当文件元信息改变时
- Process（进程）调度源，通知进程相关的事件，例如：
  - 当进程退出时
  - 当进程发出fork或者exec类型的调用时
  - 当信号传递到进程时
- Mach port（马赫端口）调度源，通知Mach相关事件
- Custom（自定义）调度源，自己定义调度源和触发因素

调度源代替异步回调函数，通常用于系统相关事件处理。当配置调度源时，需要指定想要监视的事件、调度队列和处理这些事件的代码。处理代码可以使用块或函数。当感兴趣的事件到达时，调度源提交块或函数到指定的队列来执行。

与手动提交到队列的任务不同，调度源为应用程序提供连续的事件源。调度源保留其附加的调度队列，直到明确取消它。当附加时，无论何时发生相关事件，调度源提交关联的任务代码到调度队列。一些事件，例如定时器事件，固定间隔周期性的发生，但是大多数情况仅在特定条件出现时偶尔发生。因为这个原因，调度源保留其关联的调度队列，防止其过早释放，而这时事件仍可能处于等待状态。

为了防止事件在调度队列中积压，调度队列实现了事件合并方案。如果新的事件在前一个事件的事件处理者已经出队和执行之前到达，调度源合并新事件和旧事件的数据。根据事件类型，合并可能替换旧的事件或者更新其获取的信息。例如，基于信号的调度源只提供最近信号的信息，但也报告从上次事件处理者调用到现在总共传递多少个信号。



### 创建调度源

创建调度源包括创建事件源和调度源本身。事件源是处理事件所需的任何本地数据结构。例如，对于基于描述符的调度源可能需要打开描述符，对于基于线程的调度源可能需要获得目标程序的线程ID。当有了事件源，可以创建相应的调度源：

1. 使用`dispatch_source_create`函数创建调度源
2. 配置调度源：
   - 为调度源分配事件处理者；参阅[编写和设置事件处理者](#编写和设置事件处理者)
   - 对于定时器源，使用`dispatch_source_set_timer`函数设置定时器信息；参阅[创建定时器](#创建定时器)
3. （可选）为调度源分配取消处理者；参阅[设置取消处理者](#设置取消处理者)
4. 调用`dispatch_resume`函数开始处理事件；参阅[暂停与恢复调度源](#暂停与恢复调度源)

因为调度源在能够使用之前需要一些额外配置，所以`dispatch_source_create`函数返回的调度源为暂停状态。暂停时，调度源接收事件，但不处理。这给你时间来设置事件处理者和处理实际事件需要的任意额外配置。

以下章节介绍如何配置调度源，详细示例说明如何配置特定类型的调度源，参阅[调度源示例](#调度源示例)。有关用于创建和配置调度源的函数信息，请参阅GCD参考。



#### 编写和设置事件处理者

为了处理调度源生成的事件，必须定义事件处理者来处理这些事件。事件处理者是一个函数或者块，使用`dispatch_source_set_event_handler`或者`dispatch_source_set_event_handler_f`函数将其放置到调度源上。当事件到达时，调度源提交事件处理者到指定的调度队列进行处理。

事件处理者的主体负责处理到达的任何事件，当新事件到达时，如果事件处理者已经入队且等待处理一个事件，调度源合并这两个事件。事件处理者通常只看最新事件的信息，但取决于调度源的类型，它也可能能够获取合并的其他事件的信息。在事件处理者开始执行后，如果有一个或多个新的事件到达，调度源保持这些事件，直到当前事件处理者结束执行。在那个时候，它再次提交事件处理者和新的事件到调度队列。

基于函数的事件处理者获取一个上下文指针，包括调度源对象，不返回值。基于块的事件处理者不获取参数也不返回值。

```objc
// Block-based event handler
void (^dispatch_block_t)(void)
 
// Function-based event handler
void (*dispatch_function_t)(void *)
```

在事件处理者内部，可以从调度源本身获取有关给定事件的信息。基于函数的事件处理者传递一个指向调度源的指针作为参数，基于块的事件处理者必须自己获取那个指针。可以通过引用包含调度源的变量来做。例如，下面代码片段获取声明在块上下文之外的`source`变量。

```objc
dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ,
                                 myDescriptor, 0, myQueue);
dispatch_source_set_event_handler(source, ^{
   // Get some data from the source variable, which is captured
   // from the parent context.
   size_t estimated = dispatch_source_get_data(source);
 
   // Continue reading the descriptor...
});
dispatch_resume(source);
```

在块内部获取变量通常具有更大的灵活性和动态性。当然，获取的变量默认情况下在块中是只读的。虽然块支持在特殊条件下修改获取的变量，最好不要在关联到调度源的事件处理者中这么做。因为调度源总是异步执行事件处理者，所以获取的变量的定义上下文可能在事件处理者执行的时候消失。有关在块内部获取使用变量的更多信息，请参阅[块编程](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/Blocks/Articles/00_Introduction.html#//apple_ref/doc/uid/TP40007502)

下表列出了可以从事件处理者代码中调用的函数，来获取关于事件的信息。

| 函数                         | 描述                                       |
| -------------------------- | ---------------------------------------- |
| dispatch_source_get_handle | 这个函数返回调度源管理的底层系统数据类型。对于描述符调度源，这个函数返回一个int类型，包含关联到调度源的描述符。对于信号调度源，这个函数返回一个int类型，包含最新事件的信号编号。对于进程调度源，这个函数返回被监视进程的pid_t数据结构。对于Mach端口调度源，这个函数返回mach_port_t数据结构。对于其他调度源，这个函数返回的值未定义。 |
| dispatch_source_get_data   | 此函数返回与事件相关联的任何待处理数据。对于从文件中读取数据的描述符调度源，这个函数返回可用于读取的字节数。对于向文件中写入数据的描述符调度源，如果空间可用于写入，这个函数返回一个正整数。对于监视文件系统活动的描述符调度源，这个函数返回一个常量，标示事件发生的类型，有关常量的列表，请参阅 `dispatch_source_vnode_flags_t` 枚举类型。对于进程调度源，这个函数返回一个常量，标示事件发生的类型，有关常量的列表，请参阅`dispatch_source_proc_flags_t`枚举类型。对于Mach端口调度源，这个函数返回一个常量，标示事件发生的类型，有关常量的列表，请参阅`dispatch_source_machport_flags_t`枚举类型。对于自定义调度源，此函数返回由现有数据和传递到`dispatch_source_merge_data`函数的新数据所创建的新数据。 |
| dispatch_source_get_mask   | 这个函数返回用于创建调度源的事件标志。对于线程调度源，这个函数返回调度源接收的事件掩码，有关常量的列表，请参阅`dispatch_source_proc_flags_t`枚举类型。对于有发送权限的Mach端口调度源，这个函数返回所需事件的掩码，有关常量的列表，请参阅`dispatch_source_mach_send_flags_t`枚举类型。对于自定义OR调度源，这个函数返回用于合并数据值的掩码。 |

有关如何为特殊类型的调度源编写和设置事件处理者的例子，请参阅[调度源示例](#调度源示例)



#### 设置取消处理者

取消处理者用于在释放前清理调度源。对于大多数类型的调度源，清理处理者是可选的，只有当有一些自定义行为与需要更新的调度源绑定时才需要。对于使用描述符和Mach端口的调度源，必须提供取消处理者来关闭描述符或者释放Mach端口。如果不这么做，可能导致代码中出现细微的bug，因为这些结构会被您的代码或者系统其他部分无意中重用。

可以在任何时候设置取消处理者，但通常在创建调度源的时候就这么做了。使用`dispatch_source_set_cancel_handler`或`dispatch_source_set_cancel_handler_f`函数设置取消处理者，这取决与是使用块还是函数实现。下面是一个简单的取消处理者例子，用来关闭被调度源打开的描述符。变量`fd`是获取的包含描述符的变量。

```objc
dispatch_source_set_cancel_handler(mySource, ^{
   close(fd); // Close a file descriptor opened earlier.
});
```

调度源使用取消处理者的完整代码例子，请参阅[从描述符读取数据](#从描述符读取数据)



#### 更改目标队列

创建调度源时虽然指定队列来运行事件处理者和取消处理者，但随时可以使用`dispatch_set_target_queue`函数改变队列。可能这么做来改变调度源事件处理的优先级。

改变调度源的队列是一个异步操作，且调度源尽可能快速的完成改变。如果一个事件处理者已经入队且等待被处理，那么它在前一个队列上执行。然而，在改变时到达的其他事件会在其他队列上执行。



#### 关联自定义对象与调度源

和GCD中很多其他数据类型一样，可以使用`dispatch_set_context`函数来关联自定义数据到调度源。可以使用上下文指针来存储事件处理者处理事件需要的任何数据。如果确实在上下文指针中存储了自定义数据，应当设置取消处理者（如[设置取消处理者](#设置取消处理者)中描述）在调度源不再需要的时候释放数据。

如果使用块实现事件处理者，可以获取本地变量并且在基于块的代码内部使用它们。虽然这可能减少在调度源的上下文指针中存储数据的需要，但要谨慎使用这个特性。因为调度源可能长期存活在应用程序中，当获取的变量包含指针时需要小心。如果数据被一个随时可能释放的指针指向，应当复制数据或者保留它来防止发生这种情况。在任何情况下，都需要提供取消处理，以便稍后释放这些数据。



#### 调度源内存管理

和其他调度对象一样，调度源是引用计数数据类型。调度源有一个初始的引用计数1，可以使用`dispatch_retain`和`dispatch_release`函数来保留和释放。当队列的引用计数为0时，系统自动释放调度源数据结构。

根据使用的方式，可以在调度源自身的内部或外部管理调度源的所有权。使用外部所有权，另外一个对象或者代码片段拥有调度源的所有权，且负责在不再需要的时候释放它。使用内部所有权，调度源拥有它自己，且负责在适当的时候释放自己。虽然内部所有权是非常常见的，但可能会使用内部所有权创建自动调度源，并让它管理代码的某些行为，而无需进一步的交互。例如，如果调度源被设计用来响应单个全局事件，可能让他处理事件然后立刻退出。



### 调度源示例

下面章节介绍如何创建和配置一些更常见的调度源的使用。更多关于配置指定类型调度源的信息，参阅GCD参考。



#### 创建定时器

定时器调度源按照固定的间间隔生成事件。可以使用定时器启动需要定期执行的特殊任务。例如，游戏和其他图形密集型应用程序可能使用计时器来启动屏幕或者更新动画。也可以设置定时器，使用生成的事件来检查服务器上频繁更新的新信息。

所有定时器调度源都是间隔定时器，一旦创建，它以指定的间隔定期传递事件。当创建定时器调度源时，必须指定的一个值是余留值，以便系统了解定时器事件的所需精度。余留值给系统在电源管理和唤醒内核方面一些灵活性。例如，系统可能使用余留值来提前或者延迟启动时间，使其与其他系统事件更好的匹配。因此，应该尽可能为自己的计时器指定一个余留值。

> **注意：**即使指定余留值为0，也不要期待计时器在你要求的确切纳秒启动。 系统尽力满足需求，但不能保证准确的启动时间。

当计算机进入休眠状态时，所有定时器调度源都将被挂起。当计算机唤醒时，这些定时器调度源也自动唤醒。根据定时器的配置，这种性质的暂停可能影响定时器下次启动。如果使用`dispatch_time`函数或者`DISPATCH_TIME_NOW`常量设置定时器调度源，定时器调度源使用默认的系统时钟来决定何时启动。但是，在计算机处于休眠状态时，默认时钟不会提前。相反，当使用`dispatch_walltime`函数设置定时器调度源时，定时器调度源跟踪启动时间的挂钟时间。后一选项通常用于触发间隔相对较大的定时器，因为它防止在事件时间之间有太多误差。

下面代码是一个定时器例子，每30秒启动一次，且具有1秒的余留值。因为计时器间隔比较大，使用`dispatch_walltime`函数创建调度源。定时器第一次启动立即发生，随后的事件每30秒到达一次。`MyPeriodicTask`和`MyStoreTimer`代表自定义函数，用来实现定时器行为，并在应用程序的数据结构的一些地方保存定时器。

```objc
dispatch_source_t CreateDispatchTimer(uint64_t interval,
              uint64_t leeway,
              dispatch_queue_t queue,
              dispatch_block_t block)
{
   dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0, 0, queue);
   if (timer)
   {
      dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
      dispatch_source_set_event_handler(timer, block);
      dispatch_resume(timer);
   }
   return timer;
}
 
void MyCreateTimer()
{
   dispatch_source_t aTimer = CreateDispatchTimer(30ull * NSEC_PER_SEC,
                               1ull * NSEC_PER_SEC,
                               dispatch_get_main_queue(),
                               ^{ MyPeriodicTask(); });
 
   // Store it somewhere for later use.
    if (aTimer)
    {
        MyStoreTimer(aTimer);
    }
}
```

虽然创建一个定时器调度源是接收基于时间事件的主要方法，但也有其他选项可用。如果想在指定的间隔后执行一个块，可以使用`dispatch_after`或`dispatch_after_f`函数。这个函数的行为很像`dispatch_async`函数，只不过允许指定一个时间值，在这个时间值提交块到队列。这个时间值可以根据需要被指定为相对或者绝对的时间值。



#### 从描述符读取数据

为了从文件或套接字读取数据，必须打开文件或套接字，并创建`DISPATCH_SOURCE_TYPE_READ`类型的调度源。指定的事件处理者应当能够读取和处理文件描述符的内容。对于文件，这相当于读取文件数据（或数据的子集）并创建相应的数据结构。对于网络套接字，这需要处理最新接受到的网络数据。

无论什么时候读取数据，都应该配置描述符使用非阻塞操作。虽然可以使用`dispatch_source_get_data`函数来看看有多少数据可以被读取，但这个函数返回的值可以在调用这个函数到实际读取数据之间被修改。如果底层文件被截断或者网络发生错误，从阻塞当前线程的描述符读取，可能在事件处理者执行中停止事件处理者，且阻止调度队列调度其他任务。对于串行队列，这可能死锁队列，即使对于并发队列，这也会减少可以开始的新任务个数。

下面代码是一个配置调度源从文件中读取数据的示例。在这个例子中，事件处理者读取指定文件的全部内容到缓冲区，并调用一个自定义函数（在自己代码中定义）处理数据。（一旦读取结束，这个函数的调用者可能使用返回的调度源取消它。）为了确保没有数据读取时调度队列不会被不必要的阻塞，这个例子使用`fcntl`函数来配置文件描述符执行非阻塞操作。取消处理者被设置到调度源上，确保文件描述符在读取数据后关闭。

```objc
dispatch_source_t ProcessContentsOfFile(const char* filename)
{
   // Prepare the file for reading.
   int fd = open(filename, O_RDONLY);
   if (fd == -1)
      return NULL;
   fcntl(fd, F_SETFL, O_NONBLOCK);  // Avoid blocking the read operation
 
   dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   dispatch_source_t readSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ,
                                   fd, 0, queue);
   if (!readSource)
   {
      close(fd);
      return NULL;
   }
 
   // Install the event handler
   dispatch_source_set_event_handler(readSource, ^{
      size_t estimated = dispatch_source_get_data(readSource) + 1;
      // Read the data into a text buffer.
      char* buffer = (char*)malloc(estimated);
      if (buffer)
      {
         ssize_t actual = read(fd, buffer, (estimated));
         Boolean done = MyProcessFileData(buffer, actual);  // Process the data.
 
         // Release the buffer when done.
         free(buffer);
 
         // If there is no more data, cancel the source.
         if (done)
            dispatch_source_cancel(readSource);
      }
    });
 
   // Install the cancellation handler
   dispatch_source_set_cancel_handler(readSource, ^{
     close(fd);
   });
 
   // Start reading the file.
   dispatch_resume(readSource);
   return readSource;
}
```

在前面的例子中，自定义`MyProcessFileData`函数决定何时读取足够的文件数据且调度源可以被取消。默认情况下，调度源被配置用来从描述符读取数据，当仍然有数据需要读取时，重复调度事件处理者。如果套接字连接关闭或到达文件的结尾，调度源自动停止调度事件处理者。如果知道不再需要调度源，可以直接自己取消。



#### 向描述符写入数据

写入数据到文件或套接字的处理和读取数据的处理非常相似。为写入操作配置描述符后，创建`DISPATCH_SOURCE_TYPE_WRITE`类型的调度源。一旦调度源被创建，系统调用事件处理者来给它一个机会开始写入数据到文件或套接字。当结束写入数据时，使用`dispatch_source_cancel`函数来取消调度源。

无论什么时候写入数据，都应该配置描述符使用非阻塞操作。虽然可以使用`dispatch_source_get_data`函数来看看有多少空间可以被写入，但这个函数返回的值只是建议性的，且可以在调用这个函数到实际写入数据之间被修改。如果发生错误，向一个阻塞文件描述符写入数据，可能在事件处理者执行中停止事件处理者，且阻止调度队列调度其他任务。对于串行队列，这可能死锁队列，即使对于并发队列，这也会减少可以开始的新任务个数。

下面代码展示使用调度源向文件写入数据的基本方法。创建新的文件后，这个函数传递结果文件描述符给事件处理者。放入文件的数据由`MyGetData`函数提供，可以使用任何需要的代码来替换，来为文件生成数据。写入数据到文件后，事件处理者取消调度源来阻止再次调用。调度源的拥有者然后负责释放它。

```objc
dispatch_source_t WriteDataToFile(const char* filename)
{
    int fd = open(filename, O_WRONLY | O_CREAT | O_TRUNC,
                      (S_IRUSR | S_IWUSR | S_ISUID | S_ISGID));
    if (fd == -1)
        return NULL;
    fcntl(fd, F_SETFL); // Block during the write.
 
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t writeSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_WRITE,
                            fd, 0, queue);
    if (!writeSource)
    {
        close(fd);
        return NULL;
    }
 
    dispatch_source_set_event_handler(writeSource, ^{
        size_t bufferSize = MyGetDataSize();
        void* buffer = malloc(bufferSize);
 
        size_t actual = MyGetData(buffer, bufferSize);
        write(fd, buffer, actual);
 
        free(buffer);
 
        // Cancel and release the dispatch source when done.
        dispatch_source_cancel(writeSource);
    });
 
    dispatch_source_set_cancel_handler(writeSource, ^{
      close(fd);
    });
  
    dispatch_resume(writeSource);
    return (writeSource);
}
```



#### 监视文件系统对象

如果想要监视文件系统对象变化，可以设置调度源的类型为`DISPATCH_SOURCE_TYPE_VNODE`。当文件删除，写入或重命名时可以使用这种类型的调度源接收通知。也可以使用它在文件特殊类型的元信息（例如其大小和连接计数）改变时发出警告。

> **注意：** 当调度源自身在处理事件时，为调度源指定的文件描述符必须保持打开状态。

下面代码展示一个例子，监视文件名字修改，且发生时执行一些自定义行为。（可以在例子中调用的`MyUpdateFileName`函数中提供实际的行为。）因为描述符专门为调度源打开，所以调度源包含一个取消处理者来关闭描述符。因为例子创建的文件描述符和底层文件系统对象相关联，所以可以使用相同的调度源来检测任意数量的文件名更改。

```objc
dispatch_source_t MonitorNameChangesToFile(const char* filename)
{
   int fd = open(filename, O_EVTONLY);
   if (fd == -1)
      return NULL;
 
   dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                fd, DISPATCH_VNODE_RENAME, queue);
   if (source)
   {
      // Copy the filename for later use.
      int length = strlen(filename);
      char* newString = (char*)malloc(length + 1);
      newString = strcpy(newString, filename);
      dispatch_set_context(source, newString);
 
      // Install the event handler to process the name change
      dispatch_source_set_event_handler(source, ^{
            const char*  oldFilename = (char*)dispatch_get_context(source);
            MyUpdateFileName(oldFilename, fd);
      });
 
      // Install a cancellation handler to free the descriptor
      // and the stored string.
      dispatch_source_set_cancel_handler(source, ^{
          char* fileStr = (char*)dispatch_get_context(source);
          free(fileStr);
          close(fd);
      });
 
      // Start processing events.
      dispatch_resume(source);
   }
   else
      close(fd);
 
   return source;
}
```



#### 监控信号

UNIX信号允许从其域之外操纵应用程序。应用程序可以接受许多不同类型的信号，从不可恢复的错误（例如非法指令）到关于重要信息的通知（例如当子线程退出）。传统上，应用程序使用`sigaction`函数来设置一个信号处理者函数，信号到达时它尽快的同步执行。如果只是想得到信号到达的通知，并且实际上不想处理信号，可以使用信号调度源异步处理信号。

信号调度源不是使用`sigaction`函数设置同步信号处理者的替换者。同步信号处理者实际上可以捕获信号，且阻止它终止应用程序。信号调度源允许您仅监控信号的到达。此外，不能使用信号调度源来检索所有类型的信号。特别是，不能使用它们监控`SIGILL`, `SIGBUS`和`SIGSEGV`信号。

由于信号调度源在调度队列上异步执行，所以他们不会受到与同步信号处理者相同的限制。例如，可以从信号调度源的事件处理者中调用函数而没有限制。这种增加灵活性的折中，事实上可能会增加信号到达到调度源事件处理者被调用之间的等待时间。

下面代码显示如何配置一个信号调度源来处理`SIGHUP`信号。调度源的事件处理者调用`MyProcessSIGHUP`函数，在应用程序中替换这段代码来处理者信号。

```objc
void InstallSignalHandler()
{
   // Make sure the signal does not terminate the application.
   signal(SIGHUP, SIG_IGN);
 
   dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGHUP, 0, queue);
 
   if (source)
   {
      dispatch_source_set_event_handler(source, ^{
         MyProcessSIGHUP();
      });
 
      // Start processing signals
      dispatch_resume(source);
   }
}
```

如果您正在开发自定义框架的代码，使用信号调度源的一个好处就是您的代码可以监视独立于任何链接到它的应用程序的信号。信号调度源不会干扰其他调度源或应用程序已经设置的任何同步信号处理者。

有关实现同步信号处理者以及信号名称列表的更多信息，请参阅 `signal` 手册页。



#### 监视进程

进程调度源允许监视特定进程的行为并作出适当的响应。父进程可能使用这个类型的调度源来监视它创建的任何子进程。例如，父进程可能使用它来监视子进程的死亡。同样的，一个子进程可以使用它监视其父进程，并且如果父进程退出，他也退出。

下面代码显示设置一个调度源来监视父进程的终止的步骤。当父进程死亡，调度源设置一些内部状态信息，让子进程知道它应该退出。（您自己的应用程序需要实现`MySetAppExitFlag`函数来为终止设置适当的标识。）因为调度源自动运行，因此拥有自己，也在应用程序预期关闭时取消和释放自己。

```objc
void MonitorParentProcess()
{
   pid_t parentPID = getppid();
 
   dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
   dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC,
                                                      parentPID, DISPATCH_PROC_EXIT, queue);
   if (source)
   {
      dispatch_source_set_event_handler(source, ^{
         MySetAppExitFlag();
         dispatch_source_cancel(source);
         dispatch_release(source);
      });
      dispatch_resume(source);
   }
}
```



### 取消调度源

调度源保持活跃直到使用`dispatch_source_cancel`函数明确取消它们。取消调度源将停止传递新的事件且无法挽回。因此，通常取消调度源，然后立刻释放它（ARC不需要），如下所示：

```objc
void RemoveDispatchSource(dispatch_source_t mySource)
{
   dispatch_source_cancel(mySource);
   dispatch_release(mySource);
}
```

调度源的取消是一个异步操作。虽然调用`dispatch_source_cancel`函数后不再处理新的事件，但已经被调度源处理的事件继续进行处理。在处理完最后的任何事件后，调度源执行取消处理者（如果存在）。

取消处理者是释放内存或清理调度源分配的资源的机会。如果调度源使用描述符或Mach端口，必须提供清理者在取消发生时关闭描述符或销毁端口。其他类型的调度源不需要取消处理者，但如果关联任何内存或者数据到调度源，还是应该提供取消处理者。例如，如果在调度源的上下文指针中存储数据，应当提供取消处理者。关于取消处理者的更多信息，请参阅[设置取消处理者](#设置取消处理者)。



### 暂停与恢复调度源

可以使用`dispatch_suspend`和`dispatch_resume`方法临时暂停和回复调度源事件派发。这些方法增加和减少调度对象的暂停计数。因此，在事件恢复派发前，必须调用匹配方法`dispatch_resume`来平衡每次`dispatch_suspend`方法的调用。

当暂停调度源时，发生的任何事件都会被累积，直到队列恢复。当队列恢复时，在派发之前事件被合并为一个事件，而不是派发所有事件。例如，如果监视一个文件名称的更改，事件的派发将只包括最后一个名字的改变。这种方式的合并事件，将阻止事件在队列中的建立和当恢复工作时淹没应用程序。



参考：

[https://developer.apple.com/library/content/documentation/General/Conceptual/ConcurrencyProgrammingGuide/GCDWorkQueues/GCDWorkQueues.html#//apple_ref/doc/uid/TP40008091-CH103-SW1](https://developer.apple.com/library/content/documentation/General/Conceptual/ConcurrencyProgrammingGuide/GCDWorkQueues/GCDWorkQueues.html#//apple_ref/doc/uid/TP40008091-CH103-SW1)