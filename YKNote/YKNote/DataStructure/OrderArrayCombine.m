//
//  OrderArrayCombine.m
//  YKNote
//
//  Created by wanyakun on 2020/5/6.
//  Copyright © 2020 wanyakun.github.io. All rights reserved.
//

#import "OrderArrayCombine.h"

@implementation OrderArrayCombine

+ (NSArray *)arrayCombineWithArray1:(NSArray *)array1 array2:(NSArray *)array2 {
    NSMutableArray *reslut = [NSMutableArray array];
    NSInteger i = 0;
    NSInteger j = 0;
    while (i < array1.count && j < array2.count) {
        if ([array1[i] integerValue] < [array2[j] integerValue]) {
            [reslut addObject:array1[i]];
            i++;
        } else {
            [reslut addObject:array2[j]];
            j++;
        }
    }
    // 数组1有剩余
    if (i < array1.count) {
        [reslut addObjectsFromArray:[array1 subarrayWithRange:NSMakeRange(i, array1.count - i)]];
    }
    // 数组2有剩余
    if (j < array2.count) {
        [reslut addObjectsFromArray:[array2 subarrayWithRange:NSMakeRange(j, array2.count - j)]];
    }
    return [reslut copy];
}

@end
