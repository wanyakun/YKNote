//
//  FindCommonSuperViews.m
//  YKNote
//
//  Created by wanyakun on 2020/5/6.
//  Copyright © 2020 wanyakun.github.io. All rights reserved.
//

#import "FindCommonSuperViews.h"

@implementation FindCommonSuperViews

+ (NSArray *)findCommonSuperViewsWithView1:(UIView *)view1 view2:(UIView *)view2 {
    NSArray *array1 = [FindCommonSuperViews findSuperViews:view1];
    NSArray *array2 = [FindCommonSuperViews findSuperViews:view2];
    NSMutableArray *result = [NSMutableArray array];
    NSInteger i = 0;
    while (i < MIN(array1.count, array2.count)) {
        UIView *supperView1 = [array1 objectAtIndex:(array1.count - i - 1)];
        UIView *supperView2 = [array2 objectAtIndex:(array2.count - i - 1)];
        if (supperView1 == supperView2) {
            [result addObject:supperView1];
            i++;
        } else {
            break;
        }
    }
    return result;
}

+ (NSArray<UIView *> *)findSuperViews:(UIView *)view {
    NSMutableArray *result = [NSMutableArray array];
    UIView *tmp = view.superview;
    while (tmp) {
        [result addObject:tmp];
        tmp = tmp.superview;
    }
    return [result copy];
}
@end
