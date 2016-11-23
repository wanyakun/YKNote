//
//  YKNoteEventHandingViewController.m
//  YKNote
//
//  Created by wanyakun on 2016/11/13.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteEventHandingViewController.h"
#import "YKNoteEventHandingView.h"
#import "YKNoteEventHandlingButton.h"
#import "YKNoteTapGestureRecognizer.h"

@interface YKNoteEventHandingViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) YKNoteEventHandingView *yKNoteEventHandingView;
@property (nonatomic, strong) YKNoteEventHandlingButton *ykNoteEventHandlingButton;

@property (nonatomic, strong) YKNoteEventHandlingButton *ykNoteBlueButton;
@property (nonatomic, strong) YKNoteEventHandlingButton *ykNoteYellowButton;

@end

@implementation YKNoteEventHandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"EventHandling";
    self.view.backgroundColor = [UIColor whiteColor];
    //View
    [self.yKNoteEventHandingView setFrame:CGRectMake(50, 100, 200, 200)];
    [self.view addSubview:self.yKNoteEventHandingView];
    [self logNextResponder:self.yKNoteEventHandingView];

    //Button
    [self.ykNoteEventHandlingButton setFrame:CGRectMake(60, 60, 100, 100)];
    [self.yKNoteEventHandingView addSubview:self.ykNoteEventHandlingButton];
    
    [self.ykNoteBlueButton setFrame:CGRectMake(100, 370, 200, 200)];
    [self.view addSubview:self.ykNoteBlueButton];
    
    [self.ykNoteYellowButton setFrame:CGRectMake(50, 50, 100, 100)];
    [self.ykNoteBlueButton addSubview:self.ykNoteYellowButton];
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

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"%s and View:%s", __PRETTY_FUNCTION__, object_getClassName(gestureRecognizer.view));
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%s and View:%s", __PRETTY_FUNCTION__, object_getClassName(gestureRecognizer.view));
//    if (gestureRecognizer.view == self.ykNoteEventHandlingButton) {
//        return NO;
//    }
    return YES;
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

#pragma mark - event
- (void)ykNoteEventHandlingButtonDidTouchUpInside:(UIButton *)button {
    NSLog(@"%s \n %@", __PRETTY_FUNCTION__, button);
}

- (void)handleGestureRecognizer:(UIGestureRecognizer *)recognizer {
    NSLog(@"%s and View:%s", __PRETTY_FUNCTION__, object_getClassName(recognizer.view));
}

- (void)ykNoteEventHandlingGreenButtonDidTouchUpInside:(UIButton *)button {
    NSLog(@"%s \n %@", __PRETTY_FUNCTION__, button);
}

#pragma mark - getter
- (YKNoteEventHandingView *)yKNoteEventHandingView {
    if (_yKNoteEventHandingView == nil) {
        _yKNoteEventHandingView = [[YKNoteEventHandingView alloc] init];
        _yKNoteEventHandingView.backgroundColor = [UIColor redColor];
        
        
        YKNoteTapGestureRecognizer *recognzier = [[YKNoteTapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        recognzier.delegate = self;
        recognzier.numberOfTapsRequired = 2;
        recognzier.delaysTouchesEnded = YES;
        [_yKNoteEventHandingView addGestureRecognizer:recognzier];
    }
    return _yKNoteEventHandingView;
}

- (YKNoteEventHandlingButton *)ykNoteEventHandlingButton {
    if (_ykNoteEventHandlingButton == nil) {
        _ykNoteEventHandlingButton = [[YKNoteEventHandlingButton alloc] init];
        _ykNoteEventHandlingButton.backgroundColor = [UIColor greenColor];
        [_ykNoteEventHandlingButton addTarget:nil action:@selector(ykNoteEventHandlingGreenButtonDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ykNoteEventHandlingButton;
}

- (YKNoteEventHandlingButton *)ykNoteBlueButton {
    if (_ykNoteBlueButton == nil) {
        _ykNoteBlueButton = [[YKNoteEventHandlingButton alloc] init];
        _ykNoteBlueButton.backgroundColor = [UIColor blueColor];
        [_ykNoteBlueButton addTarget:self action:@selector(ykNoteEventHandlingButtonDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ykNoteBlueButton;
}

- (YKNoteEventHandlingButton *)ykNoteYellowButton {
    if (_ykNoteYellowButton == nil) {
        _ykNoteYellowButton = [[YKNoteEventHandlingButton alloc] init];
        _ykNoteYellowButton.backgroundColor = [UIColor yellowColor];
        [_ykNoteYellowButton addTarget:self action:@selector(ykNoteEventHandlingButtonDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ykNoteYellowButton;
}

@end
