//
//  YKNoteTimerViewController.m
//  YKNote
//
//  Created by wanyakun on 2017/2/16.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import "YKNoteTimerViewController.h"
#import "NSTimer+YKNoteBlock.h"
#import "YKNoteTimerProxy.h"

@interface YKNoteTimerViewController ()

@property (nonatomic, strong) NSTimer *blockTimer;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YKNoteTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Timer";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSMethodSignature *methodSignature = [self methodSignatureForSelector:@selector(timerHandler)];
//    
//    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
//    [invocation setTarget:self];
//    [invocation setSelector:@selector(timerHandler)];
//    
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1 invocation:invocation repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
//    _blockTimer = [NSTimer yk_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *timer) {
//        NSLog(@"%@-----%p", timer, &timer);
//    }];
    
    YKNoteTimerProxy *proxy = [YKNoteTimerProxy timerProxyWithTarget:self];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:proxy selector:@selector(timerHandler) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if ([_blockTimer isValid]) {
        [_blockTimer invalidate];
        _blockTimer = nil;
    }
    
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)timerHandler {
    NSLog(@"Timer Handler");
}

@end
