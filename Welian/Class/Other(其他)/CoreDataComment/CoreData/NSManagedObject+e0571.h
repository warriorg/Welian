//
//  NSManagedObject+e0571.h
//  iPodMenuPlus
//
//  Created by yangxh yang on 11-6-29.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject(e0571)

#pragma mark -
#pragma mark Fetch all unsorted
+ (NSArray *)fetchAll;
+ (id)fetchFirst;

#pragma mark -
#pragma mark Fetch all sorted
+ (NSArray *)fetchAllSortBy:(NSString *)key ascending:(BOOL)ascending;
+ (NSArray *)fetchAllSortWith:(NSArray *)sortDescriptors;

#pragma mark -
#pragma mark Fetch filtered unsorted
+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate;
+ (NSArray *)fetchWithPredicateFormat:(NSString *)predicateFormat, ...;
+ (id)fetchFirsWithPredicateFormat:(NSString *)predicateFormat, ...;

#pragma mark -
#pragma mark Fetch filtered sorted
+ (NSArray *)fetchWithSortBy:(NSString *)key ascending:(BOOL)ascending withPredicate:(NSPredicate *)predicate;
+ (NSArray *)fetchWithSort:(NSArray *)sortDescriptors withPredicate:(NSPredicate *)predicate;
+ (NSArray *)fetchWithSortBy:(NSString *)key ascending:(BOOL)ascending predicateWithFormat:(NSString *)predicateFormat, ...;
+ (NSArray *)fetchWithSort:(NSArray *)sortDescriptors predicateWithFormat:(NSString *)predicateFormat, ...;

#pragma mark -
#pragma mark Custom
+ (id)create;
+ (void)deleteAll;
- (void)delete;

@end
