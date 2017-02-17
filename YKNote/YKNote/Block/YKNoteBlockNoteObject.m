//
//  YKNoteBlockNoteObject.m
//  YKNoteDemo
//
//  Created by wanyakun on 2016/11/3.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteBlockNoteObject.h"

@interface YKNoteBlockNoteObject ()

@property (nonatomic, copy) NSString *str;

@end

@implementation YKNoteBlockNoteObject

- (instancetype)init {
    self = [super init];
    
    _str = @"123";
    [self block];
    
    [self instanceMethod];
    
    [YKNoteBlockNoteObject classMethod];
    
    return self;
}

- (void)block {
    __weak __typeof(self) weakSelf = self;
    void (^block)() = ^() {
        __strong __typeof(self) strongSelf = weakSelf;
        NSLog(@"block str:%@", strongSelf.str);
    };
    block();
}

- (void)instanceMethod {
    NSLog(@"this is an instance method");
}

+ (void)classMethod {
    NSLog(@"this is an class method");
}

- (void)dealloc {
    NSLog(@"dealloc");
}


@end
