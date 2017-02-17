//
//  YKNoteKVCViewController.m
//  YKNote
//
//  Created by wanyakun on 2016/11/11.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteKVCViewController.h"
#import "YKNoteKVCObject.h"
#import <objc/runtime.h>

@interface YKNoteKVCViewController ()

@property (nonatomic, strong) YKNoteKVCObject *yKNoteKVCObject;

@end

@implementation YKNoteKVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"KVC";
    self.view.backgroundColor = [UIColor whiteColor];
    //通过存取器访问
    [self.yKNoteKVCObject setValue:[NSNumber numberWithInteger:10] forKey:@"intProperty"];
    NSInteger intProperty = [[self.yKNoteKVCObject valueForKey:@"intProperty"] integerValue];
    NSLog(@"intProperty = %ld", intProperty);
    
    [self.yKNoteKVCObject setValue:@"I am strProperty" forKey:@"strProperty"];
    NSString *strProperty = [self.yKNoteKVCObject valueForKey:@"strProperty"];
    NSLog(@"strProperty = %@", strProperty);
    
    //通过实例变量访问
    [self.yKNoteKVCObject setValue:[NSNumber numberWithInteger:20] forKey:@"intVar"];
    NSInteger intVar = [[self.yKNoteKVCObject valueForKey:@"intVar"] integerValue];
    NSLog(@"intVar = %ld", intVar);

    [self.yKNoteKVCObject setValue:@"I am strVar" forKey:@"strVar"];
    NSString *strVar = [self.yKNoteKVCObject valueForKey:@"strVar"];
    NSLog(@"strVar = %@", strVar);

    //set undefineKey
    [self.yKNoteKVCObject setValue:@"undefine value" forKey:@"undefinedKey"];

    //为非Object pointer参数类型设置nil
    [self.yKNoteKVCObject setValue:nil forKey:@"intProperty"];

    //NSOrderSet, NSArray, NSSet代理对象
    id orderSet = [self.yKNoteKVCObject valueForKey:@"orderSet"];
    id array = [self.yKNoteKVCObject valueForKey:@"array"];
    id set = [self.yKNoteKVCObject valueForKey:@"set"];
    NSLog(@"\norderSet class:%@\narray class:%@\nset class:%@", object_getClass(orderSet), object_getClass(array), object_getClass(set));
    
    //NSMutableOrderSet, NSMutableArray, NSMutableSet代理对象
    id mutableOrderSet = [self.yKNoteKVCObject mutableOrderedSetValueForKey:@"mOrderSet"];
    id mutableArray = [self.yKNoteKVCObject mutableArrayValueForKey:@"mArray"];
    id mutableSet = [self.yKNoteKVCObject mutableSetValueForKey:@"mSet"];
    NSLog(@"\nmutableOrderSet class:%@\nmutableArray class:%@\nmutableSet class:%@", object_getClass(mutableOrderSet), object_getClass(mutableArray), object_getClass(mutableSet));
    
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
- (YKNoteKVCObject *)yKNoteKVCObject {
    if (_yKNoteKVCObject == nil) {
        _yKNoteKVCObject = [[YKNoteKVCObject alloc] init];
    }
    return _yKNoteKVCObject;
}

@end
