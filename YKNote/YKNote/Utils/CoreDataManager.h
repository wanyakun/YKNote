//
//  CoreDataManager.h
//  UCaiYuan
//
//  Created by wanyakun on 16/1/6.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

+(CoreDataManager *)defaultManager;

/**
 *  插入单条数据到Entity
 *
 *  @param entity 实体字典
 *  @param name   Entity名称
 */
- (BOOL)insertCoreDataWithEntity:(NSDictionary *)entity name:(NSString *)name;

/**
 *  插入或者更新单条数据到Entity
 *
 *  @param entity    实体字典
 *  @param name      Entity名称
 *  @param predicate 条件
 *
 *  @return 是否成功
 */
- (BOOL)insertOrUpdateCoreDataWithEntity:(NSDictionary *)entity name:(NSString *)name predicate:(NSString *)predicate;

/**
 *  根据查询条件从实体中查询数据
 *
 *  @param name Entity名称
 *  @param predicate  查询条件
 *
 *  @return 字典数组
 */
- (NSMutableArray *)selectCoreDataFromName:(NSString *)name predicate:(NSString *)predicate;

- (NSMutableArray *)selectCoreDataFromName:(NSString *)name predicate:(NSString *)predicate sort:(NSArray *)sort limit:(NSInteger)limit;
/**
 *  更新单条数据到Entity
 *
 *  @param entity    更新内容
 *  @param name      Entity名字
 *  @param predicate 更新条件
 *
 *  @return 是否更新成功
 */
- (BOOL)updateCoreDataWithEntity:(NSDictionary *)entity name:(NSString *)name predicate:(NSString *)predicate;

/**
 *  从Entity中删除数据
 *
 *  @param name      Entity名字
 *  @param predicate 更新条件
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteCoreDataWithName:(NSString *)name predicate:(NSString *)predicate;

@end
