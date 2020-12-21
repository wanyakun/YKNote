//
//  BubbleSortTests.m
//  YKNote
//
//  Created by wanyakun on 2017/2/19.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BubbleSortTests : XCTestCase

@property (nonatomic, strong) NSArray *array;

@end

@implementation BubbleSortTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _array = [NSArray arrayWithObjects:@2, @6, @5, @1, @17, @82, @4, @9, nil];
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

- (void)testBubbleSortWithArray {
//    NSMutableArray *array = [NSMutableArray arrayWithObjects:@2, @6, @5, @1, @17, @82, @4, @9, nil];
//    [BubbleSort bubbleSortWithArray:array];
//    NSLog(@"%@", array);
}

- (void)testBubbleSort {
//    NSArray *result = [BubbleSort bubbleSort:self.array];
//    NSLog(@"%@", result);
}

@end
