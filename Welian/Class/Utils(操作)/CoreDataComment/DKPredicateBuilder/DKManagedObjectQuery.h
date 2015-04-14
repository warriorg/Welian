//
//  DKManagedObjectQuery.h
//  iMenu
//
//  Created by yangxh yang on 11-10-14.
//  Copyright (c) 2011年 hotel3g.com. All rights reserved.
//

#import "DKPredicateBuilder.h"

@interface DKManagedObjectQuery : DKPredicateBuilder

+ (id)queryWithManagedObjectClass:(Class)cls inManagedObjectContext:(NSManagedObjectContext *)context;

- (NSFetchRequest *)fetchRequest;
- (NSFetchedResultsController *)fetchedResultsController;
- (NSFetchedResultsController *)fetchedResultsControllerWithSectionKeyPath:(NSString *)keyPath cacheName:(NSString *)cacheName;

- (NSArray *)results;
- (NSUInteger)count;

- (NSManagedObject *)firstObject;

- (id)only:(NSString *)column;
- (void)distinctResults:(BOOL)values;
- (id)batchSize:(int)value;

@end
