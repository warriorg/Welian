//
//  NSManagedObject+ManagedObjectQuery.h
//  iMenu
//
//  Created by yangxh yang on 11-10-14.
//  Copyright (c) 2011年 hotel3g.com. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DKManagedObjectQuery.h"

// need todo

@interface NSManagedObject (ManagedObjectQuery)

+ (DKManagedObjectQuery *)queryInManagedObjectContext:(NSManagedObjectContext *)context;

@end
