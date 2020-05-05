//
//  IPV4ToInteger.m
//  YKNote
//
//  Created by wanyakun on 2017/2/28.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import "IPV4ToInteger.h"

@implementation IPV4ToInteger

+ (NSInteger)ipv4ToInteger:(NSString *)ipv4 {
    NSAssert(ipv4 != nil, @"ipv4 is nil");
    NSAssert(![ipv4 isKindOfClass:[NSNull class]], @"ipv4 is null");
    NSAssert(ipv4.length != 0, @"ipv4's length is 0");
    
    NSArray *ipArray = [ipv4 componentsSeparatedByString:@"."];
    NSAssert(ipArray.count == 4, @"ipArray's count is not 4");
    
    NSMutableArray *mIpArray = [NSMutableArray arrayWithCapacity:4];
    [ipArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *toAdd = nil;
        NSInteger location = [obj rangeOfString:@" "].location;
        if (location != NSNotFound) {
            NSAssert(!(location > 0 && ![obj hasSuffix:@" "]), @"format error at index:%ld of %@", idx, obj);
            toAdd = [obj stringByReplacingOccurrencesOfString:@" " withString:@""];
        } else {
            toAdd = obj;
        }
        
        NSScanner *scanner = [NSScanner scannerWithString:toAdd];
        NSInteger val;
        NSAssert(([scanner scanInteger:&val] && [scanner isAtEnd]), @"format error at index:%ld of %@ not integer", idx, obj);
        
        [mIpArray addObject:toAdd];
    }];
    
    NSString *realIpv4 = [mIpArray componentsJoinedByString:@"."];
    NSString *regex = @"(?<=(\\b|\\D))(((\\d{1,2})|(1\\d{2})|(2[0-4]\\d)|(25[0-5]))\\.){3}((\\d{1,2})|(1\\d{2})|(2[0-4]\\d)|(25[0-5]))(?=(\\b|\\D))";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSAssert([pred evaluateWithObject:realIpv4], @"It is not a real IPV4: %@", realIpv4);
    
    return [IPV4ToInteger ipToIntegerCore:mIpArray];
}

+ (NSInteger)ipToIntegerCore:(NSArray *)ipArray {
    __block NSInteger result = 0;
    [ipArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        result += [obj integerValue]*pow(256, ipArray.count - 1 - idx);
    }];
    return result;
}


@end
