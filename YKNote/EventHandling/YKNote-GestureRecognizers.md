## 手势识别器

手势识别器是附加到视图的对象，将低级别事件处理代码转换为更高级别的操作，它允许视图以控件执行的方式响应操作。 手势识别器解释触摸以确定它们是否对应于特定手势，诸如滑动，捏合或旋转，如果识别他们特定的姿势，他们发送动作消息到目标对象。 目标对象通常是视图的控制器，它响应手势，如下图所示。 这种设计模式既强大又简单; 您可以动态确定视图响应的动作，您可以向视图添加手势识别器，而无需对视图进行子类化。



![A gesture recognizer attached to view](http://kunkun.qiniudn.com/gestureRecognizer_2x.png?imageView2/2/w/500)



### 一、使用手势识别器简化事件处理

UIKit框架提供预定义的手势识别器，用来检测常见手势。 我们最好尽可能使用预定义的手势识别器，因为它们的简单性减少了必须编写的代码量。 此外，使用标准手势识别器，而不是自己写手势识别器，可以确保您的应用程序按用户期望的方式运行。

如果您希望应用程序识别独特的手势（例如复选标记或旋转动作），则可以创建自己的自定义手势识别器。 要了解如何设计和实现自己的手势识别器，请参阅创建自定义手势识别器。

#### 1. 内置手势识别器识别常见手势

UIKit框架提供以下预设的手势识别器，在设计app的时候可以考虑想要使用那个手势来满足自己的需求。




| 手势            | UIKit类                                   |
| ------------- | ---------------------------------------- |
| 点击（任意个数点击）    | [UITapGestureRecognizer](https://developer.apple.com/reference/uikit/uitapgesturerecognizer) |
| 缩放（用于缩放视图）    | [UIPinchGestureRecognizer](https://developer.apple.com/reference/uikit/uipinchgesturerecognizer) |
| 平移或拖动         | [UIPanGestureRecognizer](https://developer.apple.com/reference/uikit/uipangesturerecognizer) |
| 滑动（任意方向）      | [UISwipeGestureRecognizer](https://developer.apple.com/reference/uikit/uiswipegesturerecognizer) |
| 旋转（手指沿相反方向移动） | [UIRotationGestureRecognizer](https://developer.apple.com/reference/uikit/uirotationgesturerecognizer) |
| 长按（也称触摸并保持）   | [UILongPressGestureRecognizer](https://developer.apple.com/reference/uikit/uilongpressgesturerecognizer) |



#### 2. 手势识别器是附加到视图上

每个手势识别器与一个视图相关联。 相比之下，视图可以具有多个手势识别器，因为单个视图可以响应许多不同的手势。 对于手势识别器来识别在特定视图中发生的触摸，必须将手势识别器附加到该视图。 当用户触摸该视图时，手势识别器要先于视图对象接收发生的触摸消息。 所以，手势识别器可以代表视图来响应触摸。



#### 3. 手势触发动作消息

当手势识别器识别出其指定的手势，它将向目标对象发送动作消息。要创建动作识别器，你需要使用目标对象和动作进行初始化。



##### 3.1 离散和连续手势

一个手势不是离散的就是连续的。离散手势（例如轻敲）发生一次。 连续手势则在一段时间内发生，例如挤压。 对于离散手势，手势识别器向其目标发送单个动作消息。 连续手势的手势识别器则持续向其目标发送动作消息，直到多点触摸序列结束，如下图所示。

![Discrete and continuous gestures](http://kunkun.qiniudn.com/discrete_vs_continuous_2x.png?imageView2/2/w/500)



### 二、响应手势识别器的事件

向你的app添加内置的手势识别器需要做三件事情：

- 创建并配置手势识别器实例。

  这一步包括指定目标、动作，并且有时候需要指定手势识特定属性（例如：numberOfTapsRequired点击次数）

- 将手势识别器附加到视图上。

- 实现处理手势的动作方法。

#### 1. 使用Interface Builder来添加手势识别器到App

在Xcode的Interface Builder中，向应用程序添加手势识别器的方式与向用户界面添加任何对象的方式相同，即将手势识别器从对象库拖动到视图。 执行此操作时，手势识别器会自动附加到该视图。 您可以检查您的手势识别器连接到哪个视图，如果需要，更改nib文件中的连接。

创建手势识别器对象后，需要创建和连接操作方法。 当所连接的手势识别器识别其手势时，会调用该方法。 如果您需要将手势识别器关联此操作方法之外，则还应为手势识别器创建并连接outlet。 如下代码：



```objc
@interface YKNoteGestureRecognizerViewController ()

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;

@end

@implementation YKNoteGestureRecognizerViewController

- (IBAction)handleTapRecognizer:(UITapGestureRecognizer *)sender {
  // implement the method
}

@end
```



#### 2. 以编程方式添加手势识别器

你可以通过分配和初始化具体的UIGestureRecognizer子类的实例（如UIPinchGestureRecognizer）以编程方式创建手势识别器。 初始化手势识别器时，请指定目标对象和操作选择器。 通常，目标对象是视图的视图控制器。

如果以编程方式创建手势识别器，则需要使用addGestureRecognizer：方法将其附加到视图上。 下面代码创建了单击手势识别器，指定需要一个轻击以识别手势，然后将手势识别器对象附加到视图。 通常，在视图控制器的viewDidLoad方法中创建一个手势识别器，如下所示：



```objc
- (void)viewDidLoad {
     [super viewDidLoad];
 
     // Create and initialize a tap gesture
     UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
          initWithTarget:self action:@selector(respondToTapGesture:)];
 
     // Specify that the gesture must be a single tap
     tapRecognizer.numberOfTapsRequired = 1;
 
     // Add the tap gesture recognizer to the view
     [self.view addGestureRecognizer:tapRecognizer];
 
     // Do any additional setup after loading the view, typically from a nib
}
```



#### 3. 响应离散手势

当创建手势识别器时，将识别器连接到操作方法。 使用此操作方法来响应手势识别器的手势。 

响应单击手势：

```objc
- (IBAction)handleTapRecognizer:(UITapGestureRecognizer *)sender {
    NSLog(@"%s recognizer status:%ld", __PRETTY_FUNCTION__, sender.state);

    CGPoint location = [sender locationInView:self.view];
    
    [self drawImageForGestureRecognizer:sender atPoint:location];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.alpha = 0.0;
    }];
}
```



每个手势识别器都有自己的一组属性。 例如，滑动手势识别器的direction属性来确定用户是向左还是向右滑动。

```objc
- (IBAction)handleSwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    NSLog(@"%s recognizer status:%ld", __PRETTY_FUNCTION__, sender.state);

    CGPoint location = [sender locationInView:self.view];
    
    [self drawImageForGestureRecognizer:sender atPoint:location];
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        location.x -= 100;
    } else {
        location.x += 100;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.alpha = 0.0;
        self.imageView.center = location;
    }];
}
```



#### 4. 响应连续手势

连续手势允许你的应用程序相应一个正在发生的手势。例如，你可以在用户捏的时候进行缩放或者允许用户在屏幕上进行拖拽。

```objc
- (IBAction)handleRotationRecognizer:(UIRotationGestureRecognizer *)sender {
    NSLog(@"%s recognizer status:%ld", __PRETTY_FUNCTION__, sender.state);

    CGPoint location = [sender locationInView:self.view];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(sender.rotation);
    self.imageView.transform = transform;
    
    [self drawImageForGestureRecognizer:sender atPoint:location];
    
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.5 animations:^{
            self.imageView.alpha = 0.0;
            self.imageView.transform = CGAffineTransformIdentity;
        }];
    }
}
```



### 三、定义手势识别器如何交互

通常，当向应用程序添加手势识别器时，你需要明确你希望手势识别器如何与其他手势交互或者与应用程序中触摸事件处理代码进行交互。 要做到这一点，你首先需要了解一点手势识别器如何工作。












参考：

https://developer.apple.com/library/content/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/GestureRecognizer_basics/GestureRecognizer_basics.html