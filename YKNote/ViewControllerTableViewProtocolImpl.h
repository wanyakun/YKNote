//
//  ViewControllerTableViewProtocolImpl.h
//  YKNote
//
//  Created by wanyakun on 2016/11/7.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewControllerTableViewProtocolImpl : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UIViewController *controller;

@end
