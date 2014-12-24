//
//  FriendsFriendUser.h
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseUser.h"

@class LogInUser;

@interface FriendsFriendUser : BaseUser

@property (nonatomic, retain) LogInUser *rsLogInUser;

@end
