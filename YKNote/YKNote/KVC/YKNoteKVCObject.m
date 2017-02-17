//
//  YKNoteKVCObject.m
//  YKNote
//
//  Created by wanyakun on 2016/11/10.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "YKNoteKVCObject.h"


@implementation YKNoteKVCObject

@synthesize intProperty = _intProperty;
@synthesize strProperty = _strProperty;

#pragma mark - method for orderSet
- (NSUInteger)countOfOrderSet {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return 5;
}

- (NSInteger)indexInOrderSetOfObject:(id)element {
    return 2;
}

- (id)objectInOrderSetAtIndex:(NSUInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [NSString stringWithFormat:@"orderSet_%ld", index];
}

#pragma mark - method for array
- (NSUInteger)countOfArray {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return 10;
}

- (id)objectInArrayAtIndex:(NSUInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [NSString stringWithFormat:@"array_%ld", index];
}

#pragma mark - mehtod for set
- (NSUInteger)countOfSet {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return 15;
}

- (NSEnumerator *)enumeratorOfSet {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSEnumerator *enumerator = [[NSEnumerator alloc] init];
    return enumerator;
}

- (NSString *)memberOfSet:(NSString *)object {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return [NSString stringWithFormat:@"member of set: %@", object];
}

#pragma mark - method for MutableOrderedSet
- (void)insertObject:(NSString *)object inMOrderSetAtIndex:(NSUInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)removeObjectFromMOrderSetAtIndex:(NSUInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - method for MutableArray
- (void)insertObject:(NSString *)object inMArrayAtIndex:(NSUInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)removeObjectFromMArrayAtIndex:(NSUInteger)index {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - method for mutableSet
- (void)addMSetObject:(NSString *)object {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)removeMSetObject:(NSString *)object {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - private method
- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"%s\nValueForUndefinedKey:%@", __PRETTY_FUNCTION__, key);
    return @"undefinedKeyValue";
}

- (void)setNilValueForKey:(NSString *)key {
    NSLog(@"%s\nNilValueKey:%@", __PRETTY_FUNCTION__, key);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%s\nundefineKey:%@", __PRETTY_FUNCTION__, key);
}

+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}


#pragma mark getter setter
- (NSInteger)intProperty {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return _intProperty;
}

- (void)setIntProperty:(NSInteger)intProperty {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _intProperty = intProperty;
}

- (NSString *)strProperty {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return _strProperty;
}

- (void)setStrProperty:(NSString *)strProperty {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _strProperty = [strProperty copy];
}

@end
