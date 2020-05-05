//
//  TowSum.m
//  YKNote
//
//  Created by wanyakun on 2017/2/27.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import "TowSum.h"

@implementation TowSum

+ (NSArray *)towSum:(NSArray<NSNumber *> *)nums ofTarget:(NSInteger)target {
    //number is key, and the value is it index in the map table;
    NSMapTable *mapTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
    NSMutableArray *resut = [NSMutableArray arrayWithCapacity:2];
    for (NSInteger i = 0; i < nums.count; i++) {
        NSInteger numberToFind = target - [nums[i] integerValue];
        NSNumber *number = [mapTable objectForKey:[NSNumber numberWithInteger:numberToFind]];
        if (number) {
            [resut addObject:number];
            [resut addObject:[NSNumber numberWithInteger:i]];

            return [resut copy];
        }
        [mapTable setObject:[NSNumber numberWithInteger:i] forKey:nums[i]];
    }
    
    return [resut copy];
}

@end
