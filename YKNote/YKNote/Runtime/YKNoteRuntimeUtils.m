//
//  YKNoteRuntimeUtils.m
//  YKNote
//
//  Created by wanyakun on 2016/11/7.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteRuntimeUtils.h"
#import <objc/runtime.h>

@implementation YKNoteRuntimeUtils

+ (NSMutableArray *)methodOfClass:(Class)cls {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    for (NSInteger i = 0; i < count; i++) {
        SEL sel = method_getName(*(methodList+i));
        NSString *name = NSStringFromSelector(sel);
        [array addObject:name];
    }
    
    return array;
}

+ (NSString *)descriptionDetailWithName:(NSString *)name objc:(id)objc {
    NSString *descrition = [NSString stringWithFormat:@"%@:%@\n\tclass %@\n\tobjcClass %@\n\timplementmethod \n\t\t%@\n",
                            name,
                            objc,
                            [objc class],
                            object_getClass(objc),
                            [[YKNoteRuntimeUtils methodOfClass:object_getClass(objc)] componentsJoinedByString:@",\n\t\t"]];
#ifdef DEBUG
    NSLog(@"%@", descrition);
#endif
    return descrition;
}


@end
