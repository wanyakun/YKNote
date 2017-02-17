//
//  YKNoteMainViewControllerProtocolImpl.h
//  YKNote
//
//  Created by wanyakun on 2016/11/15.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKNoteMainViewControllerProtocolImpl : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UIViewController *controller;

@end
