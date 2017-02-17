//
//  SandBoxUtils.m
//  UCaiYuan
//
//  Created by wanyakun on 15/10/5.
//  Copyright © 2015年 com.ucaiyuan. All rights reserved.
//

#import "SandBoxUtils.h"

#define BundleIdentifier     [[NSBundle mainBundle] bundleIdentifier]


@implementation SandBoxUtils

+ (NSString *)homePath
{
    return NSHomeDirectory();
}

+ (NSString *)documentsPath
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (array.count > 0) {
        return [array firstObject];
    } else {
        return nil;
    }
}

+ (NSString *)cachePath
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if (array.count > 0) {
        return [array firstObject];
    } else {
        return nil;
    }
}

+ (NSString *)appCachePath {
    [SandBoxUtils createFolder:BundleIdentifier inPath:[SandBoxUtils cachePath]];
    return [[SandBoxUtils cachePath] stringByAppendingPathComponent:BundleIdentifier];
}

+ (NSString *)libraryPath
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (array.count > 0) {
        return [array firstObject];
    } else {
        return nil;
    }
}

+ (NSString *)tempPath
{
    return NSTemporaryDirectory();
}

+ (void)createFolder:(NSString *)folder inPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path] == NO) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *folderPath = [path stringByAppendingPathComponent:folder];
    if ([fileManager fileExistsAtPath:folderPath] == NO) {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+ (void)createFile:(NSString *)file inPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path] == NO) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [path stringByAppendingPathComponent:file];
    if ([fileManager fileExistsAtPath:filePath] == NO) {
        [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
}

+ (BOOL)isFilePathExist:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exists = [fileManager fileExistsAtPath:filePath];
    return exists;
}

#pragma mark - 归档缓存到沙盒
+ (void)archiveObject:(id)archiveObject withName:(NSString *)name
{
    NSString *path = [SandBoxUtils appCachePath];
    NSString *filePath = [path stringByAppendingPathComponent:name];
    [SandBoxUtils createFile:name inPath:path];
    if (archiveObject) {
        [NSKeyedArchiver archiveRootObject:archiveObject toFile:filePath];
    }
}

+ (id)unArchiveObjectWithName:(NSString *)name
{
    NSString *path = [SandBoxUtils appCachePath];
    NSString *filePath = [path stringByAppendingPathComponent:name];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    
    return nil;
}

+ (void)saveObject:(id)object withName:(NSString *)name
{
    NSString *path = [SandBoxUtils appCachePath];
    NSString *plist = [NSString stringWithFormat:@"%@.plist", name];
    NSString *filePath = [path stringByAppendingPathComponent:plist];
    [SandBoxUtils createFile:name inPath:path];
    
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:object];
    if (archiveData) {
        [archiveData writeToFile:filePath atomically:YES];
    }
}

+ (id)readObjectWithName:(NSString *)name
{
    NSString *path = [SandBoxUtils appCachePath];
    NSString *plist = [NSString stringWithFormat:@"%@.plist", name];
    NSString *filePath = [path stringByAppendingPathComponent:plist];

    NSData *archiveData = [NSData dataWithContentsOfFile:filePath];
    if (archiveData) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
    } else {
        return nil;
    }
}

@end
