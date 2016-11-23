//
//  YKNoteEventHandlingButton.m
//  YKNote
//
//  Created by wanyakun on 2016/11/16.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteEventHandlingButton.h"

//@interface YKNoteEventHandlingButton ()<UIGestureRecognizerDelegate>
//
//@end

@implementation YKNoteEventHandlingButton

- (instancetype)init {
    if (self = [super init]) {
//        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
//        recognizer.delegate = self;
//        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
//    if (self.backgroundColor == [UIColor yellowColor]) {
//        return nil;
//    }
    
    if (self.userInteractionEnabled == NO || self.hidden || self.alpha <= 0.01) {
        return nil;
    }
    
    CGRect responseRect = CGRectInset(self.bounds, -20, -20);
    if (CGRectContainsPoint(responseRect, point)) {
        return [super hitTest:point withEvent:event];
    }
    return nil;
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
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super touchesCancelled:touches withEvent:event];
}

//#pragma mark - UIGestureRecognizerDelegate
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    NSLog(@"%s and View:%s", __PRETTY_FUNCTION__, object_getClassName(gestureRecognizer.view));
//    return YES;
//}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    NSLog(@"%s and View:%s", __PRETTY_FUNCTION__, object_getClassName(gestureRecognizer.view));
//    return NO;
//}


#pragma mark - private method
- (void)handleGestureRecognizer:(UIGestureRecognizer *)recognizer {
    NSLog(@"%s and View:%s", __PRETTY_FUNCTION__, object_getClassName(recognizer.view));
}
//
//- (void)ykNoteEventHandlingGreenButtonDidTouchUpInside:(UIButton *)button {
//    NSLog(@"%s \n %@", __PRETTY_FUNCTION__, button);
//}

@end
