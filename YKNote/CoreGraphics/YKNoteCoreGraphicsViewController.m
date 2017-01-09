//
//  YKNoteCoreGraphicsViewController.m
//  YKNote
//
//  Created by wanyakun on 2017/1/9.
//  Copyright © 2017年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteCoreGraphicsViewController.h"
#import "YKNoteDrawView.h"

@interface YKNoteCoreGraphicsViewController ()

@property (nonatomic, strong) YKNoteDrawView *drawView;

@end

@implementation YKNoteCoreGraphicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CoreGraphics";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.drawView];
    
    UIView *viewA = [[[UIApplication sharedApplication] delegate] window];
    UIView *viewB = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 200)];
    UIView *viewC = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 500)];
    CGPoint toViewPoint = [viewA convertPoint:viewB.frame.origin toView:viewC];
    CGPoint fromViewPoint = [viewA convertPoint:viewB.frame.origin fromView:viewC];
    NSLog(@"%@", NSStringFromCGPoint(toViewPoint));
    NSLog(@"%@", NSStringFromCGPoint(fromViewPoint));
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.drawView fill];
//    self.navigationController.navigationBar.hidden = YES;
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

- (YKNoteDrawView *)drawView {
    if (!_drawView) {
        _drawView = [[YKNoteDrawView alloc] init];
        _drawView.backgroundColor = [UIColor whiteColor];
    }
    return _drawView;
}


@end
