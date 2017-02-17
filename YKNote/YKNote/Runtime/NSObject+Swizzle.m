//
//  NSObject+Swizzle.m
//  CrashDemo
//
//  Created by wanyakun on 16/7/5.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzle)

+ (BOOL)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector error:(NSError **)error {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    if (!originalMethod) {
        NSString *string = [NSString stringWithFormat:@"%@ 类没有找到 %@ 方法", NSStringFromClass([self class]), NSStringFromSelector(originalSelector)];
        *error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:-1 userInfo:[NSDictionary dictionaryWithObject:string forKey:NSLocalizedDescriptionKey]];
        return NO;
    }
    
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    if (!swizzledMethod) {
        NSString *string = [NSString stringWithFormat:@"%@ 类没有找到 %@ 方法", NSStringFromClass([self class]), NSStringFromSelector(swizzledSelector)];
        *error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:-1 userInfo:[NSDictionary dictionaryWithObject:string forKey:NSLocalizedDescriptionKey]];
        return NO;
    }
    
    BOOL didAddClass = class_addMethod([self class], originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddClass) {
        class_replaceMethod([self class], swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)originalSelector withClassMethod:(SEL)swizzledSelector error:(NSError *__autoreleasing *)error {
    Method originalMethod = class_getClassMethod(self, originalSelector);
    if (!originalMethod) {
        NSString *string = [NSString stringWithFormat:@"%@ 类没有找到 %@ 方法", NSStringFromClass([self class]), NSStringFromSelector(originalSelector)];
        *error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:-1 userInfo:[NSDictionary dictionaryWithObject:string forKey:NSLocalizedDescriptionKey]];
        return NO;
    }
    
    Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
    if (!swizzledMethod) {
        NSString *string = [NSString stringWithFormat:@"%@ 类没有找到 %@ 方法", NSStringFromClass([self class]), NSStringFromSelector(swizzledSelector)];
        *error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:-1 userInfo:[NSDictionary dictionaryWithObject:string forKey:NSLocalizedDescriptionKey]];
        return NO;
    }
    
    BOOL didAddClass = class_addMethod([self class], originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddClass) {
        class_replaceMethod([self class], swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    return YES;
}

@end
