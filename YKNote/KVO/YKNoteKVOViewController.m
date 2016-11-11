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
#import <objc/runtime.h>

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
    self.title = @"KVO";

    [self.view addSubview:self.textView];
    [self.textView fill];
    
    self.yKNoteKVOObject.name = @"YKNoteKVOObject";
    self.yKNoteKVOObject2.name = @"YKNoteKVOObject2";
    self.yKNoteKVOObject3.name = @"YKNoteKVOObject3";
    self.yKNoteKVOObject4.name = @"YKNoteKVOObject4";
    
    self.yKNoteKVOObject.friends = [[NSMutableArray alloc] initWithCapacity:5];
    
    self.textView.text = @"========before add observer objective detail========\n";
    [self addBeforDetailToTextView];
    
    [self addObserver];
    
    self.textView.text = [self.textView.text stringByAppendingString:@"========after add observer objective detail========\n"];
    [self addAfterDetailToTextView];
    
    
    self.textView.text = [self.textView.text stringByAppendingString:@"============cls supeCls============\n"];
    [self addClsSuperClsToTextView];
    
    self.textView.text = [self.textView.text stringByAppendingString:@"============Object IMP============\n"];
    [self addObjectIMPToTextView];
    
    self.textView.text = [self.textView.text stringByAppendingString:@"============Runtime IMP============\n"];
    [self addRuntimeMethodIMPToTextView];
    
    self.textView.text = [self.textView.text stringByAppendingString:@"============Observer change============\n"];
    //自动触发KVO通知
    self.yKNoteKVOObject.name = @"YKNoteKVOObject Change property";
    [self.yKNoteKVOObject setValue:@"YKNoteKVOObject setValue:forKey:" forKey:@"name"];
    [self.yKNoteKVOObject setValue:@"YKNoteKVOObject setValue:forKeyPath:" forKeyPath:@"name"];
    
    NSMutableArray *array = [self.yKNoteKVOObject mutableArrayValueForKey:@"friends"];
    [array addObject:@"wanyakun"];
    //手动触发KVO通知
    self.yKNoteKVOObject.salary = 1000;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self removeObserver];
    self.yKNoteKVOObject = nil;
    self.yKNoteKVOObject2 = nil;
    self.yKNoteKVOObject3 = nil;
    self.yKNoteKVOObject4 = nil;
    self.textView = nil;
}

#pragma mark - private method

