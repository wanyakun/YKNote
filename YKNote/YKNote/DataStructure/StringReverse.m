//
//  StringReverse.m
//  YKNote
//
//  Created by wanyakun on 2020/5/5.
//  Copyright © 2020 wanyakun.github.io. All rights reserved.
//

#import "StringReverse.h"

@implementation StringReverse

+ (NSString *)reverseWithString:(NSString *)originString {
    NSLog(@"orgin string: %@", originString);
    NSMutableString *reverseString = [NSMutableString stringWithString:originString];
    NSInteger length = originString.length/2;
    for (NSInteger i = 0; i < length; i++) {
        NSRange left = NSMakeRange(i, 1);
        NSRange right = NSMakeRange(originString.length - i - 1, 1);
        [reverseString replaceCharactersInRange:left withString:[originString substringWithRange:right]];
        [reverseString replaceCharactersInRange:right withString:[originString substringWithRange:left]];
    }
    NSLog(@"reverse string: %@", reverseString);
    return reverseString;
}

+ (NSString *)reverseWithString1:(NSString *)originString {
    NSLog(@"orgin string: %@", originString);
    NSInteger length = originString.length;
    char ch[100];
    memcpy(ch, [originString cStringUsingEncoding:NSUTF8StringEncoding], length);
    NSInteger left = 0;
    NSInteger right = length - 1;
    while (left < right) {
        char temp = ch[left];
        ch[left] = ch[right];
        ch[right] = temp;
        left++;
        right--;
    }
    
    NSString *reverseString = [NSString stringWithCString:ch encoding:NSUTF8StringEncoding];
    NSLog(@"reverse string: %@", reverseString);
    return reverseString;
}

@end
