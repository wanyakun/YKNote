//
//  YKNoteNonConcurrentOperation.m
//  YKNote
//
//  Created by wanyakun on 2016/12/6.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteNonConcurrentOperation.h"

@implementation YKNoteNonConcurrentOperation

- (instancetype)initWithData:(id)data {
    if (self = [super init]) {
        _data = data;
    }
    return self;
}

- (void)main {
    @try {
        if (![self isCancelled]) {
            //do some work
            NSLog(@"%s data: %@ %@", __PRETTY_FUNCTION__, self.data, [NSThread currentThread]);
        }
    } @catch (NSException *exception) {
        NSLog(@"%s exception:%@", __PRETTY_FUNCTION__, exception);
    }
}

@end
