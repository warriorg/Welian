//
//  IFBase.m
//  iShow
//
//  Created by yangxh on 11-6-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "IFBase.h" 

#import <objc/runtime.h>

@implementation IFBase

- (id)initWithDict:(NSDictionary *)dict 
{
    NSDictionary *mapings = [self elementToPropertMapings];
    if ((self = [super init])) {
        
        if ([dict isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in mapings) {
                [self setValue:[dict objectForKey:key] forKey:[mapings objectForKey:key]];
            }
        }
        
        // 进行子类的自定义操作
        [self customOperation:dict];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    NSString *class = [self classForKey:key];
    if (class) {
        Class relationType = NSClassFromString(class);
        BOOL isDictionary = [value isKindOfClass:[NSDictionary class]];
        if (isDictionary) {
            if (![NSStringFromClass([value class]) isEqualToString:class]) {
                id obj = [[relationType alloc] initWithDict:value];
                value = obj;
            }
        } else {
            BOOL isArray = [value isKindOfClass:[NSArray class]];
            if (isArray) {
                NSMutableArray *holder = [NSMutableArray arrayWithCapacity:[(NSArray *)value count]];
                BOOL shouldChange = YES;
                for (NSDictionary *dict in value) {
                    if ([NSStringFromClass([dict class]) isEqualToString:class]) {
                        shouldChange = NO;
                        break;
                    }
                    
                    id obj = [[relationType alloc] initWithDict:dict];
                    [holder addObject:obj];
                }
                if (shouldChange) {
                    value = holder;
                }
            }
        }
        
        //LOG(@"supply class:(%@) for key:%@", class, key);
    }
    
    [super setValue:value forKey:key];
}

+ (id)objectWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (id)initWithDict:(NSDictionary *)dict exDict:(NSDictionary *)exDict
{
    self = [self initWithDict:dict];
    if (self) {
        if ( exDict ) {
            [self setValuesForKeysWithDictionary:exDict];
        }
    }
    return self;
}

- (void)customOperation:(NSDictionary *)dict {}

+ (NSArray *)objectsWithInfo:(NSArray *)info exDict:(NSDictionary *)exDict
{
    if (![info isKindOfClass:[NSArray class]]) {
        return nil;
    }
    __block NSMutableArray *holder = [[NSMutableArray alloc] initWithCapacity:[info count]];
    [info enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
        id base = [[[self class] alloc] initWithDict:obj exDict:exDict];
        [base atIndex:idx];
        [holder addObject:base];
    
    }];
    
    return (NSArray *)holder;
}

- (void)atIndex:(int)idx
{}

+ (NSArray *)objectsWithInfo:(NSArray *)info 
{
    return [self objectsWithInfo:info exDict:nil];
}

- (NSDictionary *)elementToPropertMapings {
    return [self elementToPropertMapingsByClass:[self class]];
}

- (NSDictionary *)elementToPropertMapingsByClass:(Class)classType {
        
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(classType, &outCount);
    NSMutableDictionary *mapings = [[NSMutableDictionary alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *key = [[NSString alloc] initWithCString:property_getName(property)
                                                 encoding:NSUTF8StringEncoding];
        [mapings setObject:key forKey:key];
    }
    free(properties);
    
    // Now see if we need to map any superclass as well
    Class superClass = class_getSuperclass(classType);
    if (superClass != nil && ![superClass isEqual:[NSObject class]]) {
        NSDictionary *maping = [self elementToPropertMapingsByClass:superClass];
        [mapings addEntriesFromDictionary:maping];
    }
    
    return (NSDictionary *)mapings;

}

- (NSString *)classForKey:(NSString *)key { return nil; }

- (NSString *)arraySupportKey { return nil; }

- (NSUInteger)arrayCount
{
    if (![self arraySupportKey]) {
        return 0;
    }
    
    return [(NSArray *)[self valueForKey:[self arraySupportKey]] count];
}

- (id)objectAtIndex:(NSUInteger)idx
{
    if (![self arraySupportKey]) {
        return nil;
    }
    
    return [[self valueForKey:[self arraySupportKey]] objectAtIndex:idx];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self objectAtIndex:idx];
}

- (void)insertObjects:(NSArray *)objs
{
    NSString *arrayKey = [self arraySupportKey];
    if (!arrayKey || ![objs count]) {
        return;
    }
    
    objs = [objs arrayByAddingObjectsFromArray:[self valueForKey:arrayKey]];
    [self setValue:objs
            forKey:arrayKey];
}

- (void)appendObjects:(NSArray *)objs
{
    NSString *arrayKey = [self arraySupportKey];
    if (!arrayKey || ![objs count]) {
        return;
    }
    
    [self setValue:[[self valueForKey:arrayKey] arrayByAddingObjectsFromArray:objs]
            forKey:arrayKey];
}

- (NSString *)description {
    return [self descriptionByClass:[self class]];
}

- (NSString *)descriptionByClass:(Class)classType {
    
    NSMutableString *desc = [NSMutableString string];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(classType, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSString *propertyValue = [self valueForKey:propertyName];
        
        [desc appendFormat:@"%@ : %@\n", propertyName, propertyValue];
    }
    free(properties);
    
    // Now see if we need to map any superclass as well
    Class superClass = class_getSuperclass(classType);
    if (superClass != nil && ![superClass isEqual:[NSObject class]]) {
        NSString *str = [self descriptionByClass:superClass];
        [desc appendString:str];
    }
    
    return desc;
}

- (id)valueForUndefinedKey:(NSString *)key 
{
    return nil;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //DebugLog(@"Set UndefinedKey:%@ for Value:%@", key, value);
}

- (void)setNilValueForKey:(NSString *)key
{
    
}

@end
