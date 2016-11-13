//
//  YKNoteEventHandingViewController.m
//  YKNote
//
//  Created by wanyakun on 2016/11/13.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteEventHandingViewController.h"
#import "YKNoteEventHandingView.h"

@interface YKNoteEventHandingViewController ()

@property (nonatomic, strong) YKNoteEventHandingView *yKNoteEventHandingView;

@end

@implementation YKNoteEventHandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.yKNoteEventHandingView setX:50];
    [self.yKNoteEventHandingView setY:100];
    [self.yKNoteEventHandingView setWidth:150];
    [self.yKNoteEventHandingView setHeight:150];
    
    [self.view addSubview:self.yKNoteEventHandingView];
    
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

#pragma mark - getter
- (YKNoteEventHandingView *)yKNoteEventHandingView {
    if (_yKNoteEventHandingView == nil) {
        _yKNoteEventHandingView = [[YKNoteEventHandingView alloc] init];
        _yKNoteEventHandingView.backgroundColor = [UIColor redColor];
    }
    return _yKNoteEventHandingView;
}

@end
