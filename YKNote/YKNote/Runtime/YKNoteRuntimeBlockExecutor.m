//
//  YKNoteRuntimeBlockExecutor.m
//  YKNote
//
//  Created by wanyakun on 2017/1/6.
//  Copyright © 2017年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteRuntimeBlockExecutor.h"

@interface YKNoteRuntimeBlockExecutor () {
    executorBlock _block;
}

@end

@implementation YKNoteRuntimeBlockExecutor

- (instancetype)initWithBlock:(executorBlock)block {
    if (self = [super init]) {
        _block = [block copy];
    }
    
    return self;
}

- (void)dealloc {
    if (_block) {
        _block();
    }
}

@end
