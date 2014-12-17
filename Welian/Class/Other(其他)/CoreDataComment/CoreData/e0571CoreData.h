/*
 *  e0571CoreData.h
 *  iPodMenuPlus
 *
 *  Created by yangxh on 11-5-6.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "e0571CoreDataManager.h"
#import "NSManagedObject+e0571.h"
#import "NSManagedObjectContext+e0571.h"

#define MOC ([[e0571CoreDataManager sharedInstance] contextForCurrentThread])