//
//  YKNoteTimerProxy.m
//  YKNote
//
//  Created by wanyakun on 2017/2/17.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import "YKNoteTimerProxy.h"

@implementation YKNoteTimerProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

+ (instancetype)timerProxyWithTarget:(id)target {
    return [[YKNoteTimerProxy alloc] initWithTarget:target];
}

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    return _target;
//}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [_target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:_target];
}

@end
