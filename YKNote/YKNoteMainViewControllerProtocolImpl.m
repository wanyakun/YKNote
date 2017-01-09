//
//  YKNoteMainViewControllerProtocolImpl.m
//  YKNote
//
//  Created by wanyakun on 2016/11/15.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteMainViewControllerProtocolImpl.h"
#import <objc/runtime.h>

@interface YKNoteMainViewControllerProtocolImpl ()

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *controllerArray;

@end

@implementation YKNoteMainViewControllerProtocolImpl

- (instancetype)init {
    if (self = [super init]) {
        _dataArray = @[@"Foundation",
                       @"Block",
                       @"GCD",
                       @"NSOperation",
                       @"KVC",
                       @"KVO",
                       @"EventHandling",
                       @"GestureRecognizer",
                       @"Runtime",
                       @"Runloop",
                       @"CoreData",
                       @"DataStructure",
                       @"CoreGraphics"];
        _controllerArray = @[@"YKNoteFoundationViewController",
                             @"YKNoteBlockViewController",
                             @"YKNoteGCDViewController",
                             @"YKNoteOperationViewController",
                             @"YKNoteKVCViewController",
                             @"YKNoteKVOViewController",
                             @"YKNoteEventHandingViewController",
                             @"YKNoteGestureRecognizerViewController",
                             @"YKNoteRuntimeViewController",
                             @"YKNoteRunloopViewController",
                             @"YKNoteCoreDataViewController",
                             @"YKNoteDataStructureViewController",
                             @"YKNoteCoreGraphicsViewController"];
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = [self.controllerArray objectAtIndex:indexPath.row];
    const char *clsName = [className cStringUsingEncoding:NSASCIIStringEncoding];
    Class cls = objc_getClass(clsName);
    if (cls) {
        UIViewController *controller = [[cls alloc] init];
        [self.controller.navigationController pushViewController:controller animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

@end
