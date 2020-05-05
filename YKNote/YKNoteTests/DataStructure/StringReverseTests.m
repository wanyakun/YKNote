//
//  StringReverseTests.m
//  YKNoteTests
//
//  Created by wanyakun on 2020/5/5.
//  Copyright © 2020 wanyakun.github.io. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StringReverse.h"

@interface StringReverseTests : XCTestCase

@end

@implementation StringReverseTests

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

- (void)testWithStringReverse {
    [StringReverse reverseWithString:@"Hello, Word!"];
    [StringReverse reverseWithString:@"Hello,Word!"];
    [StringReverse reverseWithString:@"hello,word"];
}

- (void)testWithStringReverse1 {
    [StringReverse reverseWithString1:@"Hello, Word!"];
}

- (void)testWithStringReverse2 {
    [StringReverse reverseWithString1:@"Hello,Word!"];
}

- (void)testWithStringReverse3 {
    [StringReverse reverseWithString1:@"hello,word"];
}

@end
