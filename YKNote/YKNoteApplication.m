//
//  YKNoteApplication.m
//  YKNote
//
//  Created by wanyakun on 2016/11/14.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteApplication.h"

@implementation YKNoteApplication

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super touchesEnded:touches withEvent:event];
}

@end
