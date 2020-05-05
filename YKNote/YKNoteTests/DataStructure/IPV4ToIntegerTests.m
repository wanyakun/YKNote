//
//  IPV4ToIntegerTests.m
//  YKNote
//
//  Created by wanyakun on 2017/2/28.
//  Copyright © 2017年 wanyakun.github.io. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IPV4ToInteger.h"

@interface IPV4ToIntegerTests : XCTestCase

@end

@implementation IPV4ToIntegerTests

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

- (void)testIPToIntegerWithNil {
    NSInteger result = [IPV4ToInteger ipv4ToInteger:nil];
    NSLog(@"%s %ld", __PRETTY_FUNCTION__, result);
}

- (void)testIPToIntegerWithNULL {
    NSString *ipstr = (NSString *)[NSNull null];
    NSInteger result = [IPV4ToInteger ipv4ToInteger:ipstr];
    NSLog(@"%s %ld", __PRETTY_FUNCTION__, result);
}

- (void)testIPToIntegerWithEmpty {
    NSInteger result = [IPV4ToInteger ipv4ToInteger:@""];
    NSLog(@"%s %ld", __PRETTY_FUNCTION__, result);
}

- (void)testIPToIntegerWithSpace {
    NSInteger result = [IPV4ToInteger ipv4ToInteger:@"   "];
    NSLog(@"%s %ld", __PRETTY_FUNCTION__, result);
}

- (void)testIPToIntegerWithMoreNumber {
    NSInteger result = [IPV4ToInteger ipv4ToInteger:@"172.168.1.5.6"];
    NSLog(@"%s %ld", __PRETTY_FUNCTION__, result);
}

- (void)testIPToIntegerCorrect {
    NSInteger result = [IPV4ToInteger ipv4ToInteger:@"172.168.5.1"];
    NSLog(@"%s %ld", __PRETTY_FUNCTION__, result);
}

- (void)testIPToIntegerWithCorrectSpace {
    NSInteger result = [IPV4ToInteger ipv4ToInteger:@"172 . 168.   5.1   "];
    NSLog(@"%s %ld", __PRETTY_FUNCTION__, result);
}


- (void)testIPToIntegerWithErrorSpace {
    NSInteger result = [IPV4ToInteger ipv4ToInteger:@"1 72. 168.5.1"];
    NSLog(@"%s %ld", __PRETTY_FUNCTION__, result);
}

- (void)testIPToIntegerWithLetter {
    NSInteger result = [IPV4ToInteger ipv4ToInteger:@"abc.168.5.1"];
    NSLog(@"%s %ld", __PRETTY_FUNCTION__, result);
}

- (void)testIPToIntegerWithErrorIp {
    NSInteger result = [IPV4ToInteger ipv4ToInteger:@"192.168.5.256"];
    NSLog(@"%s %ld", __PRETTY_FUNCTION__, result);
}

- (void)testIPToIntegerWithIpMask {
    NSInteger result = [IPV4ToInteger ipv4ToInteger:@"255.255.255.0"];
    NSLog(@"%s %ld", __PRETTY_FUNCTION__, result);
}

- (void)testIPToIntegerWithZeroIp {
    NSInteger result = [IPV4ToInteger ipv4ToInteger:@"0.0.0.0"];
    NSLog(@"%s %ld", __PRETTY_FUNCTION__, result);
}

@end
