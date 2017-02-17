//
//  YKNoteKVOObject.m
//  YKNote
//
//  Created by wanyakun on 2016/11/3.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteKVOObject.h"

@implementation YKNoteKVOObject

- (instancetype)init {
    if (self = [super init]) {
        //
    }
    
    return self;
}


/*
 手动实现KVO发射通知，需要重载automaticallyNotifiesObserversForKey:,或者实现automaticallyNotifiesObserversOf<key>, 对于不需要自动发射KVO通知的属性需要返回NO，然后在setter方法中添加willChangeValueForKey:和didChangeValueForKey:方法的调用代码
 */
+ (BOOL)automaticallyNotifiesObserversOfSalary {
    return NO;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@"salary"]) {
        return NO;
    } else {
        return [super automaticallyNotifiesObserversForKey:key];
    }
}

- (void)setSalary:(CGFloat)salary {
    [self willChangeValueForKey:@"salary"];
    _salary = salary;
    [self didChangeValueForKey:@"salary"];
}

@end
