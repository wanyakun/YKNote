//
//  FindCommonSuperViewsTests.m
//  YKNoteTests
//
//  Created by wanyakun on 2020/5/6.
//  Copyright © 2020 wanyakun.github.io. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FindCommonSuperViews.h"

@interface FindCommonSuperViewsTests : XCTestCase

@end

@implementation FindCommonSuperViewsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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

- (void)testFindCommonViews {
    UIView *viewA1 = [[UIView alloc] init];
    [viewA1 setTag:11];
    UIView *viewA2 = [[UIView alloc] init];
    [viewA2 setTag:12];
    UIView *viewA3 = [[UIView alloc] init];
    [viewA3 setTag:13];
    UIView *viewA4 = [[UIView alloc] init];
    [viewA4 setTag:14];
    UIView *viewA5 = [[UIView alloc] init];
    [viewA5 setTag:15];

    [viewA5 addSubview:viewA4];
    [viewA4 addSubview:viewA3];
    [viewA3 addSubview:viewA2];
    [viewA2 addSubview:viewA1];
    
    UIView *viewB1 = [[UIView alloc] init];
    [viewB1 setTag:21];
    UIView *viewB2 = [[UIView alloc] init];
    [viewB2 setTag:22];
    UIView *viewB3 = [[UIView alloc] init];
    [viewB3 setTag:23];
    UIView *viewB4 = [[UIView alloc] init];
    [viewB4 setTag:24];
    
    [viewA3 addSubview:viewB4];
    [viewB4 addSubview:viewB3];
    [viewB3 addSubview:viewB2];
    [viewB2 addSubview:viewB1];
    
    NSArray *result = [FindCommonSuperViews findCommonSuperViewsWithView1:viewA1 view2:viewB1];
    for (UIView *view in result) {
        NSLog(@"%ld", view.tag);
    }
}

@end
