//
//  YKNoteConcurrentOperation.m
//  YKNote
//
//  Created by wanyakun on 2016/12/6.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteConcurrentOperation.h"

@implementation YKNoteConcurrentOperation

- (instancetype)init {
    self = [super init];
    if (self) {
        executing = NO;
        finished = NO;
    }
    return self;
}

- (void)start {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ([self isCancelled]) {
        NSLog(@"%s, isCancelled", __PRETTY_FUNCTION__);
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main {
    @try {
        //执行主要的工作
        NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSThread currentThread]);
        [self completeOperaiton];
    } @catch (NSException *exception) {
        //不要抛出异常，自己处理异常
        
    }
}

- (void)completeOperaiton {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)waitUntilFinished {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}

@end
