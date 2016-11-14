//
//  YKNoteEventHandingView.m
//  YKNote
//
//  Created by wanyakun on 2016/11/13.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteEventHandingView.h"

@implementation YKNoteEventHandingView

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    //获取touch
    UITouch *touch = [touches anyObject];
    //获取当前位置
    CGPoint current = [touch locationInView:self];
    //获取上一个位置
    CGPoint pre = [touch previousLocationInView:self];
    //获取x，y偏移量
    CGFloat x = current.x - pre.x;
    CGFloat y = current.y - pre.y;
    //转换
    self.transform = CGAffineTransformTranslate(self.transform, x, y);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


@end
