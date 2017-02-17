//
//  NSTimer+YKNoteBlock.m
//  YKNote
//
//  Created by wanyakun on 2017/2/17.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import "NSTimer+YKNoteBlock.h"

@implementation NSTimer (YKNoteBlock)

+ (NSTimer *)yk_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                         block:(void (^)(NSTimer *))block {
    return [NSTimer scheduledTimerWithTimeInterval:interval
                                            target:self
                                          selector:@selector(blockInvoke:)
                                          userInfo:[block copy]
                                           repeats:repeats];

}

+ (void)blockInvoke:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo;
    if (block) {
        block(timer);
    }
}

@end
