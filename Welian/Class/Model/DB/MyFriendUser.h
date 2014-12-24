//
//  MyFriendUser.h
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseUser.h"

@class ChatMessage, LogInUser;

@interface MyFriendUser : BaseUser

@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSSet *rsChatMessages;
@property (nonatomic, retain) LogInUser *rsLogInUser;
@end

@interface MyFriendUser (CoreDataGeneratedAccessors)

- (void)addRsChatMessagesObject:(ChatMessage *)value;
- (void)removeRsChatMessagesObject:(ChatMessage *)value;
- (void)addRsChatMessages:(NSSet *)values;
- (void)removeRsChatMessages:(NSSet *)values;

@end
