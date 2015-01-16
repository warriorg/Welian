//
//  e0571CoreDataManager.m
//  iPodMenuPlus
//
//  Created by yangxh on 11-5-6.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "e0571CoreDataManager.h"

@interface e0571CoreDataManager()

- (NSString *)bundleName;
- (NSString *)applicationDocumentsDirectory;

@end

@implementation e0571CoreDataManager

+ (e0571CoreDataManager *)sharedInstance
{
    static e0571CoreDataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[e0571CoreDataManager alloc] init];
    });
    
    return instance;
}

- (id)init
{
	self = [super init];
	if (self) {
		initialType = [NSSQLiteStoreType retain];
		storePath = [[[self applicationDocumentsDirectory] stringByAppendingPathComponent:self.dbNameWithExt] retain];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
//        [self setupSaveNotification];
	}
	return self;
}

- (void)setupSaveNotification
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification* note) {
                                                      NSManagedObjectContext *moc = self.threadManagedObjectContext;
                                                      if (note.object != moc) {
                                                          [moc performBlock:^(){
                                                              [moc mergeChangesFromContextDidSaveNotification:note];
                                                          }];
                                                      }
                                                  }];
}


- (NSString *)dbName {
    
    BOOL debug = NO;
    NSNumber *isDebug = [[NSUserDefaults standardUserDefaults] valueForKey:SETTING_DEBUG_KEY];
    if (isDebug) {
        debug = [isDebug boolValue];
    }
    
    NSString *baseDbName = [self bundleName];
    
    return (debug ? [baseDbName stringByAppendingString:@"_debug"] : baseDbName);
}

- (NSString *)dbNameWithExt {
    return [NSString stringWithFormat:@"%@.sqlite", self.dbName];
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */

- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectContext *)threadManagedObjectContext
{
	if (threadManagedObjectContext != nil) {
        return threadManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        threadManagedObjectContext = [[NSManagedObjectContext alloc] init];
//        threadManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//        threadManagedObjectContext.undoManager = nil;
        [threadManagedObjectContext setPersistentStoreCoordinator:coordinator];
//        [threadManagedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }
    return threadManagedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	/*
	 Set up the store.
	 For the sake of illustration, provide a pre-populated default store.
	*/
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:storePath]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:self.dbName ofType:@"sqlite"];
		if (defaultStorePath) {
			[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:nil];
		}
	}
	
    NSURL *storeUrl = [NSURL fileURLWithPath: storePath];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    

    return persistentStoreCoordinator;
}

//
- (void)saveContext
{
	NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
	
	if (threadManagedObjectContext != nil) {
        if ([threadManagedObjectContext hasChanges] && ![threadManagedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)initContext {
    
    [self saveContext];

    
    [managedObjectContext autorelease];
    managedObjectContext = nil;
    [threadManagedObjectContext autorelease];
    threadManagedObjectContext = nil;
    [persistentStoreCoordinator autorelease];
    persistentStoreCoordinator = nil;
    
}

- (NSManagedObjectContext *)contextForCurrentThread {
    if ([NSThread isMainThread]) {
        return [self managedObjectContext];
    } else {
        return [self threadManagedObjectContext];
    }
}

//- (void)mocDidSaveNotification:(NSNotification *)notification
//{
//    NSManagedObjectContext *savedContext = [notification object];
//    
//    if (savedContext == self.contextForCurrentThread) {
//        return ;
//    }
//    
//    if (savedContext.persistentStoreCoordinator != self.persistentStoreCoordinator) {
//        return ;
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"Merge changes from other context.\n");
//        [self.contextForCurrentThread mergeChangesFromContextDidSaveNotification:notification];
//    });
//}

#pragma mark - Private

- (NSString *)bundleName {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *result = [info objectForKey:@"CFBundleName"];
    
    return result;
}

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
