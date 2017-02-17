//
//  NSObject+YKNoteRunBlockAtDealloc.h
//  YKNote
//
//  Created by wanyakun on 2017/1/6.
//  Copyright © 2017年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YKNoteRuntimeBlockExecutor.h"

@interface NSObject (YKNoteRunBlockAtDealloc)

- (void)ykNoteRunAtDeallocWithBlock:(executorBlock)block;

@end
