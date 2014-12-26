//
//  HomeMessage.h
//  Welian
//
//  Created by dong on 14/12/26.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LogInUser, MessageHomeModel;

@interface HomeMessage : NSManagedObject

@property (nonatomic, retain) NSNumber * commentid;
@property (nonatomic, retain) NSNumber * isLook;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * feedcontent;
@property (nonatomic, retain) NSNumber * feedid;
@property (nonatomic, retain) NSString * feedpic;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * created;
@property (nonatomic, retain) LogInUser *rsLogInUser;

//创建新收据
+ (HomeMessage *)createHomeMessageModel:(MessageHomeModel *)userInfoM;

// //通过commentid查询
+ (HomeMessage *)getHomeMessageWithUid:(NSNumber *)commentid;

// 获取未读消息
+ (NSArray *)getIsLookNotMessages;

// 获取全部消息
+ (NSArray *)getAllMessages;

@end
