//
//  YKNoteTimer.h
//  YKNote
//
//  Created by wanyakun on 2016/12/23.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKNoteTimer : NSObject

@property (readonly) NSTimeInterval timeInterval;

@property (readonly, getter=isValid) BOOL valid;

+ (YKNoteTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(void(^)())block
                                    repeats:(BOOL)repeats;

- (void)invalidate;


@end
