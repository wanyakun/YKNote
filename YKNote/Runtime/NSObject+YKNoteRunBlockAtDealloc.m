//
//  NSObject+YKNoteRunBlockAtDealloc.m
//  YKNote
//
//  Created by wanyakun on 2017/1/6.
//  Copyright © 2017年 com.ucaiyuan. All rights reserved.
//

#import "NSObject+YKNoteRunBlockAtDealloc.h"
#import <objc/runtime.h>

static char runBlockAtDeallocKey;

@implementation NSObject (YKNoteRunBlockAtDealloc)

- (void)ykNoteRunAtDeallocWithBlock:(executorBlock)block {
    if (block) {
        YKNoteRuntimeBlockExecutor *executor = [[YKNoteRuntimeBlockExecutor alloc] initWithBlock:block];
        objc_setAssociatedObject(self, &runBlockAtDeallocKey, executor, OBJC_ASSOCIATION_RETAIN);
    }
}

@end
