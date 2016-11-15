//
//  YKNoteWindow.m
//  YKNote
//
//  Created by wanyakun on 2016/11/14.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteWindow.h"

@implementation YKNoteWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    BOOL isInside = [super pointInside:point withEvent:event];
    NSLog(@"is in %@ : %d", [self class], isInside);
    return isInside;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super touchesEnded:touches withEvent:event];
}

@end
