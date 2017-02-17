//
//  YKNoteRuntimeObject+Swizzle.m
//  YKNote
//
//  Created by wanyakun on 2016/12/22.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteRuntimeObject+Swizzle.h"
#import <objc/runtime.h>

@implementation YKNoteRuntimeObject (Swizzle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];
        SEL sel1 = @selector(method1);
        SEL sel2 = @selector(xxx_method1);
        
        Method m1 = class_getInstanceMethod(cls, sel1);
        Method m2 = class_getInstanceMethod(cls, sel2);
        
        NSLog(@"method1 info before swizzle SEL name: %s, IMP address: %p", sel_getName(sel1), method_getImplementation(m1));
        NSLog(@"method2 info before swizzle SEL name: %s, IMP address: %p", sel_getName(sel2), method_getImplementation(m2));
        
        BOOL didAddMethod = class_addMethod(cls, sel1, method_getImplementation(m2), method_getTypeEncoding(m2));
        
        NSLog(@"method1 info after add SEL name: %s, IMP address: %p", sel_getName(sel1), method_getImplementation(m1));
        NSLog(@"method2 info after add SEL name: %s, IMP address: %p", sel_getName(sel2), method_getImplementation(m2));
        
        if (didAddMethod) {
            class_replaceMethod(cls, sel2, method_getImplementation(m1), method_getTypeEncoding(m1));
            
            NSLog(@"method1 info after replace SEL name: %s, IMP address: %p", sel_getName(sel1), method_getImplementation(m1));
            NSLog(@"method2 info after replace SEL name: %s, IMP address: %p", sel_getName(sel2), method_getImplementation(m2));
        } else {
            method_exchangeImplementations(m1, m2);
            
            NSLog(@"method1 info after exchange SEL name: %s, IMP address: %p", sel_getName(sel1), method_getImplementation(m1));
            NSLog(@"method2 info after exchange SEL name: %s, IMP address: %p", sel_getName(sel2), method_getImplementation(m2));
        }
        
    });
}


- (void)xxx_method1 {
    [self xxx_method1];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


@end
