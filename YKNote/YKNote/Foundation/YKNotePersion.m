//
//  YKNotePersion.m
//  YKNote
//
//  Created by wanyakun on 2017/1/9.
//  Copyright © 2017年 com.ucaiyuan. All rights reserved.
//

#import "YKNotePersion.h"
//#import <objc/objc-runtime.h>
#import <objc/runtime.h>
#import <objc/message.h>

@implementation YKNotePersion

- (NSInteger)getRetainCount {
    SEL sel = NSSelectorFromString(@"retainCount");
    int (*count)(id, SEL) = (int (*)(id, SEL))objc_msgSend;
    return count(self, sel);
}

- (id)copyWithZone:(NSZone *)zone {
    return [[YKNotePersion alloc] init];
}

@end
