## iOS事件机制

用户以多种方式操纵他们的iOS设备，例如触摸屏幕或摇动设备。 iOS会解释用户何时以及如何操作硬件并将此信息传递到您的应用程序。 您的应用程序以自然和直观的方式响应操作的次数越多，对用户而言越有吸引力的体验。

### 一、事件分类

事件是发送到应用程序用于通知用户操作的对象。 在iOS中，事件可以采取多种形式：多点触摸事件，运动事件和用于控制多媒体的事件。 这最后一种类型的事件被称为遥控事件，因为它可以源自外部附件。而在我们开发过程中最常用的就是多点触摸事件。

![Event in iOS](http://kunkun.qiniudn.com/yknote/eventhandling/events_to_app_2x.png?imageView2/2/w/600)

### 二、事件传递与响应链

当您设计应用程式时，可能需要动态响应事件。 例如，触摸可以发生在屏幕上的许多不同对象中，并且您必须决定您想要那个对象响应事件，并且理解该对象如何接收该事件。

当用户生成的事件发生时，UIKit创建一个包含处理事件所需信息的事件对象。 然后它将事件对象放置在活动应用程序的事件队列中。 对于触摸事件，该对象是在UIEvent对象中打包的一组触摸。 对于运动事件，事件对象因您使用的框架和您感兴趣的运动事件类型而异。

事件沿着特定路径传递，直到它被传递到可以处理它的对象。 首先，单例UIApplication对象从队列的顶部获取一个事件并分发处理。 通常，它将事件发送到应用程序的key window对象，该对象将事件传递到初始对象(initial object)进行处理。 初始对象取决于事件的类型。

- 触摸事件：对于触摸事件，窗口对象首先尝试将事件传递到发生触摸的视图。 该视图称为命中测试视图（hit-test view）。 找到命中测试视图（hit-test view）的过程称为命中测试（hit-testing），这在[Hit-Testing返回触摸发生的视图](#1-Hit-Testing返回触摸发生的视图)中描述。

- 运动和遥控事件：对于这些事件，窗口对象将摇动或远程控制事件发送到第一响应者以进行处理。 第一响应者在[响应者链由响应者对象组成](#2-响应者链由响应者对象组成)中描述。

这些事件路径的最终目标是找到一个可以处理和响应事件的对象。 因此，UIKit首先将事件发送到最适合处理事件的对象。 对于触摸事件，该对象是命中测试视图（hit-test view），对于其他事件，该对象是第一个响应者。 以下部分更详细地说明命中测试视图（hit-test view）和第一响应者对象是如何确定的。

#### 1. Hit-Testing返回触摸发生的视图



#### 2. 响应者链由响应者对象组成



#### 3. 响应者链遵循特定传递路径



参考：

https://developer.apple.com/library/content/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Introduction/Introduction.html

https://developer.apple.com/library/content/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/event_delivery_responder_chain/event_delivery_responder_chain.html