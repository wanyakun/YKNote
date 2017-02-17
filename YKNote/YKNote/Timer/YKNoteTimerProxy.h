//
//  YKNoteTimerProxy.h
//  YKNote
//
//  Created by wanyakun on 2017/2/17.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKNoteTimerProxy : NSProxy

@property (nonatomic, weak) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)timerProxyWithTarget:(id)target;

@end
