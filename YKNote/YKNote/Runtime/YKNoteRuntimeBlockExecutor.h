//
//  YKNoteRuntimeBlockExecutor.h
//  YKNote
//
//  Created by wanyakun on 2017/1/6.
//  Copyright © 2017年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^executorBlock)(void);

@interface YKNoteRuntimeBlockExecutor : NSObject

- (instancetype)initWithBlock:(executorBlock)block;

@end
