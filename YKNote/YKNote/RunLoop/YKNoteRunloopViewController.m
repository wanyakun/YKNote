//
//  YKNoteRunloopViewController.m
//  YKNote
//
//  Created by wanyakun on 2016/12/23.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteRunloopViewController.h"
#import "YKNoteTimer.h"

@interface YKNoteRunloopViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSThread *timerThread;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YKNoteRunloopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"RunLoop";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView fill];
    
    //测试oberver
//    [NSThread detachNewThreadSelector:@selector(testRunLoopObserver) toTarget:self withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.timer invalidate];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - private method
- (void)testTimer {
    //解决Timer在tableView滑动过程中暂停的问题
    //第一种方式，将timer加入到runloop时，指定mode为NSRunLoopCommonModes
    //    self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        NSLog(@"Timer block");
    //    }];
    //    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    //    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    //第二种方式，在子线程中启动Timer
    //    __weak __typeof__(self) weakSelf = self;
    //
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    ////        NSTimer *timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
    ////            NSLog(@"Timer block in sub thead");
    ////        }];
    //        __strong __typeof__(self) strongSelf = weakSelf;
    //        strongSelf.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    //
    //        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    //        [runLoop addTimer:strongSelf.timer forMode:NSDefaultRunLoopMode];
    //        [runLoop run];
    //    });
    
    self.timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadAction) object:nil];
    
    NSLog(@"timer thread address：%p", self.timerThread);
    [self.timerThread start];
    
    //    [YKNoteTimer scheduledTimerWithTimeInterval:1 block:^{
    //        NSLog(@"YKNoteTimer block");
    //    } repeats:YES];
}

- (void)timerAction:(NSTimer *)timer {
    NSLog(@"Timer Action");
}

- (void)threadAction {
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    [runLoop run];
}

- (void)testRunLoopObserver {
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &testRunLoopObserverCallBack, &context);
    if (observer) {
        CFRunLoopRef cfRunLoop = [runLoop getCFRunLoop];;
        CFRunLoopAddObserver(cfRunLoop, observer, kCFRunLoopDefaultMode);
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
    NSInteger loopCount = 10;
    do {
        [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        loopCount--;
    } while (loopCount > 0);
}

void testRunLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    
    NSLog(@"%s, activity:%lu", __PRETTY_FUNCTION__, activity);
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Row %ld", indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@", [NSThread callStackSymbols]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - getter setter 
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    
    return _tableView;
}

@end
