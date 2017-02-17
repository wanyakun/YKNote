//
//  YKNoteTimer.m
//  YKNote
//
//  Created by wanyakun on 2016/12/23.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteTimer.h"

typedef void(^YKNoteTimerBlock)(void);


@interface YKNoteTimer ()

@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, assign) BOOL valid;

@property (nonatomic, assign) BOOL repeats;

@property (nonatomic, copy)  YKNoteTimerBlock block;

@end

@implementation YKNoteTimer

- (instancetype)init {
    if (self = [super init]) {
        _valid = YES;
        _repeats = YES;
    }
    
    return self;
}

+ (YKNoteTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats {
    YKNoteTimer *timer = [[YKNoteTimer alloc] init];
    timer.timeInterval = interval;
    timer.repeats = repeats;
    timer.block = block;
    
    [timer performTimer];
    
    return timer;
}

- (void)performTimer {
    dispatch_time_t time = dispatch_walltime(DISPATCH_TIME_NOW, (int64_t)(self.timeInterval * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        if (self.block) {
            self.block();
        }
        if (self.repeats && self.valid) {
            [self performTimer];
        }
    });
}

- (void)invalidate {
    self.valid = NO;
}


@end
