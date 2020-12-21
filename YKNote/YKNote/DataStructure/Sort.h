//
//  Sort.h
//  YKNote
//
//  Created by wanyakun on 2020/5/7.
//  Copyright © 2020 wanyakun.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Sort : NSObject

/**
直接插入排序
*/
+ (void)sortingForInsertWithArray:(NSMutableArray<NSNumber *> *)array;
+ (NSMutableArray *)sortingForInsertWithArray1:(NSMutableArray<NSNumber *> *)array;

/**
 冒泡排序
 */
+ (void)sortingForBubbleWithArray:(NSMutableArray<NSNumber *> *)array;
@end

NS_ASSUME_NONNULL_END
