//
//  YKNoteNotificationViewController.m
//  YKNote
//
//  Created by wanyakun on 2021/5/26.
//  Copyright © 2021 wanyakun.github.io. All rights reserved.
//

#import "YKNoteNotificationViewController.h"

@interface YKNoteNotificationViewController ()<NSMachPortDelegate>

@property(nonatomic, strong) NSMutableArray     *notifications;         // 通知队列
@property(nonatomic, strong) NSThread           *notificationThread;    // 期望线程
@property(nonatomic, strong) NSLock             *notificationLock;      // 用于对通知队列加锁的锁对象，避免线程冲突
@property(nonatomic, strong) NSMachPort         *notificationPort;      // 用于向期望线程发送信号的通信端口

@end

@implementation YKNoteNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Notification";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"...");
    NSLog(@"current thread = %@", [NSThread currentThread]);
    
    self.notifications = [[NSMutableArray alloc] initWithCapacity:5];
    self.notificationLock = [[NSLock alloc] init];
    self.notificationThread = [NSThread currentThread];
    self.notificationPort = [[NSMachPort alloc] init];
    self.notificationPort.delegate = self;
    
    [[NSRunLoop currentRunLoop] addPort:self.notificationPort forMode:NSRunLoopCommonModes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processNotification:) name:@"KNotificationTest" object:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KNotificationTest" object:nil userInfo:nil];
    });
}

- (void)processNotification:(NSNotification *)notifcation {
    if ([NSThread currentThread] != self.notificationThread) {
        // 转发到正确的线程
        [self.notificationLock lock];
        [self.notifications addObject:notifcation];
        [self.notificationLock unlock];
        
        [self.notificationPort sendBeforeDate:[NSDate date] components:nil from:nil reserved:0];
    } else {
        // 在这里处理通知
        NSLog(@"current thread = %@", [NSThread currentThread]);
        NSLog(@"process notifcation");
    }
}


#pragma mark - NSMachPortDelegate
- (void)handleMachMessage:(void *)msg {
    [self.notificationLock lock];
    while (self.notifications.count > 0) {
        NSNotification *notification = [self.notifications objectAtIndex:0];
        [self.notifications removeObjectAtIndex:0];
        [self.notificationLock unlock];
        [self processNotification:notification];
        [self.notificationLock lock];
        
    }
    [self.notificationLock unlock];
}

@end
