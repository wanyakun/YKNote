//
//  YKNoteBlockViewController.m
//  YKNote
//
//  Created by wanshanshan on 2016/12/26.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteBlockViewController.h"

@interface YKNoteBlockViewController ()

@end

@implementation YKNoteBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Block";
    self.view.backgroundColor = [UIColor whiteColor];
//    [self testBlock0];
    
//    [self testBlock1];
    
    [self testBlock2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - private method
- (void)testBlock0 {
    int val = 0;
    NSLog(@"定义前：%p", &val);
    void (^blk)(void)= ^{
        NSLog(@"val:%d", val);
        NSLog(@"Block内部：%p", &val);
    };
    NSLog(@"定以后：%p", &val);
    ++val;
    blk();
    NSLog(@"执行Block后：%p", &val);
}

- (void)testBlock1 {
    __block int val = 0;
    NSLog(@"定义前：%p", &val);
    void (^blk)(void)= ^{
        ++val;
        NSLog(@"blk内部：%p", &blk);
        NSLog(@"Block内部：%p", &val);
    };
    NSLog(@"定以后：%p", &val);
    NSLog(@"blk定以后：%p", &blk);
    ++val;
    blk();
    NSLog(@"执行Block后：%p", &val);
    NSLog(@"blk执行以后：%p", &blk);
}

- (void)testBlock2 {
    NSMutableString *a = [NSMutableString stringWithString:@"123"];
    NSLog(@"定义前a指向堆中地址：%p, a在栈中地址%p", a, &a);
    void (^blk)(void) = ^{
        NSLog(@"block内a修改前指向堆中地址：%p, a在栈中地址%p", a, &a);
        a.string = @"789";
        NSLog(@"block内a修改后指向堆中地址：%p, a在栈中地址%p", a, &a);

        NSMutableString *b = [NSMutableString stringWithString:@"456"];
        NSLog(@"block内b指向堆中地址：%p, b在栈中地址%p", b, &b);
    };
    NSLog(@"定义后a指向堆中地址：%p, a在栈中地址%p", a, &a);
    blk();
    NSLog(@"执行后a指向堆中地址：%p, a在栈中地址%p", a, &a);
}

@end
