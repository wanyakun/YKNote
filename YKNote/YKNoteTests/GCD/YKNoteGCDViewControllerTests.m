//
//  YKNoteGCDViewControllerTests.m
//  YKNoteTests
//
//  Created by wanyakun on 2020/7/9.
//  Copyright © 2020 wanyakun.github.io. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "YKNoteGCDViewController.h"

@interface YKNoteGCDViewControllerTests : XCTestCase

@end

@implementation YKNoteGCDViewControllerTests

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

- (void)testBarrierSync {
    [YKNoteGCDViewController testBarrierSync];
}

- (void)testBarrierAsync {
    [YKNoteGCDViewController testBarrierAsync];
}

- (void)testAsyncBarrierSync {
    [YKNoteGCDViewController testAsyncBarrierSync];
}

- (void)testAsyncBarrierAsync {
    [YKNoteGCDViewController testAsyncBarrierAsync];
}



@end
