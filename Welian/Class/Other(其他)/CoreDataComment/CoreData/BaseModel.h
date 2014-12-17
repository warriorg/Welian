//
//  BaseModel.h
//  iPodMenuPlus
//
//  Created by yangxh yang on 11-6-25.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BaseModel : NSManagedObject


+ (id)createWithIEntity:(id)iEntity;
- (void)updateWithIEntity:(id)iEntity;

+ (void)updateWithData:(NSArray *)data EntityKey:(NSString *)entityKey IEntityKey:(NSString *)iEntityKey fethchFormat:(NSString *)fetchFormat;
+ (void)updateWithData:(NSArray *)data EntityKey:(NSString *)entityKey IEntityKey:(NSString *)iEntityKey;

- (NSDictionary *)elementToPropertMapings;

+ (NSString*) dataSourceKey;
+ (NSString*) localEntityKey;
+ (id)objectByEntityKey:(NSString *)value;

@end
