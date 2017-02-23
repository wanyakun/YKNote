//
//  main.m
//  YKNote
//
//  Created by wanyakun on 2016/11/3.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        return UIApplicationMain(argc, argv, @"YKNoteApplication", NSStringFromClass([AppDelegate class]));
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        //这里一直获取不到result的值，证明UIApplicationMain一直没有返回，保持程序持续运行，内部启动了一个RunLoop
        int result = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        return result;
    }
}
