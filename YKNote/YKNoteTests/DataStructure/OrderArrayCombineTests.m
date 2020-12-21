//
//  OrderArrayCombineTests.m
//  YKNoteTests
//
//  Created by wanyakun on 2020/5/6.
//  Copyright © 2020 wanyakun.github.io. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OrderArrayCombine.h"

@interface OrderArrayCombineTests : XCTestCase

@end

@implementation OrderArrayCombineTests

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

- (void)testOrderCombine1 {
    NSArray *array1 = @[@1, @4, @6, @7, @9];
    NSArray *array2 = @[@2, @3, @5, @8, @9, @10, @11, @12];
    NSArray *result = [OrderArrayCombine arrayCombineWithArray1:array1 array2:array2];
    NSLog(@"result: %@", result);
}

@end
