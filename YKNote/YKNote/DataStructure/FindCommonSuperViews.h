//
//  FindCommonSuperViews.h
//  YKNote
//
//  Created by wanyakun on 2020/5/6.
//  Copyright © 2020 wanyakun.github.io. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FindCommonSuperViews : NSObject

+ (NSArray *)findCommonSuperViewsWithView1:(UIView *)view1 view2:(UIView *)view2;

@end

NS_ASSUME_NONNULL_END
