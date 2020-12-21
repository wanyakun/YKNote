//
//  Sort.m
//  YKNote
//
//  Created by wanyakun on 2020/5/7.
//  Copyright © 2020 wanyakun.github.io. All rights reserved.
//

#import "Sort.h"

@implementation Sort

#pragma mark - 插入排序

/**
 直接插入排序
 */
+ (void)sortingForInsertWithArray:(NSMutableArray<NSNumber *> *)array {
    for (NSInteger i = 1; i < array.count; i++) {
        if ([array[i-1] integerValue] > [array[i] integerValue]) {
            NSInteger j = i - 2;
            id temp = array[i];
            array[i] = array[i-1];
            while (j >= 0 && [temp integerValue] < [array[j] integerValue]) {
                array[j+1] = array[j];
                j--;
            }
            array[j+1] = temp;
        }
    }
}
// 使用中间变量， 但是并没有减少时间复杂度和空间复杂度，但是更容易理解一点
+ (NSMutableArray *)sortingForInsertWithArray1:(NSMutableArray<NSNumber *> *)array {
    NSMutableArray<NSNumber *> *result = [NSMutableArray arrayWithCapacity:array.count];
    for (NSInteger i = 0; i < array.count; i++) {
        [result addObject:array[i]];
        NSInteger j = result.count - 1;
        while (j > 0 && result[j].integerValue < result[j-1].integerValue) {
            NSNumber *tmp = result[j];
            result[j] = result[j-1];
            result[j-1] = tmp;
            j--;
        }
    }
    return result;
}
/**
 希尔排序
 */
+ (void)sortingForShellWithArray:(NSMutableArray<NSNumber *> *)array {

}
#pragma mark - 选择排序

/**
 简单选择排序
 */

/**
 堆排序
 */

#pragma mark - 交换排序

/**
 冒泡排序
 */
+ (void)sortingForBubbleWithArray:(NSMutableArray<NSNumber *> *)array {
    for (NSInteger i = 0; i < array.count - 1; i++) {
        for (NSInteger j = 0; j < array.count - i - 1; j++) {
            if (array[j].integerValue > array[j+1].integerValue) {
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
}

/**
 快速排序
 */
+ (void)sortingForQuickWithArray:(NSMutableArray<NSNumber *> *)array left:(NSInteger)left right:(NSInteger)right {
    if (left < right) {
        return;
    }
    NSInteger key = array[left].integerValue;
    NSInteger lp = left;
    NSInteger rp = right;
    while (lp < rp) {
        if (array[rp].integerValue < key) {
            NSNumber *tmp = array[rp];
            for (NSInteger i = rp - 1; i >= lp; i--) {
                array[i + 1] = array[i];
            }
            array[lp] = tmp;
            lp++;
            rp++;
        }
        rp--;
    }
    [Sort sortingForQuickWithArray:array left:left right:lp-1];
    [Sort sortingForQuickWithArray:array left:rp+1 right:right];
}

#pragma mark - 递归排序

#pragma mark - 基数排序

@end
