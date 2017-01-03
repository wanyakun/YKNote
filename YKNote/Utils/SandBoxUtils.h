//
//  SandBoxUtils.h
//  UCaiYuan
//
//  Created by wanyakun on 15/10/5.
//  Copyright © 2015年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SandBoxUtils : NSObject

/**
 *  获取根目录
 *
 *  @return 获取根目录
 */
+ (NSString *)homePath;

/**
 *  获取Document目录
 *
 *  @return 获取Document目录
 */
+ (NSString *)documentsPath;

/**
 *  获取Cache目录
 *
 *  @return 获取Cache目录
 */
+ (NSString *)cachePath;

/**
 *  App缓存目录
 *
 *  @return App缓存目录
 */
+ (NSString *)appCachePath;

/**
 *  获取Library目录
 *
 *  @return 获取Library目录
 */
+ (NSString *)libraryPath;

/**
 *  获取temp目录
 *
 *  @return 获取temp目录
 */
+ (NSString *)tempPath;

/**
 *  在路径Path下创建文件夹
 *
 *  @param folder 文件夹名称
 *  @param path   路径
 */
+ (void)createFolder:(NSString *)folder inPath:(NSString *)path;

/**
 *  在路径Path下创建文件
 *
 *  @param file 文件名称
 *  @param path 路径
 */
+ (void)createFile:(NSString *)file inPath:(NSString *)path;

/**
 *  文件是否存在
 *
 *  @param filePath 文件路径
 *
 *  @return 是否存在
 */
+ (BOOL)isFilePathExist:(NSString *)filePath;


#pragma mark - 归档缓存到沙盒
/**
 *  归档数据到缓存，archiveObject对象需要实现归档协议
 *
 *  @param archiveObject 归档对象
 *  @param name 归档对象名称
 */
+ (void)archiveObject:(id)archiveObject withName:(NSString *)name;

/**
 *  根据名称读取归档数据到文件，生成对象
 *
 *  @param name 归档对象名称
 */
+ (id)unArchiveObjectWithName:(NSString *)name;

/**
 *  保存数据到缓存中的plist，object对象需要实现归档协议
 *
 *  @param object 归档对象
 *  @param name 归档对象名称
 */
+ (void)saveObject:(id)object withName:(NSString *)name;

/**
 *  根据名称读取plist归档数据到文件，生成对象
 *
 *  @param name 归档对象名称
 */
+ (id)readObjectWithName:(NSString *)name;

@end
