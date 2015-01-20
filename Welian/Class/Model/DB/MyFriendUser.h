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

@class ChatMessage, LogInUser, FriendsUserModel, WLMessage, NewFriendModel,NewFriendUser;

@interface MyFriendUser : BaseUser

@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * isChatNow;
@property (nonatomic, retain) NSDate * lastChatTime;
@property (nonatomic, retain) NSSet *rsChatMessages;
@property (nonatomic, retain) LogInUser *rsLogInUser;

//创建新收据
+ (MyFriendUser *)createMyFriendUserModel:(FriendsUserModel *)userInfoM;

//创建新的同意好意请求数据
+ (MyFriendUser *)createMyFriendNewFriendModel:(NewFriendModel *)userInfoM;
+ (void)createWithNewFriendUser:(NewFriendUser *)newFriendUser;

//创建接收消息的聊天对象
+ (MyFriendUser *)createMyFriendFromReceive:(NSDictionary *)dict;

//更新聊天状态
- (void)updateIsChatStatus:(BOOL)status;
//更新所有未读消息为读取状态
- (void)updateAllMessageReadStatus;
//获取最新的一条消息
- (ChatMessage *)getTheNewChatMessage;
//获取最后一条消息
- (ChatMessage *)getTheLastChatMessage;
//更新最新一条聊天时间
- (void)updateLastChatTime:(NSDate *)chatTime;

//获取未读取的聊天消息数量
- (NSInteger)unReadChatMessageNum;
//获取当前最大的消息ID
- (NSNumber *)getMaxChatMessageId;
//获取对应msgId的消息
- (ChatMessage *)getChatMessageWithMsgId:(NSString *)msgId;
//获取所有的聊天消息列表
- (NSArray *)allChatMessages;
- (NSArray *)getChatMessagesWithOffset:(NSInteger)offset count:(NSInteger)count;

@end

@interface MyFriendUser (CoreDataGeneratedAccessors)

- (void)addRsChatMessagesObject:(ChatMessage *)value;
- (void)removeRsChatMessagesObject:(ChatMessage *)value;
- (void)addRsChatMessages:(NSSet *)values;
- (void)removeRsChatMessages:(NSSet *)values;

@end
