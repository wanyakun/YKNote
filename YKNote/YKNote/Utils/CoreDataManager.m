//
//  CoreDataManager.m
//  UCaiYuan
//
//  Created by wanyakun on 16/1/6.
//  Copyright © 2016年 com.ucaiyuan. All rights reserved.
//

#import "CoreDataManager.h"
#import <CoreData/CoreData.h>

@interface CoreDataManager ()
/**
 *  负责应用和数据直接的交互CRUD
 */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
/**
 *  添加持久化存储库（比如SQLite数据库）
 */
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
/**
 *  代表CoreData模型文件
 */
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@end

@implementation CoreDataManager

#pragma mark - 单例
+(CoreDataManager *)defaultManager {
    static dispatch_once_t predicate;
    static CoreDataManager * defaultManager;
    dispatch_once(&predicate, ^{
        defaultManager=[[CoreDataManager alloc] init];
    });
    return defaultManager;
}

#pragma mark - public method
/**
 *  插入单条数据到Entity
 *
 *  @param entity 实体字典
 *  @param name   Entity名称
 */
- (BOOL)insertCoreDataWithEntity:(NSDictionary *)entity name:(NSString *)name {
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managedObjectContext];
    [object setValuesForKeysWithDictionary:entity];
    // 利用上下文对象，将数据同步到持久化存储库
    NSError *error = nil;
    BOOL success = [self.managedObjectContext save:&error];
    if (!success) {
#ifdef DEBUG
        NSLog(@"保存数据到数据库错误：%@",[error localizedDescription]);
#endif
        return NO;
    }
    return YES;
}

- (BOOL)insertOrUpdateCoreDataWithEntity:(NSDictionary *)entity name:(NSString *)name predicate:(NSString *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];
    request.entity = entityDescription;
    
    if (predicate) {
        NSPredicate *predicateObject = [NSPredicate predicateWithFormat:predicate];
        request.predicate = predicateObject;
    }
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchedObjects.count > 0) {
        for (NSManagedObject *object in fetchedObjects) {
            [object setValuesForKeysWithDictionary:entity];
        }
    } else {
        NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:self.managedObjectContext];
        [object setValuesForKeysWithDictionary:entity];
    }
    
    BOOL success = [self.managedObjectContext save:&error];
    if (!success) {
#ifdef DEBUG
        NSLog(@"插入或者更新数据到数据库错误：%@",[error localizedDescription]);
#endif
        return NO;
    }
    return YES;

}

/**
 *  根据查询条件从实体中查询数据
 *
 *  @param entityName Entity名称
 *  @param predicate  查询条件
 *
 *  @return 字典数组
 */
- (NSMutableArray *)selectCoreDataFromName:(NSString *)name predicate:(NSString *)predicate {
    return [self selectCoreDataFromName:name predicate:predicate sort:nil limit:0];
}

- (NSMutableArray *)selectCoreDataFromName:(NSString *)name predicate:(NSString *)predicate sort:(NSArray *)sort limit:(NSInteger)limit {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];
    request.entity = entity;
    
    if (predicate) {
        NSPredicate *predicateObject = [NSPredicate predicateWithFormat:predicate];
        request.predicate = predicateObject;
    }
    
    if (sort) {
        request.sortDescriptors = sort;
    }
    
    if (limit > 0) {
        request.fetchLimit = limit;
    }
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (NSManagedObject *object in fetchedObjects) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSPropertyDescription *property in entity.properties) {
            NSString *key = property.name;
            id value = [object valueForKey:key];
            [dict setValue:value forKey:key];
        }
        [resultArray addObject:dict];
    }
    return resultArray;
}

/**
 *  更新单条数据到Entity
 *
 *  @param entity    更新内容
 *  @param name      Entity名字
 *  @param predicate 更新条件
 *
 *  @return 是否更新成功
 */
- (BOOL)updateCoreDataWithEntity:(NSDictionary *)entity name:(NSString *)name predicate:(NSString *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];
    request.entity = entityDescription;
    
    if (predicate) {
        NSPredicate *predicateObject = [NSPredicate predicateWithFormat:predicate];
        request.predicate = predicateObject;
    }
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject *object in fetchedObjects) {
        [object setValuesForKeysWithDictionary:entity];
    }
    
    BOOL success = [self.managedObjectContext save:&error];
    if (!success) {
#ifdef DEBUG
        NSLog(@"更新数据到数据库错误：%@",[error localizedDescription]);
#endif
        return NO;
    }
    return YES;
}

/**
 *  从Entity中删除数据
 *
 *  @param entity    更新内容
 *  @param name      Entity名字
 *  @param predicate 更新条件
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteCoreDataWithName:(NSString *)name predicate:(NSString *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:name inManagedObjectContext:self.managedObjectContext];
    request.entity = entityDescription;
    
    if (predicate) {
        NSPredicate *predicateObject = [NSPredicate predicateWithFormat:predicate];
        request.predicate = predicateObject;
    }
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject *object in fetchedObjects) {
        [self.managedObjectContext deleteObject:object];
    }

    BOOL success = [self.managedObjectContext save:&error];
    if (!success) {
#ifdef DEBUG
        NSLog(@"删除数据出错：error:%@",error);
#endif
        return NO;
    }
    return YES;
}

#pragma mark - private method
//获取Documents路径
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)bundleName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

#pragma mark - getter setter
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
    }
    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[self bundleName]];
        NSError *error = nil;
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
#ifdef DEBUG
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#endif
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managedObjectModel;
}

@end
