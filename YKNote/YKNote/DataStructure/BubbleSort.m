//
//  BubbleSort.m
//  YKNote
//
//  Created by wanyakun on 2017/2/19.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import "BubbleSort.h"

@implementation BubbleSort

+ (void)bubbleSortWithArray:(NSMutableArray *)array {
    NSAssert([array isKindOfClass:[NSMutableArray class]], @"array is not NSMutableArray instance");
    for (NSInteger i = 1; i < array.count; i++) {
        for (NSInteger j = array.count - 1; j >= i; j--) {
            if ([[array objectAtIndex:j] integerValue] < [[array objectAtIndex:j-1] integerValue]) {
                [array exchangeObjectAtIndex:j-1 withObjectAtIndex:j];
            }
        }
    }
}

+ (NSArray *)bubbleSort:(NSArray *)array {
    NSMutableArray *mArray = [NSMutableArray arrayWithArray:array];
    [BubbleSort bubbleSortWithArray:mArray];
    return [mArray copy];
}

@end
