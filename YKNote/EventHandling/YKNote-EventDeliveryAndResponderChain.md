# iOS事件传递与响应者链

用户以多种方式操纵他们的iOS设备，例如触摸屏幕或摇动设备。 iOS会解释用户何时以及如何操作硬件并将此信息传递到您的应用程序。 您的应用程序以自然和直观的方式响应操作的次数越多，对用户而言越有吸引力的体验。

### 一、事件分类

事件是发送到应用程序用于通知用户操作的对象。 在iOS中，事件可以采取多种形式：多点触摸事件，运动事件和用于控制多媒体的事件。 这最后一种类型的事件被称为遥控事件或者远程控制事件，因为它可以源自外部附件。而在我们开发过程中最常用的就是多点触摸事件。

![Event in iOS](http://kunkun.qiniudn.com/yknote/eventhandling/events_to_app_2x.png?imageView2/2/w/600)

### 二、事件传递与响应链

当您设计应用程式时，可能需要动态响应事件。 例如，触摸可以发生在屏幕上的许多不同对象中，并且您必须决定您想要那个对象响应事件，并且理解该对象如何接收该事件。

当用户生成的事件发生时，UIKit创建一个包含处理事件所需信息的事件对象。 然后它将事件对象放置在活动应用程序的事件队列中。 对于触摸事件，该对象是在UIEvent对象中打包的一组触摸。 对于运动事件，事件对象因您使用的框架和您感兴趣的运动事件类型而异。

事件沿着特定路径传递，直到它被传递到可以处理它的对象。 首先，单例UIApplication对象从队列的顶部获取一个事件并分发处理。 通常，它将事件发送到应用程序的key window对象，该对象将事件传递到初始对象(initial object)进行处理。 初始对象取决于事件的类型。

- 触摸事件：对于触摸事件，窗口对象首先尝试将事件传递到发生触摸的视图。 该视图称为命中测试视图（hit-test view）。 找到命中测试视图（hit-test view）的过程称为命中测试（hit-testing），这在[Hit-Testing返回触摸发生的视图](#1-Hit-Testing返回触摸发生的视图)中描述。

- 运动和遥控事件：对于这些事件，窗口对象将摇动或远程控制事件发送到第一响应者以进行处理。 第一响应者在[响应者链由响应者对象组成](#2-响应者链由响应者对象组成)中描述。

这些事件路径的最终目标是找到一个可以处理和响应事件的对象。 因此，UIKit首先将事件发送到最适合处理事件的对象。 对于触摸事件，该对象是命中测试视图（hit-test view），对于其他事件，该对象是第一个响应者。 以下部分更详细地说明命中测试视图（hit-test view）和第一响应者对象是如何确定的。

#### 1. Hit-Testing返回触摸发生的视图

iOS使用命中测试（hit-testing）来查找被触摸的视图。 命中测试（hit-testing）涉及检查触摸是否在所有相关视图对象的边界内。 如果是，它会递归检查视图的所有子视图。视图层级中包含触摸点的最低的视图成为命中测试视图（hit-test view） 。 iOS确定命中测试视图（hit-test view）后，它会将触摸事件传递到该视图进行处理。

举例说明，假设用户触摸下图中的View E。 iOS通过按照此顺序检查子视图来查找命中测试视图（hit-test view）：

1. 触摸在View A的边界内，因此它检查子视图View B和View C.

2. 触摸不在View B的界限内，但它在View C的界限内，因此它检查子视图View D和View E.

3. 触摸不在View D的界限内，但它在View E的界限内。

   View E是视图层级中包含触摸的最低的视图，因此它成为命中测试视图（hit-test view）。

   ![Hit-testing returns the subview that was touched](http://kunkun.qiniudn.com/yknote/eventhandling/hit_testing_2x.png?imageView2/2/w/300)



`hitTest:withEvent:`方法为给定的CGPoint和UIEvent返回一个点击测试视图（hit-test view）。`hitTest:withEvent:`方法首先调用`pointInside:withEvent:`方法。 如果传递到`hitTest:withEvent:`方法的点是在视图的边界内，`pointInside:withEvent:`返回YES。然后，在每个返回YES的子视图上递归调用`hitTest:withEvent:`方法 。

如果传递到`hitTest:withEvent:`方法的点不在视图的边界内，第一次调用`pointInside:withEvent:`方法返回 NO ，该点被忽略，`hitTest:withEvent:`返回nil 。 如果子视图返回NO，则视图层级结构的这个整个分支将被忽略，因为如果触摸没有发生在该子视图中，则它也不会出现在该子视图的任何子视图中。这意味着在子视图内而在父视图之外的任何点都不能接受点击事件，因为触摸点必须在父视图和子视图边界内。如果子视图的clipsToBounds属性设置为NO，则可能出现此问题。见示例[将事件传递给子视图](#4-将事件传递给子视图)

> 注：触摸对象为其生命周期而关联到其命中测试视图（hit-test view），即使触摸稍后移动到视图之外。

命中测试视图（hit-test view）被给予首先处理触摸事件的机会。 如果命中测试视图（hit-test view）无法处理的事件，事件沿着响应者链向上传播（如[响应者链由响应者对象组成](#2-响应者链由响应者对象组成)中描述），直到系统找到一个可以处理它的对象。


#### 2. 响应者链由响应者对象组成

许多类型的事件依赖于为事件传递的响应者链。 响应链是一系列被链接起来的响应对象。 它从第一响应者开始，到程序对象（UIApplication object）结束。 如果第一响应者不能处理事件，它转发事件到响应者链中的下一个响应者。

响应者对象是一个可以响应和处理事件的对象。 UIResponder类是所有响应者对象的基类，它不仅为事件处理定义编程接口，也为常见响应者行为定义编程接口。UIApplication， UIViewController和UIView类的实例都是响应者（responder），这意味着所有的视图和大多数控制器对象都是响应者。 注意核心动画层不是响应者。

第一个响应者被指定为第一个接收事件。 通常，第一响应者是视图对象。 一个对象通过做两件事情成为第一个响应者：

1. 重写`canBecomeFirstResponder`方法返回YES。
2. 接收`becomeFirstResponder`消息。 如果需要，对象可以向自身发送此消息。

> 注：请确保您的应用程序在指派一个对象成为第一个响应者之前已经建立了对象图（**has established its object graph，个人感觉应该理解为对象已经被渲染完成**）。 例如，您通常在重写的`viewDidAppear:`方法中调用`becomeFirstResponder`方法。 如果您尝试在`viewWillAppear:`中指派第一响应者，你的对象图尚未建立（**object graph is not yet established，个人理解为对象渲染尚未完成**），所以`becomeFirstResponder`方法返回 NO 。



事件不是唯一依赖响应者链的对象，响应者链用于以下所有情况：

- 触摸事件（Touch events）：如果命中测试视图（hit-test view）不能够处理触摸事件，事件以命中测试视图（hit-test view）为起点沿着响应者链向上传递。
- 运动事件（Motion events）：为了使用UIKit处理摇动动作事件，第一响应者必须实现`UIResponder`类的`motionBegan:withEvent:`或`motionEnded:withEvent:`的方法。
- 遥控事件（Remote control event）：为了处理遥控事件，第一响应者必须实现`UIResponder`类的`remoteControlReceivedWithEvent:`方法。
- 动作消息（Action messages）：当用户操作一个控制对象，例如一个按钮（button）或者开关（switch），并且动作方法（action method）的目标（target）是nil，则消息以控制视图为起点沿着响应者链传递。参阅示例：[将事件传递给父视图](#2-将事件传递给父视图)
- 编辑菜单消息（Editing-menu messages）：当用户点击编辑菜单中的命令，iOS使用响应者链找到实现了必要方法的对象（如`cut:` ，`copy:`和`paste:` ）。 想了解更多信息，请参阅[显示和管理编辑菜单](https://developer.apple.com/library/content/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/AddingCustomEditMenuItems/AddingCustomEditMenuItems.html#//apple_ref/doc/uid/TP40009542-CH13) 。


- 文本编辑（Text editing）：当用户点击text field或text view，该视图自动成为第一个响应者。 默认情况下，虚拟键盘出现，text field或text view成为编辑的焦点。您可以显示自定义输入视图，而不是键盘。 您还可以向任何响应者对象添加自定义输入视图。 想了解更多信息，请参阅[自定义数据输入视图](https://developer.apple.com/library/content/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/InputViews/InputViews.html#//apple_ref/doc/uid/TP40009542-CH12) 。

UIKit自动设置用户点击的text field或text view为第一个响应者; 应用程序必须使用`becomeFirstResponder`方法显式设置所有其他对象为第一响应者。

#### 3. 响应者链遵循特定传递路径

如果初始对象（命中测试视图或第一个响应者）不处理事件，UIKit将事件传递给链中的下一个响应者。 每个响应者决定是否它要处理事件或通过调用其`nextRsponder`方法传递给它自己的下一个响应者。这种处理持续进行，直到一个响应者对象处理事件或有没有更多的响应者。

当iOS检测到事件并将其传递给初始对象（通常是视图）时，响应者链序列开始。 初始视图拥有第一机会处理事件。下图显示了两个不同配置应用程序的两个不同事件传递路径。应用程序的事件传递路径取决于其特定结构，但所有事件传递路径都遵循相同的探视程序。

![The responder chain on iOS](http://kunkun.qiniudn.com/yknote/eventhandling/iOS_responder_chain_2x.png?imageView2/2/w/600)



对于左侧的应用程序，事件遵循以下路径：

1. **初始视图**试图处理该事件或消息。如果它不能处理这个事件，它将事件传递到其父视图 ，因为初始视图在它的视图控制器的视图层次中不是最顶部的视图。
2. **父视图**尝试处理该事件。如果父视图不能处理事件，它将事件传递到其超级视图，因为它仍然不是视图层次中最顶部的视图。
3. 视图控制器的视图层次中**最顶层视图**尝试处理该事件。如果最顶层的视图不能处理事件，它将事件传递到它的视图控制器。
4. **视图控制器**尝试处理该事件，如果不能，将事件传递到窗口。
5. 如果**窗口对象**不能处理该事件，传递事件到单例应用程序对象。
6. 如果**应用程序对象**不能处理这个事件，它丢弃该事件。

右侧的应用程序遵循稍微不同的路径，但所有事件传递路径遵循以下探视程序：

1. 视图在其视图控制器的视图层次结构上向上传递事件，直到它到达最顶层视图。

2. 最顶层视图将事件传递到其视图控制器。

3. 视图控制器将事件传递到其最顶层视图的父视图。

   重复步骤1-3，直到事件到达根视图控制器。

4. 根视图控制器将事件传递到窗口对象。

5. 窗口将事件传递给应用程序对象。



> **重要提示：**如果您实现一个自定义视图来处理遥控事件，动作消息，UIKit的摇移动事件，或编辑菜单消息，不要直接转发事件或消息到`nextResponder`来沿响应者链向上传递。 相反，调用当前事件处理方法的超类实现，让UIKit处理响应者链的遍历。



### 三、应用

从事件传递与响应者链的内容思考一些应用例子。

#### 1. 扩大视图的点击区域

一个按钮的尺寸是20*20，如果要扩大按钮的点击区域（上下左右各扩大10），有以下处理方法：

- 按钮设置image，然后按钮的size设置的比实际大一倍。
- 在按钮上覆盖一层较大的View或者Button，设置点击事件。
- 自定义Button，覆盖`hitTest:withEvent:`或者`pointInside:withEvent:`方法。

我们只举例说明第三种方法：

```objc
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.userInteractionEnabled == NO || self.hidden || self.alpha <= 0.01) {
        return nil;
    }
    
    CGRect responseRect = CGRectInset(self.bounds, -10, -10);
    if (CGRectContainsPoint(responseRect, point)) {
        for (UIView *subView in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subView convertPoint:point fromView:self];
            UIView *hitTestView = [subView hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return self;
    }
    return nil;
}
```

或者

```objc
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);   
    CGRect bounds = CGRectInset(self.bounds, -10, -10);
    return CGRectContainsPoint(bounds, point);
}
```



#### 2. 将事件传递给父视图

在controller中有一个YKNoteEventHandingView，其上面再添加一个YKNoteEventHandlingButton，点击Button将事件传递到View。有以下几种做法：

- Button的`- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event`方法返回nil，hit-test view为父视图


- 设置Button的target为nil，Button无法处理事件响应，事件沿着响应者链向上传递，传递到父视图。示例如下

```objc
#import "YKNoteEventHandingView.h"

@implementation YKNoteEventHandingView
//在View中写一个action方法，判断View中的Button的target为nil的时候是否会执行，若执行，则消息沿着响应者链向上传递了
- (void)ykNoteEventHandlingGreenButtonDidTouchUpInside:(UIButton *)button {
    NSLog(@"%s \n %@", __PRETTY_FUNCTION__, button);
}

@end
  
#import "YKNoteEventHandlingButton.h"
//在Button中写一个action方法，判断Button的target为nil的时候是否会执行，若执行，则消息沿着响应者链传递了
@implementation YKNoteEventHandlingButton

- (void)ykNoteEventHandlingGreenButtonDidTouchUpInside:(UIButton *)button {
    NSLog(@"%s \n %@", __PRETTY_FUNCTION__, button);
}
```

```objc
#import "YKNoteEventHandingViewController.h"
#import "YKNoteEventHandingView.h"
#import "YKNoteEventHandlingButton.h"

@interface YKNoteEventHandingViewController ()

@property (nonatomic, strong) YKNoteEventHandingView *yKNoteEventHandingView;
@property (nonatomic, strong) YKNoteEventHandlingButton *ykNoteEventHandlingButton;

@end

@implementation YKNoteEventHandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"EventHandling";
    self.view.backgroundColor = [UIColor whiteColor];
    //View
    [self.yKNoteEventHandingView setFrame:CGRectMake(50, 100, 200, 200)];
    [self.view addSubview:self.yKNoteEventHandingView];

    //Button
    [self.ykNoteEventHandlingButton setFrame:CGRectMake(60, 60, 100, 100)];
    [self.yKNoteEventHandingView addSubview:self.ykNoteEventHandlingButton];
}

#pragma mark - event
- (void)ykNoteEventHandlingGreenButtonDidTouchUpInside:(UIButton *)button {
    NSLog(@"%s \n %@", __PRETTY_FUNCTION__, button);
}

#pragma mark - getter
- (YKNoteEventHandingView *)yKNoteEventHandingView {
    if (_yKNoteEventHandingView == nil) {
        _yKNoteEventHandingView = [[YKNoteEventHandingView alloc] init];
        _yKNoteEventHandingView.backgroundColor = [UIColor redColor];
    }
    return _yKNoteEventHandingView;
}

- (YKNoteEventHandlingButton *)ykNoteEventHandlingButton {
    if (_ykNoteEventHandlingButton == nil) {
        _ykNoteEventHandlingButton = [[YKNoteEventHandlingButton alloc] init];
        _ykNoteEventHandlingButton.backgroundColor = [UIColor greenColor];
        [_ykNoteEventHandlingButton addTarget:nil action:@selector(ykNoteEventHandlingGreenButtonDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ykNoteEventHandlingButton;
}
```

```objc
  //Button的target设置为nil的时候，执行了YKNoteEventHandlingButton中的方法，说明target为nil的时候事件沿着响应者链传递了
  -[YKNoteEventHandlingButton ykNoteEventHandlingGreenButtonDidTouchUpInside:] 
   <YKNoteEventHandlingButton: 0x100224950; baseClass = UIButton; frame = (60 60; 100 100); opaque = NO; layer = <CALayer: 0x17002a1a0>>

  //注释掉Button中的方法。输出内容如下，说明事件沿着响应者链向上传递了。
  -[YKNoteEventHandingView ykNoteEventHandlingGreenButtonDidTouchUpInside:] 
   <YKNoteEventHandlingButton: 0x10030fe40; baseClass = UIButton; frame = (60 60; 100 100); opaque = NO; layer = <CALayer: 0x17003d520>>

  //注释掉Button和View中的方法。输出内容如下，说明事件沿着响应者链向上传递了。
  -[YKNoteEventHandingViewController ykNoteEventHandlingGreenButtonDidTouchUpInside:] 
   <YKNoteEventHandlingButton: 0x100402fd0; baseClass = UIButton; frame = (60 60; 100 100); opaque = NO; layer = <CALayer: 0x1740315a0>>
```



#### 3. 将事件传递给兄弟视图 

假设有下图所示的布局，我们希望点击view C的时候view B响应事件，而点击View D和View E的时候正常响应。这个时候通过重写view C的hittest可以解决这个问题，在C的hittest里面直接返回nil就行了。

![Hit-testing returns the subview that was touched](http://kunkun.qiniudn.com/yknote/eventhandling/hit_testing_2x.png?imageView2/2/w/300)



```objc
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    UIView *hitTestView = [super hitTest:point withEvent:event];
    if (hitTestView == self) {
        return nil;
    }
    return hitTestView;    
}
```



#### 4. 将事件传递给子视图

如下图，banner为CollectionView中的一个楼层，CollectionViewCell中有个scrollView，scrollView中为图片，现在将cell的宽度缩小一半（变为蓝色框部分），设置cell和scrollview的clipsToBounds为NO，现在在右侧处滑动，scrollview中的图片显然不会滑动，因为不满足`pointInside:withEvent:`，这时只需要修改cell的`- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event`方法，返回scrollview即可。

![传递事件到子视图](http://kunkun.qiniudn.com/yknote/eventhandling/IMG_5060.jpg?imageView2/2/w/600)



```objc
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitTestView = [super hitTest:point withEvent:event];
    if (hitTestView == nil) {
        hitTestView = self.scrollView;
    }
    return hitTestView;
}
```



参考：

https://developer.apple.com/library/content/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/Introduction/Introduction.html

https://developer.apple.com/library/content/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/event_delivery_responder_chain/event_delivery_responder_chain.html