//
//  YKNoteRuntimeObject.m
//  YKNote
//
//  Created by wanyakun on 2016/12/21.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteRuntimeObject.h"
#import <objc/runtime.h>

@interface YKNoteRuntimeObject () {
    NSInteger _instance1;
    
    NSString *_instance2;
}

@property (nonatomic, strong) NSString *aString;

@property (nonatomic, assign) NSInteger integer;

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2;

@end

@implementation YKNoteRuntimeObject

- (instancetype)init {
    if (self = [super init]) {
        self.aString = nil;
    }
    return self;
}

- (void)method1 {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)method2 {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

+ (void)classMethod1 {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2 {
    NSLog(@"%s arg1:%ld, arg2:%@", __PRETTY_FUNCTION__, arg1, arg2);
}

//void dynamicMethodIMP(id self, SEL _cmd) {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
//
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:");
//    return YES;
////    return [super resolveInstanceMethod:sel];
//}
//
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    return [super forwardingTargetForSelector:aSelector];
//}
//
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    return [super methodSignatureForSelector:aSelector];
//}
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    return [super forwardInvocation:anInvocation];
//}

@end
