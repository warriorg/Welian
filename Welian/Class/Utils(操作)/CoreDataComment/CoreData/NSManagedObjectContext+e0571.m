//
//  NSManagedObjectContext+e0571.m
//  iPodMenuPlus
//
//  Created by yangxh on 11-5-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectContext+e0571.h"
#import "e0571CoreDataManager.h"

@implementation NSManagedObjectContext(e0571)

#pragma mark -
#pragma mark Fetch all unsorted

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
{
	return [self fetchObjectsForEntityName:entityName sortWith:nil
							 withPredicate:nil];
}

- (id)fetchFirstObjectForEntityName:(NSString *)entityName
{
	NSArray *objects = [self fetchObjectsForEntityName:entityName];
	return [objects count] > 0 ? [objects objectAtIndex:0] : nil;
}

#pragma mark -
#pragma mark Fetch all sorted

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending
{
	return [self fetchObjectsForEntityName:entityName sortByKey:key
								 ascending:ascending withPredicate:nil];
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                             sortWith:(NSArray*)sortDescriptors
{
	return [self fetchObjectsForEntityName:entityName sortWith:sortDescriptors
							 withPredicate:nil];
}

#pragma mark -
#pragma mark Fetch filtered unsorted

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                        withPredicate:(NSPredicate*)predicate
{
	return [self fetchObjectsForEntityName:entityName sortWith:nil
							 withPredicate:predicate];
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                  predicateWithFormat:(NSString*)predicateFormat, ...
{
	va_list variadicArguments;
	va_start(variadicArguments, predicateFormat);
	NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat
													arguments:variadicArguments];
	va_end(variadicArguments);
	
	return [self fetchObjectsForEntityName:entityName sortWith:nil
							 withPredicate:predicate];
}

- (id)fetchFirstObjectForEntityName:(NSString *)entityName
					predicateWithFormat:(NSString*)predicateFormat, ...
{
	va_list variadicArguments;
	va_start(variadicArguments, predicateFormat);
	NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat
													arguments:variadicArguments];
	va_end(variadicArguments);
	
	NSArray *objects = [self fetchObjectsForEntityName:entityName sortWith:nil
										 withPredicate:predicate];
	return [objects count] > 0 ? [objects objectAtIndex:0] : nil;
}

#pragma mark -
#pragma mark Fetch filtered sorted

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending
                        withPredicate:(NSPredicate*)predicate
{
	NSSortDescriptor* sort = [[[NSSortDescriptor alloc] initWithKey:key
														  ascending:ascending]
							  autorelease];
	
	return [self fetchObjectsForEntityName:entityName sortWith:[NSArray
																arrayWithObject:sort] withPredicate:predicate];
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                             sortWith:(NSArray*)sortDescriptors
                        withPredicate:(NSPredicate*)predicate
{
	NSEntityDescription* entity = [NSEntityDescription entityForName:entityName
											  inManagedObjectContext:self];
	NSFetchRequest* request = [[[NSFetchRequest alloc] init] autorelease];
    //[[[NSFetchRequest alloc] init] retain];
	[request setEntity:entity];
	
	if (predicate)
	 {
		[request setPredicate:predicate];
	 }
	
	if (sortDescriptors)
	 {
		[request setSortDescriptors:sortDescriptors];
	 }
	
	NSError* error = nil;
	NSArray* results = [self executeFetchRequest:request error:&error];
	
	if (error != nil)
	 {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [NSException raise:NSGenericException format:@"%@",[error description]];
	 }
	
	return results;
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending
                  predicateWithFormat:(NSString*)predicateFormat, ...
{
	va_list variadicArguments;
	va_start(variadicArguments, predicateFormat);
	NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat
													arguments:variadicArguments];
	va_end(variadicArguments);
	
	return [self fetchObjectsForEntityName:entityName sortByKey:key
								 ascending:ascending withPredicate:predicate];
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                             sortWith:(NSArray*)sortDescriptors
                  predicateWithFormat:(NSString*)predicateFormat, ...
{
	va_list variadicArguments;
	va_start(variadicArguments, predicateFormat);
	NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat
													arguments:variadicArguments];
	va_end(variadicArguments);
	
	return [self fetchObjectsForEntityName:entityName sortWith:sortDescriptors
							 withPredicate:predicate];
}

- (id)insertNewObjectForEntityForName:(NSString *)entityName
{
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

- (void)deleteAllObjectsForName:(NSString *)entityName
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    [fetchRequest setEntity:entity];
	
    NSError *error;
    NSArray *items = [self executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
	
	
    for (NSManagedObject *managedObject in items) {
        [self deleteObject:managedObject];
        //NSLog(@"%@ object deleted",entityName);
    }
    if (![self save:&error]) {
        //NSLog(@"Error deleting %@ - error:%@",entityName,error);
    }
}

- (void)save
{
//    return [[e0571CoreDataManager sharedInstance] saveContext];
    
    
    if (![self hasChanges]) {
        //return YES;
        return;
    }
    
    NSError *error = nil;
    if (![self save:&error]) {
        NSLog(@"CORE DATA ERROR:%@", error);
        //return NO;
        //return;
    }
    //return YES;
     
}

@end
