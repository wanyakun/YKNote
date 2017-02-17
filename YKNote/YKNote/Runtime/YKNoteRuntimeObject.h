//
//  YKNoteRuntimeObject.h
//  YKNote
//
//  Created by wanyakun on 2016/12/21.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKNoteRuntimeObject : NSObject<NSCopying, NSCoding>

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, copy) NSString *string;

- (void)method1;

- (void)method2;

+ (void)classMethod1;

@end
