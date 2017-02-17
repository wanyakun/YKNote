//
//  YKNoteTapGestureRecognizer.m
//  YKNote
//
//  Created by wanyakun on 2016/11/18.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteTapGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation YKNoteTapGestureRecognizer

- (void)reset {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super reset];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super touchesCancelled:touches withEvent:event];
}

@end
