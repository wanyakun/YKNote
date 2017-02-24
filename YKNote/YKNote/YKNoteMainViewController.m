//
//  YKNoteMainViewController.m
//  YKNote
//
//  Created by wanyakun on 2016/11/15.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteMainViewController.h"
#import "YKNoteMainViewControllerProtocolImpl.h"

@interface YKNoteMainViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YKNoteMainViewControllerProtocolImpl *tableViewProtocolImpl;

@end

@implementation YKNoteMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"YKNote";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (self.view.subviews.count > 0) {
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView fill];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - delegate

#pragma mark - private method



#pragma mark - getter setter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self.tableViewProtocolImpl;
        _tableView.dataSource = self.tableViewProtocolImpl;
    }
    
    return _tableView;
}

- (YKNoteMainViewControllerProtocolImpl *)tableViewProtocolImpl {
    if (_tableViewProtocolImpl == nil) {
        _tableViewProtocolImpl = [[YKNoteMainViewControllerProtocolImpl alloc] init];
        _tableViewProtocolImpl.controller = self;
    }
    return _tableViewProtocolImpl;
}

@end
