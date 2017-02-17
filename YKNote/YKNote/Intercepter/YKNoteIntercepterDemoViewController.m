//
//  YKNoteIntercepterDemoViewController.m
//  YKNoteDemo
//
//  Created by wanyakun on 2016/11/3.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteIntercepterDemoViewController.h"

@interface YKNoteIntercepterDemoViewController ()

@end

@implementation YKNoteIntercepterDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *array = @[@"1", @"2", @"3"];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    
    //添加操作
    NSString *addStr = nil;
    [mutableArray addObject:addStr];
    
    //插入操作
    [mutableArray insertObject:addStr atIndex:0];
    [mutableArray insertObject:@"4" atIndex:3];
    [mutableArray insertObject:addStr atIndex:4];
    
    //删除操作
    [mutableArray removeObjectAtIndex:3];
    [mutableArray removeObjectAtIndex:4];
    
    //替换操作
    [mutableArray replaceObjectAtIndex:0 withObject:addStr];
    [mutableArray replaceObjectAtIndex:0 withObject:@"zero"];
    [mutableArray replaceObjectAtIndex:3 withObject:@"4"];
    [mutableArray replaceObjectAtIndex:3 withObject:addStr];
    
    //读取操作
    for (NSInteger index = 0; index < 10; index++) {
        NSLog(@"%ld of array: %@", index, [array objectAtIndex:index]);
        NSLog(@"%ld of mutable array: %@", index, [mutableArray objectAtIndex:index]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
