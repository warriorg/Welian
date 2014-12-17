//
//  NSManagedObjectContext+e0571.h
//  iPodMenuPlus
//
//  Created by yangxh on 11-5-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObjectContext(e0571)

#pragma mark -
#pragma mark Fetch all unsorted

/** @brief Convenience method to fetch all objects for a given Entity name in
 * this context.
 *
 * The objects are returned in the order specified by Core Data.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName;

/** @brief Convenience method to fetch all objects for a given Entity name in
 * this context.
 *
 * The object are returned in the order specified by Core Data.
 */
- (id)fetchFirstObjectForEntityName:(NSString *)entityName;

#pragma mark -
#pragma mark Fetch all sorted

/** @brief Convenience method to fetch all objects for a given Entity name in
 * the context.
 *
 * The objects are returned in the order specified by the provided key and
 * order.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending;

/** @brief Convenience method to fetch all objects for a given Entity name in
 * the context.
 *
 * If the sort descriptors array is not nil, the objects are returned in the
 * order specified by the sort descriptors. Otherwise, the objects are returned
 * in the order specified by Core Data.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                             sortWith:(NSArray*)sortDescriptors;

#pragma mark -
#pragma mark Fetch filtered unsorted

/** @brief Convenience method to fetch selected objects for a given Entity name
 * in the context.
 *
 * If the predicate is not nil, the selection is filtered by the provided
 * predicate.
 *
 * The objects are returned in the order specified by Core Data.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                        withPredicate:(NSPredicate*)predicate;

/** @brief Convenience method to fetch selected objects for a given Entity name
 * in the context.
 *
 * The selection is filtered by the provided formatted predicate string and
 * arguments.
 *
 * The objects are returned in the order specified by Core Data.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                  predicateWithFormat:(NSString*)predicateFormat, ...;

/** @brief Convenience method to fetch selected objects for a given Entity name
 * in the context.
 *
 * The selection is filtered by the provided formatted predicate string and
 * arguments.
 *
 * The object are returned in the order specified by Core Data.
 */
- (id)fetchFirstObjectForEntityName:(NSString *)entityName
							   predicateWithFormat:(NSString*)predicateFormat, ...;

#pragma mark -
#pragma mark Fetch filtered sorted

/** @brief Convenience method to fetch selected objects for a given Entity name
 * in the context.
 *
 * If the predicate is not nil, the selection is filtered by the provided
 * predicate.
 *
 * The objects are returned in the order specified by the provided key and
 * order.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending
                        withPredicate:(NSPredicate*)predicate;

/** @brief Convenience method to fetch selected objects for a given Entity name
 * in the context.
 *
 * If the predicate is not nil, the selection is filtered by the provided
 * predicate.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
							 sortWith:(NSArray*)sortDescriptors
                        withPredicate:(NSPredicate*)predicate;

/** @brief Convenience method to fetch selected objects for a given Entity name
 * in the context.
 *
 * The selection is filtered by the provided formatted predicate string and
 * arguments.
 *
 * The objects are returned in the order specified by the provided key and
 * order.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending
                  predicateWithFormat:(NSString*)predicateFormat, ...;

/** @brief Convenience method to fetch selected objects for a given Entity name
 * in the context.
 *
 * The selection is filtered by the provided formatted predicate string and
 * arguments.
 *
 * If the sort descriptors array is not nil, the objects are returned in the
 * order specified by the sort descriptors. Otherwise, the objects are returned
 * in the order specified by Core Data.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                             sortWith:(NSArray*)sortDescriptors
                  predicateWithFormat:(NSString*)predicateFormat, ...;


#pragma mark -
#pragma mark Custom

/**
 @brief Creates and returns a new managed object in the entity with the supplied name with default values from the supplied dictionary
 @param name The name of the entity in which to create the object
 @result The newly created NSMangagedObject
 */
- (id)insertNewObjectForEntityForName:(NSString *)entityName;

// delete all objects in table
- (void)deleteAllObjectsForName:(NSString *)entityName;

//save
- (void)save;

@end
