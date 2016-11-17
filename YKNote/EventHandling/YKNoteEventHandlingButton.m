//
//  YKNoteEventHandlingButton.m
//  YKNote
//
//  Created by wanyakun on 2016/11/16.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteEventHandlingButton.h"

@implementation YKNoteEventHandlingButton

- (instancetype)init {
    if (self = [super init]) {
        //
    }
    return self;
}

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

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    //获取touch
//    UITouch *touch = [touches anyObject];
//    //获取当前位置
//    CGPoint current = [touch locationInView:self];
//    //获取上一个位置
//    CGPoint pre = [touch previousLocationInView:self];
//    //获取x，y偏移量
//    CGFloat x = current.x - pre.x;
//    CGFloat y = current.y - pre.y;
//    //转换
//    self.transform = CGAffineTransformTranslate(self.transform, x, y);
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}

@end
