//
//  ChatMessage.h
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyFriendUser;

@interface ChatMessage : NSManagedObject

@property (nonatomic, retain) MyFriendUser *rsMyFriendUser;

@end
