//
//  DKManagedObjectQuery.m
//  iMenu
//
//  Created by yangxh yang on 11-10-14.
//  Copyright (c) 2011年 hotel3g.com. All rights reserved.
//

#import "DKManagedObjectQuery.h"

@interface DKManagedObjectQuery()

@property (nonatomic, assign) Class cls; 
@property (nonatomic, retain) NSMutableArray *columns;
@property (nonatomic, retain) NSNumber *batchSize;
@property (nonatomic, assign) BOOL distinctResults;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation DKManagedObjectQuery

@synthesize cls;
@synthesize batchSize;
@synthesize columns;
@synthesize distinctResults;
@synthesize managedObjectContext;

+ (id)queryWithManagedObjectClass:(Class)cls inManagedObjectContext:(NSManagedObjectContext *)context
{
    DKManagedObjectQuery *query = [[[DKManagedObjectQuery alloc] init] autorelease];
    query.cls = cls;
    query.columns = [NSMutableArray array];
    query.managedObjectContext = context;
    return query;
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass(self.cls) inManagedObjectContext:managedObjectContext]];
    
    [fetchRequest setPredicate:self.compoundPredicate];
    [fetchRequest setSortDescriptors:self.sorters];
    
    if (self.limit) 
    {
        [fetchRequest setFetchLimit:self.limit.integerValue];
    }
    
    if (self.offset)
    {
        [fetchRequest setFetchOffset:self.offset.integerValue];
    }
    
    if (self.batchSize) 
    {
        [fetchRequest setFetchBatchSize:self.batchSize.integerValue];
    }
    
    if (self.columns.count > 0)
    {
        [fetchRequest setPropertiesToFetch:self.columns];
        fetchRequest.resultType = NSDictionaryResultType;
    }
    
    // use only for this
    [fetchRequest setReturnsDistinctResults:self.distinctResults];
    
    return [fetchRequest autorelease];
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    return [self fetchedResultsControllerWithSectionKeyPath:nil cacheName:nil];
}

- (NSFetchedResultsController *)fetchedResultsControllerWithSectionKeyPath:(NSString *)keyPath cacheName:(NSString *)cacheName {
    
    // Create the FetchedResultsController
    NSFetchedResultsController *fetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                        managedObjectContext:managedObjectContext
                                          sectionNameKeyPath:keyPath
                                                   cacheName:cacheName];
    return [fetchedResultsController autorelease];

}

- (NSArray *)results
{
    NSError *error = nil;
    NSArray *objects = [managedObjectContext executeFetchRequest:self.fetchRequest error:&error];
    
    if (objects == nil)
    {
        NSLog(@"%@", error.localizedDescription);
        abort();
    }
    
    return objects;
}

- (NSUInteger)count
{
    NSError *error = nil;
    NSUInteger count  = [managedObjectContext countForFetchRequest:self.fetchRequest error:&error];
    
    if (error != nil) 
    {
        NSLog(@"%@", error.localizedDescription);
        abort();
    }
    
    return count;
}

- (id)only:(NSString *)column
{
    //NSPropertyDescription *p = [NSPropertyDescription ]
    
    [self.columns addObject:column];
    
    return self;
}

- (void)distinctResults:(BOOL)values
{
    self.distinctResults = values;
}

- (id)batchSize:(int)value
{
    self.batchSize = [NSNumber numberWithInt:value];
    
    return self;
}

- (NSManagedObject *)firstObject
{
    return self.count > 0 ? [self.results objectAtIndex:0] : nil;
}

- (void)dealloc
{
    self.columns = nil;
    self.batchSize = nil;
    
    [super dealloc];
}

@end
