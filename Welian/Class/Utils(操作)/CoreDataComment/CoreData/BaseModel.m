//
//  BaseModel.m
//  iPodMenuPlus
//
//  Created by yangxh yang on 11-6-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BaseModel.h"
#import "NSManagedObject+ManagedObjectQuery.h"
#import "e0571CoreData.h"

@implementation BaseModel

+ (NSString*) localEntityKey{
    return nil;
}
+ (NSString*) dataSourceKey{
    return nil;
}

+ (void)updateWithData:(NSArray *)data EntityKey:(NSString *)entityKey IEntityKey:(NSString *)iEntityKey fethchFormat:(NSString *)fetchFormat
{
    NSMutableDictionary *dictHolder = [[NSMutableDictionary alloc] initWithCapacity:[data count]];
    for (id iEntity in data) {
        [dictHolder setObject:iEntity forKey:[iEntity valueForKey:iEntityKey]];
    }
    
    // 根据条件过滤更新数据源
    NSArray *localEntities;
    if ( !fetchFormat.length ) {
        localEntities = [self fetchAll];
    } else {
        localEntities = [self fetchWithPredicateFormat:fetchFormat];
    }
    
    for (id localEntity in localEntities) {
        id iEntity = [dictHolder objectForKey:[localEntity valueForKey:entityKey]];
        if (iEntity != nil) {
            [localEntity updateWithIEntity:iEntity];
            [dictHolder removeObjectForKey:[localEntity valueForKey:entityKey]];
        }else {
            [(NSManagedObject *)localEntity delete];
        }
    }
    
    for (NSString *key in dictHolder){
        id iEntity = [dictHolder objectForKey:key];
        
        /*
         yangxh 2011-12-20 add
         在有fetchFormat情况下，标识符对应的数据可能存在，但是没在条件内，
         这样就会存在 一个标识符 对应 多条数据
         解决：首先根据标识符查找，找不到然后再创建
        */
       
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", entityKey, key];
        
        if ([fetchFormat length] > 0) {
             NSPredicate *sourcePredicate = [NSPredicate predicateWithFormat:fetchFormat];
            predicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                                    subpredicates:[NSArray arrayWithObjects:
                                                                   predicate, sourcePredicate, nil]];
        }
        
        NSArray *entities = [self fetchWithPredicate:predicate];
        id entity = entities.count > 0 ? [entities objectAtIndex:0] : [self create];
        [entity updateWithIEntity:iEntity];
    }
    
    [MOC save];
}

+ (void)updateWithData:(NSArray *)data EntityKey:(NSString *)entityKey IEntityKey:(NSString *)iEntityKey
{
    [self updateWithData:data EntityKey:entityKey IEntityKey:iEntityKey fethchFormat:nil];
}

// 必须重写
- (NSDictionary*)elementToPropertMapings{return nil;}

+ (id)createWithIEntity:(id)iEntity{
    id instance = [self create];
    [instance updateWithIEntity:iEntity];
    return instance;
}

- (void)updateWithIEntity:(id)iEntity{
    NSDictionary *mapings = [self elementToPropertMapings];
    for (NSString *key in mapings) {
        if([[iEntity valueForKey:key] class] == [NSNull class]){
            [self setValue:nil forKey:[mapings objectForKey:key]];
        }
        else{
            [self setValue:[iEntity valueForKey:key] forKey:[mapings objectForKey:key]];
        } 
    }
}

+ (id)objectByEntityKey:(NSString *)value
{
    // 找出主键
    NSString *key = [self localEntityKey];
    if (!key || !value) {
        return nil;
    }
    
    // 查找记录
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@", key, value];
    return [self fetchFirsWithPredicateFormat:predicate.predicateFormat];
}

@end
