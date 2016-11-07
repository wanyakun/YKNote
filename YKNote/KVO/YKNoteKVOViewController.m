//
//  YKNoteKVOViewController.m
//  YKNote
//
//  Created by wanyakun on 2016/11/7.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteKVOViewController.h"
#import "YKNoteKVOObject.h"
#import "YKNoteRuntimeUtils.h"


@interface YKNoteKVOViewController ()

@property (nonatomic, strong) YKNoteKVOObject *yKNoteKVOObject;
@property (nonatomic, strong) YKNoteKVOObject *yKNoteKVOObject2;
@property (nonatomic, strong) YKNoteKVOObject *yKNoteKVOObject3;
@property (nonatomic, strong) YKNoteKVOObject *yKNoteKVOObject4;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation YKNoteKVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.textView];
    [self.textView fill];
    
    [self.yKNoteKVOObject addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.yKNoteKVOObject2 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.yKNoteKVOObject3 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.yKNoteKVOObject3 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    NSString *detail =  [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject" objc:self.yKNoteKVOObject];
    NSString *detail2 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject2" objc:self.yKNoteKVOObject2];
    NSString *detail3 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject3" objc:self.yKNoteKVOObject3];
    NSString *detail4 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject4" objc:self.yKNoteKVOObject4];
    
    self.textView.text = [NSString stringWithFormat:@"%@%@%@%@", detail, detail2, detail3, detail4];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
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
- (YKNoteKVOObject *)yKNoteKVOObject {
    if (_yKNoteKVOObject == nil) {
        _yKNoteKVOObject = [[YKNoteKVOObject alloc] init];
    }
    return _yKNoteKVOObject;
}

- (YKNoteKVOObject *)yKNoteKVOObject2 {
    if (_yKNoteKVOObject2 == nil) {
        _yKNoteKVOObject2 = [[YKNoteKVOObject alloc] init];
    }
    return _yKNoteKVOObject2;
}

- (YKNoteKVOObject *)yKNoteKVOObject3 {
    if (_yKNoteKVOObject3 == nil) {
        _yKNoteKVOObject3 = [[YKNoteKVOObject alloc] init];
    }
    return _yKNoteKVOObject3;
}

- (YKNoteKVOObject *)yKNoteKVOObject4 {
    if (_yKNoteKVOObject4 == nil) {
        _yKNoteKVOObject4 = [[YKNoteKVOObject alloc] init];
    }
    return _yKNoteKVOObject4;
}

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.contentOffset = CGPointMake(0, 20);
    }
    return _textView;
}

@end
