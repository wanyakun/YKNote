//
//  YKNoteDrawView.m
//  YKNote
//
//  Created by wanyakun on 2017/1/9.
//  Copyright © 2017年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteDrawView.h"

@implementation YKNoteDrawView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect inFrame = CGRectMake(0, 0, 100, 100);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextAddEllipseInRect(ctx, inFrame);
    CGContextMoveToPoint(ctx, CGRectGetMidX(inFrame), CGRectGetMinY(inFrame));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(inFrame), CGRectGetMidY(inFrame));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(inFrame), CGRectGetMidY(inFrame));
    CGContextAddLineToPoint(ctx, CGRectGetMidX(inFrame), CGRectGetMinY(inFrame));
    CGContextStrokePath(ctx);
}




@end
