//
//  YKNoteFoundationViewController.m
//  YKNote
//
//  Created by wanyakun on 2017/1/9.
//  Copyright © 2017年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteFoundationViewController.h"
#import "YKNotePersion.h"

@interface YKNoteFoundationViewController ()

@property (nonatomic, strong) YKNotePersion *persionA;
@property (nonatomic, strong) YKNotePersion *persionB;

@end

@implementation YKNoteFoundationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Foundation";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *viewA = [[[UIApplication sharedApplication] delegate] window];
    UIView *viewB = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 200)];
    UIView *viewC = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 500)];
    CGPoint toViewPoint = [viewA convertPoint:viewB.frame.origin toView:viewC];
    CGPoint fromViewPoint = [viewA convertPoint:viewB.frame.origin fromView:viewC];
    NSLog(@"%@", NSStringFromCGPoint(toViewPoint));
    NSLog(@"%@", NSStringFromCGPoint(fromViewPoint));
    
    for (NSInteger i = 0; i < 10000; i++) {
        @autoreleasepool {
            NSString *str = @"ABC";
            str = [str lowercaseString];
            str = [str stringByAppendingString:@"xyz"];
            
            NSLog(@"%@", str);
        }
    }
    
    YKNotePersion *per = [[YKNotePersion alloc] init];
    self.persionA = per;
    self.persionB = [per copy];
    
    NSInteger count = [per getRetainCount];
    NSLog(@"%ld", count);
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
