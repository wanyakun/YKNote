//
//  YKNoteUIViewController.m
//  YKNote
//
//  Created by wanyakun on 2017/2/25.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import "YKNoteUIViewController.h"
#import "YKNoteUITableViewCell.h"

@interface YKNoteUIViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YKNoteUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UI";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 100, 100)];
    container.backgroundColor = [UIColor greenColor];
    [self.view addSubview:container];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    label.backgroundColor = [UIColor redColor];
//    label.layer.shadowColor = [UIColor blueColor].CGColor;
////    label.layer.shadowOffset = CGSizeMake(4, 4);  // 直接设置shadowOffset有离屏渲染
//    label.layer.shadowOpacity = 0.8f;
//    
//    //路径阴影
//    NSInteger paintingWidth = 100;
//    NSInteger paintingHeight = 100;
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(-5, -5)];
//    //添加直线
//    [path addLineToPoint:CGPointMake(paintingWidth /2, -15)];
//    [path addLineToPoint:CGPointMake(paintingWidth +5, -5)];
//    [path addLineToPoint:CGPointMake(paintingWidth +15, paintingHeight /2)];
//    [path addLineToPoint:CGPointMake(paintingWidth +5, paintingHeight +5)];
//    [path addLineToPoint:CGPointMake(paintingWidth /2, paintingHeight +15)];
//    [path addLineToPoint:CGPointMake(-5, paintingHeight +5)];
//    [path addLineToPoint:CGPointMake(-15, paintingHeight /2)];
//    [path addLineToPoint:CGPointMake(-5, -5)];
//    
//    label.layer.shadowPath =path.CGPath;    // 通过shadowPath设置没有离屏渲染


    [container addSubview:label];
    container.layer.cornerRadius = 9;
    container.layer.masksToBounds = YES;
//
    
//    [self.view addSubview:self.tableView];
//    [self.tableView fill];

//    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
//    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
//    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
//    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
//    
//    [self.tableView addConstraints:@[top, left, right, bottom]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 320;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YKNoteUITableViewCell"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    cell.textLabel.text = [NSString stringWithFormat:@"这是第%ld行", indexPath.row];
//    NSLog(@"%s----------------%ld", __PRETTY_FUNCTION__, indexPath.row);
    YKNoteUITableViewCell *uiCell = (YKNoteUITableViewCell *)cell;
    [uiCell setTextContext:[NSString stringWithFormat:@"这是第%ld行", indexPath.row]];
    [uiCell setImageContext:[UIImage imageNamed:@"rotation"]];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView registerClass:[YKNoteUITableViewCell class] forCellReuseIdentifier:@"YKNoteUITableViewCell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}


@end
