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
    self.title = @"EventHandling";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.yKNoteEventHandingView setX:50];
    [self.yKNoteEventHandingView setY:100];
    [self.yKNoteEventHandingView setWidth:200];
    [self.yKNoteEventHandingView setHeight:200];
    
    [self.view addSubview:self.yKNoteEventHandingView];
    
    [self logNextResponder:self.yKNoteEventHandingView];
    
}

- (void)logNextResponder:(UIResponder *)responder {
    UIResponder *nextResponder = responder.nextResponder;
    NSLog(@"responder:%s %p and next responder:%s %p\n", object_getClassName(responder), responder, object_getClassName(nextResponder), nextResponder);
    if (nextResponder) {
        [self logNextResponder:nextResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - overrite
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


#pragma mark - getter
- (YKNoteEventHandingView *)yKNoteEventHandingView {
    if (_yKNoteEventHandingView == nil) {
        _yKNoteEventHandingView = [[YKNoteEventHandingView alloc] init];
        _yKNoteEventHandingView.backgroundColor = [UIColor redColor];
    }
    return _yKNoteEventHandingView;
}

@end
