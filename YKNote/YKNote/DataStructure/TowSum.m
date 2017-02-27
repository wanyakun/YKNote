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
    NSMapTable *mapTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
    NSMutableArray *resut = [NSMutableArray arrayWithCapacity:2];
    for (NSInteger i = 0; i < nums.count; i++) {
        NSInteger numberToFind = target - [nums[i] integerValue];
        NSEnumerator *enumerator = mapTable.objectEnumerator;
        NSNumber *next = nil;
        while (next = [enumerator nextObject]) {
            if ([next integerValue] == numberToFind) {
                [resut addObject:nums[i]];
                [resut addObject:next];
                
                return [resut copy];
            }
        }
        [mapTable setObject:nums[i] forKey:[NSNumber numberWithInteger:i]];
    }
    
    return [resut copy];
}

@end
