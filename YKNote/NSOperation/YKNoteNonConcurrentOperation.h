//
//  YKNoteNonConcurrentOperation.h
//  YKNote
//
//  Created by wanyakun on 2016/12/6.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKNoteNonConcurrentOperation : NSOperation

@property (nonatomic, strong) id data;

- (instancetype) initWithData:(id)data;

@end