- (void)addObserver {
    [self.yKNoteKVOObject addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.yKNoteKVOObject2 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.yKNoteKVOObject3 addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.yKNoteKVOObject3 addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [self.yKNoteKVOObject addObserver:self forKeyPath:@"salary" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self.yKNoteKVOObject addObserver:self forKeyPath:@"friends" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObserver {
    [self.yKNoteKVOObject removeObserver:self forKeyPath:@"name"];
    [self.yKNoteKVOObject2 removeObserver:self forKeyPath:@"age"];
    [self.yKNoteKVOObject3 removeObserver:self forKeyPath:@"name"];
    [self.yKNoteKVOObject3 removeObserver:self forKeyPath:@"age"];
    
    [self.yKNoteKVOObject removeObserver:self forKeyPath:@"salary"];
    [self.yKNoteKVOObject removeObserver:self forKeyPath:@"friends"];
}

- (void)addBeforDetailToTextView {
    NSString *beforeDetail =  [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject" objc:self.yKNoteKVOObject];
    NSString *beforeDetail2 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject2" objc:self.yKNoteKVOObject2];
    NSString *beforeDetail3 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject3" objc:self.yKNoteKVOObject3];
    NSString *beforeDetail4 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject4" objc:self.yKNoteKVOObject4];
    
    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@", beforeDetail, beforeDetail2, beforeDetail3, beforeDetail4]];
}

- (void)addAfterDetailToTextView {
    NSString *afterDetail =  [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject" objc:self.yKNoteKVOObject];
    NSString *afterDetail2 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject2" objc:self.yKNoteKVOObject2];
    NSString *afterDetail3 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject3" objc:self.yKNoteKVOObject3];
    NSString *afterDetail4 = [YKNoteRuntimeUtils descriptionDetailWithName:@"yKNoteKVOObject4" objc:self.yKNoteKVOObject4];
    
    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@", afterDetail, afterDetail2, afterDetail3, afterDetail4]];
}

- (void)addClsSuperClsToTextView {
    Class cls = object_getClass(self.yKNoteKVOObject);
    Class superCls = class_getSuperclass(cls);
    
    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"yKNoteKVOObject isa:%@\nyKNoteKVOObject isa's super class:%@\n", cls, superCls]];
}

- (void)addObjectIMPToTextView {
    NSString *objcIMP = [NSString stringWithFormat:@"objcIMP yKNoteKVOObject setName:%p, setAge:%p\n", [self.yKNoteKVOObject methodForSelector:@selector(setName:)], [self.yKNoteKVOObject methodForSelector:@selector(setAge:)]];
    NSString *objcIMP2 = [NSString stringWithFormat:@"objcIMP yKNoteKVOObject2 setName:%p, setAge:%p\n", [self.yKNoteKVOObject2 methodForSelector:@selector(setName:)], [self.yKNoteKVOObject2 methodForSelector:@selector(setAge:)]];
    NSString *objcIMP3 = [NSString stringWithFormat:@"objcIMP yKNoteKVOObject3 setName:%p, setAge:%p\n", [self.yKNoteKVOObject3 methodForSelector:@selector(setName:)], [self.yKNoteKVOObject3 methodForSelector:@selector(setAge:)]];
    NSString *objcIMP4 = [NSString stringWithFormat:@"objcIMP yKNoteKVOObject4 setName:%p, setAge:%p\n", [self.yKNoteKVOObject4 methodForSelector:@selector(setName:)], [self.yKNoteKVOObject4 methodForSelector:@selector(setAge:)]];
    
    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@", objcIMP, objcIMP2, objcIMP3, objcIMP4]];
}

- (void)addRuntimeMethodIMPToTextView {
    NSString *runtimeMethodImpl = [NSString stringWithFormat:@"runtimeMethodImpl yKNoteKVOObject setName:%p, setAge:%p\n", class_getMethodImplementation(object_getClass(self.yKNoteKVOObject), @selector(setName:)), class_getMethodImplementation(object_getClass(self.yKNoteKVOObject), @selector(setAge:))];
    NSString *runtimeMethodImpl2 = [NSString stringWithFormat:@"runtimeMethodImpl yKNoteKVOObject2 setName:%p, setAge:%p\n", class_getMethodImplementation(object_getClass(self.yKNoteKVOObject2), @selector(setName:)), class_getMethodImplementation(object_getClass(self.yKNoteKVOObject2), @selector(setAge:))];
    NSString *runtimeMethodImpl3 = [NSString stringWithFormat:@"runtimeMethodImpl yKNoteKVOObject3 setName:%p, setAge:%p\n", class_getMethodImplementation(object_getClass(self.yKNoteKVOObject3), @selector(setName:)), class_getMethodImplementation(object_getClass(self.yKNoteKVOObject3), @selector(setAge:))];
    NSString *runtimeMethodImpl4 = [NSString stringWithFormat:@"runtimeMethodImpl yKNoteKVOObject4 setName:%p, setAge:%p\n", class_getMethodImplementation(object_getClass(self.yKNoteKVOObject4), @selector(setName:)), class_getMethodImplementation(object_getClass(self.yKNoteKVOObject4), @selector(setAge:))];
    
    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"%@%@%@%@", runtimeMethodImpl, runtimeMethodImpl2, runtimeMethodImpl3, runtimeMethodImpl4]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"The value of %@ change to : %@\n",keyPath, [change objectForKey:@"new"]]];
    NSLog(@"The value of %@ change to : %@\n", keyPath, [change objectForKey:@"new"]);
}

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
        _textView.editable = NO;
    }
    return _textView;
}

@end
