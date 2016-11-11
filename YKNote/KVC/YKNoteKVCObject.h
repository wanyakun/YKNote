//
//  YKNoteKVCObject.h
//  YKNote
//
//  Created by wanyakun on 2016/11/10.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKNoteKVCObject : NSObject {
    NSInteger _intVar;
    NSString *_strVar;
}

@property (nonatomic, assign) NSInteger intProperty;
@property (nonatomic, copy) NSString *strProperty;

@end
