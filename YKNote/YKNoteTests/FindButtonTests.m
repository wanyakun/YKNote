//
//  FindButtonTests.m
//  YKNote
//
//  Created by wanyakun on 2017/2/19.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface FindButtonTests : XCTestCase

@end

@implementation FindButtonTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testFindButtons {
    //首层
    UIView *view = [[UIView alloc] init];
    //第二层
    UIView *view11 = [[UIView alloc] init];
    [view addSubview:view11];
    UIView *view12 = [[UIView alloc] init];
    [view addSubview:view12];
    UIView *view13 = [[UIButton alloc] init];
    [view addSubview:view13];
    //第三层
    UIView *view111 = [[UIView alloc] init];
    [view11 addSubview:view111];
    UIView *view112 = [[UIButton alloc] init];
    [view11 addSubview:view112];
    UIView *view113 = [[UIButton alloc] init];
    [view11 addSubview:view113];

    UIView *view121 = [[UIView alloc] init];
    [view12 addSubview:view121];
    UIView *view122 = [[UIButton alloc] init];
    [view12 addSubview:view122];
    UIView *view123 = [[UIButton alloc] init];
    [view12 addSubview:view123];
    //第四层
    UIView *view1111 = [[UIView alloc] init];
    [view111 addSubview:view1111];
    UIView *view1112 = [[UIButton alloc] init];
    [view111 addSubview:view1112];
    UIView *view1113 = [[UIButton alloc] init];
    [view111 addSubview:view1113];
    
    //递归
    NSInteger recursion = [self recursionFindButtonInView:view];
    //迭代
    NSInteger iteration = [self iterationFindButtonInView:view];
    
    NSLog(@"recursion=%ld, iteration=%ld", recursion, iteration);
}

//递归查找View中所有button的个数
- (NSInteger)recursionFindButtonInView:(UIView *)view {
    NSInteger result = 0;
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            result += 1;
        }
        result += [self recursionFindButtonInView:subView];
    }
    return result;
}
//迭代查找View中所有button的个数
- (NSInteger)iterationFindButtonInView:(UIView *)view {
    NSInteger result = 0;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:view];
    while (array.count > 0) {
        UIView *firstView = array.firstObject;
        for (UIView *subView in firstView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                result += 1;
            }
            [array addObject:subView];
        }
        [array removeObjectAtIndex:0];
    }
    return result;
}

@end
