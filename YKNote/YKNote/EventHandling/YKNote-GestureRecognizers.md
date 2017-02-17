## iOS手势识别器

手势识别器是附加到视图的对象，将低级别事件处理代码转换为更高级别的操作，它允许视图以控件执行的方式响应操作。 手势识别器解释触摸以确定它们是否对应于特定手势，诸如滑动，捏合或旋转，如果识别他们特定的手势，他们发送动作消息到目标对象。 目标对象通常是视图的控制器，它响应手势，如下图所示。 这种设计模式既强大又简单; 你可以动态确定视图响应的动作，你可以向视图添加手势识别器，而无需对视图进行子类化。



![A gesture recognizer attached to view](http://kunkun.qiniudn.com/yknote/eventhandling/gestureRecognizer_2x.png?imageView2/2/w/500)



### 一、使用手势识别器简化事件处理

UIKit框架提供预定义的手势识别器，用来检测常见手势。 我们最好尽可能使用预定义的手势识别器，因为它们的简单性减少了必须编写的代码量。 此外，使用标准手势识别器，而不是自己写手势识别器，可以确保您的应用程序按用户期望的方式运行。

如果您希望应用程序识别独特的手势（例如复选标记或旋转动作），则可以创建自己的自定义手势识别器。 要了解如何设计和实现自己的手势识别器，请参阅[创建自定义手势识别器](#六、创建自定义手势识别器)。

#### 1. 内置手势识别器识别常见手势

UIKit框架提供以下预设的手势识别器，在设计app的时候可以考虑想要使用哪个手势来满足自己的需求。




| 手势            | UIKit类                                   |
| ------------- | ---------------------------------------- |
| 点击（任意个数点击）    | [UITapGestureRecognizer](https://developer.apple.com/reference/uikit/uitapgesturerecognizer) |
| 缩放（用于缩放视图）    | [UIPinchGestureRecognizer](https://developer.apple.com/reference/uikit/uipinchgesturerecognizer) |
| 平移或拖动         | [UIPanGestureRecognizer](https://developer.apple.com/reference/uikit/uipangesturerecognizer) |
| 滑动（任意方向）      | [UISwipeGestureRecognizer](https://developer.apple.com/reference/uikit/uiswipegesturerecognizer) |
| 旋转（手指沿相反方向移动） | [UIRotationGestureRecognizer](https://developer.apple.com/reference/uikit/uirotationgesturerecognizer) |
| 长按（也称触摸并保持）   | [UILongPressGestureRecognizer](https://developer.apple.com/reference/uikit/uilongpressgesturerecognizer) |



#### 2. 手势识别器是附加到视图上

每个手势识别器与一个视图相关联。 相比之下，视图可以具有多个手势识别器，因为单个视图可以响应许多不同的手势。 手势识别器来识别在特定视图中发生的触摸，必须将手势识别器附加到该视图。 当用户触摸该视图时，手势识别器要先于视图对象接收发生的触摸消息。 所以，手势识别器可以代表视图来响应触摸。



#### 3. 手势触发动作消息

当手势识别器识别出其指定的手势，它将向目标对象发送动作消息。要创建动作识别器，你需要使用目标对象和动作进行初始化。



##### 3.1 离散和连续手势

一个手势不是离散的就是连续的。离散手势（例如轻敲）发生一次。 连续手势则在一段时间内发生，例如挤压。 对于离散手势，手势识别器向其目标发送单个动作消息。 连续手势的手势识别器则持续向其目标发送动作消息，直到多点触摸序列结束，如下图所示。

![Discrete and continuous gestures](http://kunkun.qiniudn.com/yknote/eventhandling/discrete_vs_continuous_2x.png?imageView2/2/w/500)



### 二、响应手势识别器的事件

向你的app添加内置的手势识别器需要做三件事情：

- 创建并配置手势识别器实例。

  这一步包括指定目标、动作，并且有时候需要指定手势识特定属性（例如：numberOfTapsRequired点击次数）

- 将手势识别器附加到视图上。

- 实现处理手势的动作方法。

#### 1. 使用Interface Builder来添加手势识别器到App

在Xcode的Interface Builder中，向应用程序添加手势识别器的方式与向用户界面添加任何对象的方式相同，即将手势识别器从对象库拖动到视图。 执行此操作时，手势识别器会自动附加到该视图。 您可以检查您的手势识别器连接到哪个视图，如果需要，更改nib文件中的连接。

创建手势识别器对象后，需要创建和连接操作方法。 当所连接的手势识别器识别其手势时，会调用该方法。 如果您需要将手势识别器进行此操作方法之外的关联，则还应为手势识别器创建并连接outlet。 如下代码：

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

你可以通过分配和初始化具体的UIGestureRecognizer子类的实例（如UIPinchGestureRecognizer）以编程方式创建手势识别器。 初始化手势识别器时，请指定目标对象和操作选择器。 通常，目标对象是视图的控制器。

如果以编程方式创建手势识别器，则需要使用addGestureRecognizer:方法将其附加到视图上。 下面代码创建了单击手势识别器，指定需要一个轻击以识别手势，然后将手势识别器对象附加到视图。 通常，在视图控制器的viewDidLoad方法中创建一个手势识别器，如下所示：

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

连续手势允许你的应用程序响应一个正在发生的手势。例如，你可以在用户捏的时候进行缩放或者允许用户在屏幕上进行拖拽。

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

#### 1. 手势识别器在限定的状态机中操作

手势识别器以预定义的方式从一个状态转换到另一个状态。 每个状态可以基于它们是否满足特定条件而移动到几个可能的下一个状态中的一个。 精确的状态机取决于手势识别器是离散还是连续的而变化。所有手势识别器都是从UIGestureRecognizerStatePossible开始。 他们分析收到的多点触摸序列，在分析期间，他们要么识别手势，要么未能识别。未能识别手势意味着手势识别器转换到UIGestureRecognizerStateFailed状态。

![State machines for gesture recognizers](http://kunkun.qiniudn.com/yknote/eventhandling/gr_state_transitions_2x.png?imageView2/2/w/500)

当离散手势识别器识别他的手势，手势识别器从Possible状态转换到Recognized（UIGestureRecognizerStateRecognized）状态，识别结束。

对于连续手势，当首次识别手势时，手势识别器从Possible状态转换到Began（UIGestureRecognizerStateBegan）状态。然后，从Began转换到Changed（UIGestureRecognizerStateChanged），并且随着手势发生继续从Changed转变到Changed。当用户的最后一个手指从视图抬起时，手势识别器转换到结束状态（UIGestureRecognizerStateEnded），并且识别完成。请注意，Ended状态是Recognized状态的别名。

如果连续手势的识别器决定手势不再符合期望的模式，则其也可以从Change状态转变到Canceled（UIGestureRecognizerStateCancelled）状态。

每当手势识别器改变状态时，手势识别器向其目标发送动作消息，除非它转变为Failed或Canceled。因此，当离散手势识别器状态从Possible转换为Recognized时仅发送单个动作消息。连续手势识别器在其改变状态时发送许多动作消息。

当手势识别器达到Recognized（或Ended）状态时，它将其状态重置为Possible。转换回Possible状态不会触发操作消息。

#### 2. 与其他手势识别器交互

一个视图可以附加多个手势识别器。使用视图的gestureRecognizers属性来确定哪些手势识别器附加到视图。您还可以通过使用addGestureRecognizer:和removeGestureRecognizer:方法分别从视图中添加或删除手势识别器来动态更改视图处理手势的方式。

当视图有多个手势识别器附加到它，你可能想修改手势识别器如何接收和分析触摸事件解决冲突。默认情况下，手势识别器没有设置接收触摸的先后顺序，由于这个原因，触摸可以每次以不同的顺序传递到手势识别器。您可以覆盖以下默认行为：

- 指定一个手势识别器应当先于另一手势识别器分析触摸。
- 允许两个手势识别器同时操作。
- 防止手势识别器分析触摸。

使用UIGestureRecognizer的类方法，委托方法和子类覆盖的方法来实现这些行为。

##### 2.1 为两个手势识别器声明特定的顺序

假设你想要识别滑动和平移手势，并且希望这两个手势触发不同的操作。默认情况下，当用户尝试滑动时，手势会被解释为平移。这是因为滑动手势在被解释满足滑动（离散手势）的必要条件之前，被解释为了满足为平移（连续手势）的必要条件。

为了让视图识别滑动和平移，需要滑动手势识别器在平移手势识别器之前分析触摸事件。如果滑动手势识别器确定触摸是滑动，则平移手势识别器不需要分析该触摸。如果滑动手势识别器确定触摸不是滑动，则其移动到Failed状态，平移手势识别器应开始分析触摸事件。

在你希望延迟的手势识别器上调用requireGestureRecognizerToFail:方法，可以在两个手势识别器之间指定这种关系。

```objc
- (void)viewDidLoad {
       [super viewDidLoad];
       // Do any additional setup after loading the view, typically from a nib
       [self.panRecognizer requireGestureRecognizerToFail:self.swipeRecognizer];
}
```

requireGestureRecognizerToFail:方法向接收方发送消息，并指定在接收识别器可以开始之前必须失败的一些其他识别器（otherGestureRecognizer）。当它等待另一手势识别器转换到失败状态时，接收识别器保持在Possible状态。 如果另一手势识别器失败，则接收识别器分析触摸事件并移动到其下一状态。 另一方面，如果另一手势识别器转变为Recognized或Began，则接收识别器移动到Failed状态。 

##### 2.2 防止手势识别器分析触摸

你可以通过向手势识别器添加委托对象来更改手势识别器的行为。 UIGestureRecognizerDelegate协议提供了几种方法，可以防止手势识别器分析触摸。可以使用gestureRecognizer:shouldReceiveTouch:方法或gestureRecognizerShouldBegin:方法（都是UIGestureRecognizerDelegate协议的可选方法）。

当触摸开始时，如果您可以立即确定您的手势识别器是否应该考虑该触摸，请使用gestureRecognizer:shouldReceiveTouch:方法。每次有新的触摸时，都会调用此方法。该方法默认值返回值为YES，返回NO，可以防止向手势识别器通知发生了触摸。该方法不改变手势识别器的状态。

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    // Add the delegate to the tap gesture recognizer
    self.tapGestureRecognizer.delegate = self;
}
 
// Implement the UIGestureRecognizerDelegate method
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // Determine if the touch is inside the custom subview
    if ([touch view] == self.customSubview){
        // If it is, prevent all of the delegate's gesture recognizers
        // from receiving the touch
        return NO;
    }
    return YES;
}
```

如果在决定手势识别器是否应分析触摸之前你需要尽可能长时间等待，请使用gestureRecognizerShouldBegin:代理方法。 通常，如果你有与手势识别器竞争自定义触摸事件处理的UIView或者UIControl的子类，则使用此方法。 返回NO导致手势识别器立即失败，这允许其他触摸处理继续进行。 当手势识别器尝试从Possible状态转出时，如果手势识别将阻止UIView或Control接收到触摸，则调用该方法。

如果你的UIView或Controller不能是手势识别器的委托，你可以使用gestureRecognizerShouldBegin:这个UIView方法。 方法签名和实现是一样的。

##### 2.3 允许同时手势识别

默认情况下，两个手势识别器不能同时识别它们各自的手势。 但是假设，例如，你希望用户能够同时捏（pinch）和旋转（rotate）视图。 您需要通过实现gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:方法(一个可选的UIGestureRecognizerDelegate协议的方法）来更改默认行为。 当一个手势识别器对手势的分析将阻止另一个手势识别器识别其手势时，或者反之亦然时，调用该方法。 此方法默认返回NO。 当您想要两个手势识别器同时分析其手势时，返回YES。

##### 2.4 指定两个手势识别器之间的单向关系

如果你想控制两个识别器如何相互交互，你需要指定一个单向关系，你可以覆盖canPreventGestureRecognizer:或canBePreventedByGestureRecognizer:子类方法返回NO（默认为YES）。 例如，如果您想要旋转手势阻止缩放手势，但您不想要缩放手势来阻止旋转手势，则可以指定：

```objc
[rotationGestureRecognizer canPreventGestureRecognizer:pinchGestureRecognizer];
```

并覆盖旋转手势识别器的子类方法以返回NO。 有关如何子类化UIGestureRecognizer的更多信息，请参阅[创建自定义手势识别器](#六、创建自定义手势识别器)。

如果两个手势都不能阻止另一个，请使用gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:方法，如[允许同时手势识别](#2-3-允许同时手势识别)中所述。 默认情况下，缩放手势阻止旋转，反之亦然，因为无法同时识别两个手势。

#### 3. 与其他用户界面控件交互

在iOS 6.0及更高版本中，默认控制操作阻止重叠的手势识别器行为。例如，按钮的默认操作是单击。如果你有一个单击手势识别器附加到一个按钮的父视图，用户点击按钮，那么按钮的动作方法接收触摸事件而不是手势识别器。这仅适用于与控件的默认操作与手势识别重叠，其中包括：

- 单指在UIButton，UISwitch，UIStepper，UISegmentedControl和UIPageControl上单击。
- 单指在UISlider的旋钮上滑动，方向平行于slider。
- 单指在UISwitch 旋钮上平移，方向平行于switch。

如果您有这些控件的自定义子类，并且想要更改默认操作，请将手势识别器直接附加到控件，而不是父视图。然后，手势识别器首先接收触摸事件。

### 四、手势识别器解释原始触摸事件

到目前为止，已经了解手势以及应用程序如何识别和响应它们。 但是，要创建自定义手势识别器或控制手势识别器如何与视图的触摸事件处理的交互，您需要更具体地了解触摸和事件。

#### 1. 事件包含当前多点触控序列的所有触摸

在iOS中，触摸是手指在屏幕上的存在或移动。手势具有一个或多个触摸，由UITouch对象表示。例如，收缩 - 关闭手势具有两个触摸 - 屏幕上的两个手指从相反方向朝向彼此移动。

事件包含多点触摸序列期间发生的所有触摸。多点触摸序列在手指触摸屏幕时开始，当最后一个手指抬起时结束。当手指移动时，iOS将触摸对象发送到事件。多点触摸事件由UIEventTypeTouches类型的UIEvent对象表示。

每个触摸对象只跟踪一个手指，并且持续时间和多点触摸序列一样长。在序列期间，UIKit跟踪手指并更新触摸对象的属性。这些属性包括触摸阶段，其在视图中的位置，其先前位置和其时间戳。

触摸阶段指示触摸何时开始，其是移动还是静止，以及何时结束（即，当手指不再触摸屏幕时）。如图所示，应用程序在触摸的每个阶段接收事件对象。

![A multitouch sequence and touch phases](http://kunkun.qiniudn.com/yknote/eventhandling/event_touch_time_2x.png?imageView2/2/w/600)

#### 2. 应用程序在触摸处理方法中接收触摸

在多点触摸序列中，当有新的或者改变的触摸时应用程序发送这些消息：

- touchesBegan:withEvent: 当一个或多个手指在屏幕上触摸时调用
- touchesMoved:withEvent: 当一个或多个手指移动时调用
- touchesEnded:withEvent: 当一个或多个手指不再触摸屏幕时调用
- touchesCancelled:withEvent: 当触摸序列被诸如来电电话的系统事件取消时调用

这些方法与触摸阶段相关联; 例如，touchesBegan:withEvent:方法与UITouchPhaseBegan相关联。 触摸对象的触摸阶段存储在其phase属性中。

### 五、调节触摸到视图的传递路径

有时，你希望视图在手势识别器之前接收到触摸。 但是，在你更改触摸到视图的传递路径之前，您需要了解默认行为。 在简单的情况下，当发生触摸时，触摸对象从UIApplication对象传递到UIWindow对象。 然后，在窗口将触摸传递到视图对象本身之前，窗口首先向关联到触摸发生的视图（或该视图的父视图）的所有手势识别器发送触摸。

![Default delivery path for touch events](http://kunkun.qiniudn.com/yknote/eventhandling/path_of_touches_2x.png?imageView2/2/w/600)

#### 1. 手势识别器获得第一个机会识别触摸

窗口延迟触摸对象传递到视图，使得手势识别可以首先分析触摸。在延迟期间，如果手势识别器识别触摸手势，则该窗口永远不会将触摸对象传递到视图，并且也取消一些前面发送到视图的识别序列中的触摸对象。

例如，如果你有一个需要两指触控的离散手势识别器，传送两个独立的触摸对象。随着触摸发生，触摸对象从应用程序对象传递给发生触摸的视图的窗口对象，并遵循以下顺序：

![Sequence of messages for touches](http://kunkun.qiniudn.com/yknote/eventhandling/recognize_touch_2x.png?imageView2/2/w/600)

1. 窗体通过touchesBegan:withEvent:方法发送两个在Began阶段的触摸对象到手势识别器。手势识别器还没有识别手势，所以其状态为Possible。窗体也发送这些同样的触摸对象到手势识别器所依附的视图。
2. 窗体通过touchesMoved:withEvent:方法发送两个在Moved阶段的触摸对象到手势识别器。识别器依然不检测手势，并且仍处于Possible状态。然后窗口将这些触摸发送到依附的视图。
3. 窗口通过touchesEnded:withEvent:方法发送一个在Ended阶段的触摸对象到手势识别器。此触摸对象不会为手势产生足够的信息，但窗口会从依附的视图中扣留该触摸对象（也就是说窗体不发送触摸对象到视图）。
4. 窗口发送另一个在Ended阶段的触摸对象。手势识别器现在识别其手势，因此它将其状态设置为Recognized。在第一个动作消息发送之前，视图调用touchesCancelled:withEvent:方法使先前在Began和Moved阶段发送的触摸对象无效。Ended阶段的触摸被取消。

现在假设在最后一步中的手势识别器决定它正在分析的这个多点触摸序列不是它的手势。 它将其状态设置为UIGestureRecognizerStateFailed。 然后，窗口将两个Ended阶段中的触摸对象通过touchesEnded:withEvent:消息发送到依附的视图。

连续手势识别器遵循类似的顺序，除了在触摸对象在到达Ended阶段之前很有可能识别手势。 在识别其手势时，它将其状态设置为UIGestureRecognizerStateBegan（not Recognized）。 窗口将多点触摸序列中的所有后续触摸对象发送到手势识别器，但不发送到附加视图。

#### 2. 影响触摸到视图的传递路径

您可以更改UIGestureRecognizer几个属性的值，以某些方式更改默认传递路径。如果更改这些属性的默认值，您会得到以下行为差异：

- delaysTouchesBegan（默认为NO）：通常情况下，窗口将Began和Move阶段中的触摸对象发送到视图和手势识别器。将delaysTouchesBegan设置为YES可以防止窗口将Began阶段中的触摸对象传递到视图。这确保当手势识别器识别手势时，没有将触摸事件的任何部分递送到其所附加的视图。请谨慎设置此属性，因为它可能会使你感觉界面无响应。

  此设置与UIScrollView上的delaysContentTouches属性类似；在这种情况下，当在触摸开始之后不久开始滚动时，滚动视图对象的子视图从不接收到触摸，因此没有视觉反馈。

- delaysTouchesEnded（默认为YES）：当此属性设置为YES时，它确保视图不会完成动作，因为手势稍后可能需要取消。当手势识别器正在分析触摸事件时，窗口不会传递Ended阶段的触摸对象到所附加的视图。如果手势识别器识别其手势，则取消触摸对象。如果手势识别器不识别其手势，则窗口通过touchesEnded:withEvent:消息将这些对象递送到视图。将此属性设置为NO允许视图和手识别器同时分析Ended阶段触的触摸对象。

  例如，视图具有需要两次点击的点击手势识别器，并且用户双击该视图。将属性设置为YES，视图将获得touchesBegan:withEvent:， touchesBegan:withEvent:，touchesCancelled:withEvent:，和touchesCancelled:withEvent:。如果此属性设置为NO，视图将获取以下消息序列：touchesBegan:withEvent:， touchesEnded:withEvent:，touchesBegan:withEvent:，和touchesCancelled:withEvent:，这意味着在touchesBegan:withEvent:，视图可以识别双击。

如果手势识别器检测确定触摸不是其手势的一部分，则它可以将触摸直接传递到其视图。如果想这么做，手势识别器在其自身上调用ignoreTouch:forEvent:方法，传入触摸对象。

### 六、创建自定义手势识别器

为了实现自定义手势识别器，首先在Xcode中创建UIGestureRecognizer的子类。然后在子类头文件中引入UIGestureRecognizerSubclass.h。

```objc
#import <UIKit/UIGestureRecognizerSubclass.h>
```

接下来，从UIGestureRecognizerSubclass.h的声明中复制以下方法到你的头文件。以下是需要在你的子类中需要覆写的方法：

```objc
- (void)reset;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
```

这些方法与在[应用程序在触摸处理方法中接收触摸](#2-应用程序在触摸处理方法中接收触摸)中所描述的触摸事件处理方法具有相同的签名和行为。 在所有覆盖的方法中，必须调用超类实现，即使该方法没有具体实现内容。

请注意，UIGestureRecognizerSubclass.h中的state属性现在是readwrite，而不是UIGestureRecognizer.h中的readonly。 你的子类通过为该属性分配UIGestureRecognizerState常量来更改其状态。

#### 1. 为自定义手势识别器实现触摸事件处理方法

实现自定义手势识别器的核心是四个方法：touchesBegan:withEvent:，touchesMoved:withEvent:，touchesEnded:withEvent:和touchesCancelled:withEvent:。在这些方法中，通过设置手势识别器的状态，将低级触摸事件转换为手势识别。 下面代码离散单触式选择标记手势创建了一个手势识别器。 它记录手势的midpoint（向上点击开始的点），以便客户端可以获得此值。

此示例只有一个视图，但大多数应用程序有很多视图。 一般来说，您应该将触摸位置转换为屏幕的坐标系，以便您可以正确识别跨多个视图的手势。

```objc
#import <UIKit/UIGestureRecognizerSubclass.h>
 
// Implemented in your custom subclass
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([touches count] != 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
}
 
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    
    //UIWindow *win = [self.view window];
    //CGPoint nowPoint = [touches.anyObject locationInView:win];
    
    CGPoint nowPoint = [touches.anyObject locationInView:self.view];
    CGPoint prevPoint = [touches.anyObject previousLocationInView:self.view]; 
    // strokeUp is a property
    if (!self.strokeUp) {
        // On downstroke, both x and y increase in positive direction
        if (nowPoint.x >= prevPoint.x && nowPoint.y >= prevPoint.y) {
            self.midPoint = nowPoint;
            // Upstroke has increasing x value but decreasing y value
        } else if (nowPoint.x >= prevPoint.x && nowPoint.y <= prevPoint.y) {
            self.strokeUp = YES;
        } else {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
}
 
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if ((self.state == UIGestureRecognizerStatePossible) && self.strokeUp) {
        self.state = UIGestureRecognizerStateRecognized;
    }
}
 
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.midPoint = CGPointZero;
    self.strokeUp = NO;
    self.state = UIGestureRecognizerStateFailed;
}
```

离散和连续手势的状态转换是不同的，如在[手势识别器在限定的状态机中操作](#1-手势识别器在限定的状态机中操作)所描述的。 创建自定义手势识别器时，通过为其分配相关状态来指示其是离散还是连续。上面代码中的选择标记手势识别器从不将状态设置为Began或Changed，因为它是离散的。

当子类化手势识别器时，你需要做的最重要的事情是准确地设置手势识别器的状态。 iOS需要知道手势识别器的状态，以便手势识别器按预期进行交互。 例如，如果要允许同时识别或需要手势识别器失败，iOS需要了解识别器的当前状态。

有关创建自定义手势识别器的更多信息，请参阅[WWDC 2012：构建高级手势识别器](https://developer.apple.com/videos/wwdc/2012/?id=233)。

#### 2. 重置手势识别器的状态

如果你的手势识别器转换为Recognized/Ended，Canceled或Failed，UIGestureRecognizer类将在手势识别器转换回Possible之前调用reset方法。

实现reset方法以重置任何内部状态，使你的识别器准备好进行识别新的手势。在手势识别器从该方法返回之后，它不再接收正在进行的触摸更新。

```objc
- (void)reset {
    [super reset];
    self.midPoint = CGPointZero;
    self.strokeUp = NO;
}
```



示例：https://github.com/wanyakun/YKNote/tree/master/YKNote/EventHandling

参考：https://developer.apple.com/library/content/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/GestureRecognizer_basics/GestureRecognizer_basics.html