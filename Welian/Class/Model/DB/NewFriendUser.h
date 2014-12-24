//
//  NewFriendUser.h
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseUser.h"

@class LogInUser;

@interface NewFriendUser : BaseUser

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSNumber * isLook;
@property (nonatomic, retain) NSString * pushType;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSNumber * isAgree;
@property (nonatomic, retain) LogInUser *rsLogInUser;

@end
