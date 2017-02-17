//
//  YKNoteConcurrentOperation.h
//  YKNote
//
//  Created by wanyakun on 2016/12/6.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKNoteConcurrentOperation : NSOperation {
    BOOL executing;
    BOOL finished;
}

- (void)completeOperaiton;

@end
