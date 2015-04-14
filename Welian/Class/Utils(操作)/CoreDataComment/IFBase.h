//
//  IFBase.h
//  iShow
//
//  Created by yangxh on 11-6-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IFBase : NSObject

#pragma mark - 解析字典对象
- (id)initWithDict:(NSDictionary *)dict;
+ (id)objectWithDict:(NSDictionary *)dict;
// exDict 中的key必须和属性名称相同
- (id)initWithDict:(NSDictionary *)dict exDict:(NSDictionary *)exDict;

#pragma mark - 自定义操作
- (void)customOperation:(NSDictionary *)dict;
- (void)atIndex:(int)idx;

#pragma mark - 解析数组对象
+ (NSArray *)objectsWithInfo:(NSArray *)info;
+ (NSArray *)objectsWithInfo:(NSArray *)info exDict:(NSDictionary *)exDict;

#pragma mark - 映射
- (NSDictionary *)elementToPropertMapings;
- (NSDictionary *)elementToPropertMapingsByClass:(Class)classType;
- (NSString *)classForKey:(NSString *)key;

#pragma mark - 描述
- (NSString *)descriptionByClass:(Class)classType;

#pragma mark - Array Support
- (NSString *)arraySupportKey;
- (NSUInteger)arrayCount;
- (id)objectAtIndex:(NSUInteger)idx;
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)insertObjects:(NSArray *)objs;
- (void)appendObjects:(NSArray *)objs;


@end
