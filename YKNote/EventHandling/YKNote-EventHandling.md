## iOS事件机制

关于事件机制，首先给出官方链接，英文好的可以去阅读原文，一手资料是最好的。官方文档：https://developer.apple.com/library/content/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Introduction/Introduction.html

### 一、事件分类

在iOS中事件分为三类：多点触摸事件、运动事件和远程控制事件。而在我们开发过程中最常用的就是多点触摸事件。

### 二、事件传递

当一个用户生产的事件发生时，UIKit创建一个事件对象，包含处理事件所需要的信息。然后它将事件对放到当前活跃的应用程序的事件队列中。对于触摸事件，对象是一组被包装成UIEvent的触摸对象。对于运动事件，该对象取决于你所使用的框架和你所感兴趣的运动事件类型。

事件将沿着特定的路径进行传递，直到它被传输到一个能够处理它的对象。首先，UIApplication单例对象从队列的顶部获取对象并进行派发。通常它发送事件到到app的key window对象，将事件传递到initial object用于处理，initial object取决于事件类型。

- 触摸事件：对于触摸事件，窗口对象首先尝试发送事件到触摸发生的view，这个view被称为hit-test view。找到hit-test view的处理过程被称为hit-testing。参考：https://developer.apple.com/library/content/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/event_delivery_responder_chain/event_delivery_responder_chain.html#//apple_ref/doc/uid/TP40009541-CH4-SW4
- 运动事件和远程控制事件：对于这些事件，窗口对象发送摇动运动或远程控制事件给第一响应者来处理。第一响应者参考：https://developer.apple.com/library/content/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/event_delivery_responder_chain/event_delivery_responder_chain.html#//apple_ref/doc/uid/TP40009541-CH4-SW1

#### 1. Hit-Testing



### 三、事件响应