//
//  SortTests.m
//  YKNoteTests
//
//  Created by wanyakun on 2020/5/7.
//  Copyright © 2020 wanyakun.github.io. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Sort.h"

@interface SortTests : XCTestCase

@end

@implementation SortTests

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

- (void)testSortForInsert {
    NSMutableArray *array = [@[@49, @38, @65, @97, @76, @13, @27, @49] mutableCopy];
    [Sort sortingForInsertWithArray:array];
    NSLog(@"sort for insert result: %@", array);
}

- (void)testSortForInsert1 {
    NSMutableArray *array = [@[@49, @38, @65, @97, @76, @13, @27, @49] mutableCopy];
    NSMutableArray *result = [Sort sortingForInsertWithArray1:array];
    NSLog(@"sort for insert result: %@", result);
}

#pragma mark - 交换排序

/**
 冒泡排序
 */
-(void)testSortForBubble {
    NSMutableArray *array = [@[@49, @38, @65, @97, @76, @13, @27, @49] mutableCopy];
    [Sort sortingForBubbleWithArray:array];
    NSLog(@"sort for bubble result: %@", array);
}

@end
