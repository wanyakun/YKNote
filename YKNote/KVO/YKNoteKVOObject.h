//
//  YKNoteKVOObject.h
//  YKNote
//
//  Created by wanyakun on 2016/11/3.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKNoteKVOObject : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) CGFloat salary;

@property (nonatomic, strong) NSMutableArray *friends;

@property (nonatomic, strong) YKNoteKVOObject *subObject;

@end
