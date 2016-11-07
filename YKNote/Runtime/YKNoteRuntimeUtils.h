//
//  YKNoteRuntimeUtils.h
//  YKNote
//
//  Created by wanyakun on 2016/11/7.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKNoteRuntimeUtils : NSObject

+ (NSMutableArray *)methodOfClass:(Class)cls;

+ (NSString *)descriptionDetailWithName:(NSString *)name objc:(id)objc;

@end
