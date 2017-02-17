//
//  NSTimer+YKNoteBlock.h
//  YKNote
//
//  Created by wanyakun on 2017/2/17.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (YKNoteBlock)

+ (NSTimer *)yk_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                         block:(void (^)(NSTimer *timer))block;

@end
