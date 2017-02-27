//
//  TowSumTests.m
//  YKNote
//
//  Created by wanyakun on 2017/2/27.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TowSum.h"

@interface TowSumTests : XCTestCase

@end

@implementation TowSumTests

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

- (void)testTowSum {
    NSArray *nums = @[@3, @6, @1, @5, @2, @3];
    NSArray *result = [TowSum towSum:nums ofTarget:7];
    NSLog(@"%@", result);
}

@end
