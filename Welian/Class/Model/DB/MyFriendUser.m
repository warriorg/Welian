//
//  MyFriendUser.m
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MyFriendUser.h"
#import "ChatMessage.h"
#import "LogInUser.h"
#import "FriendsUserModel.h"
#import "NewFriendModel.h"
#import "NewFriendUser.h"

@implementation MyFriendUser

@dynamic status;
@dynamic isChatNow;
@dynamic lastChatTime;
@dynamic rsChatMessages;
@dynamic rsLogInUser;

//创建新收据
+ (MyFriendUser *)createMyFriendUserModel:(FriendsUserModel *)userInfoM
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    MyFriendUser *myFriend = [loginUser getMyfriendUserWithUid:userInfoM.uid];
    if (!myFriend) {
        myFriend = [MyFriendUser MR_createEntityInContext:loginUser.managedObjectContext];
    }
    myFriend.uid = userInfoM.uid;
    myFriend.mobile = userInfoM.mobile;
    myFriend.position = userInfoM.position;
    myFriend.provinceid = userInfoM.provinceid;
    myFriend.provincename = userInfoM.provincename;
    myFriend.cityid = userInfoM.cityid;
    myFriend.cityname = userInfoM.cityname;
    myFriend.friendship = userInfoM.friendship;
    myFriend.shareurl = userInfoM.shareurl;
    myFriend.avatar = userInfoM.avatar;
    myFriend.name = userInfoM.name;
    myFriend.address = userInfoM.address;
    myFriend.email = userInfoM.email;
    myFriend.investorauth = userInfoM.investorauth;
    myFriend.startupauth = userInfoM.startupauth;
    myFriend.company = userInfoM.company;
    myFriend.status = userInfoM.status;
    
    [loginUser addRsMyFriendsObject:myFriend];
    [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    return myFriend;
}

//创建新的同意好意请求数据
+ (MyFriendUser *)createMyFriendNewFriendModel:(NewFriendModel *)userInfoM
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    MyFriendUser *myFriend = [loginUser getMyfriendUserWithUid:userInfoM.uid];
    if (!myFriend) {
        myFriend = [MyFriendUser MR_createEntityInContext:loginUser.managedObjectContext];
    }
    myFriend.uid = userInfoM.uid;
    myFriend.mobile = userInfoM.mobile;
    myFriend.position = userInfoM.position;
    myFriend.provinceid = userInfoM.provinceid;
    myFriend.provincename = userInfoM.provincename;
    myFriend.cityid = userInfoM.cityid;
    myFriend.cityname = userInfoM.cityname;
    myFriend.friendship = userInfoM.friendship;
    myFriend.shareurl = userInfoM.shareurl;
    myFriend.avatar = userInfoM.avatar;
    myFriend.name = userInfoM.name;
    myFriend.address = userInfoM.address;
    myFriend.email = userInfoM.email;
    myFriend.investorauth = userInfoM.investorauth;
    myFriend.startupauth = userInfoM.startupauth;
    myFriend.company = userInfoM.company;
//    myFriend.status = userInfoM.status;
    
    [loginUser addRsMyFriendsObject:myFriend];
    [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    return myFriend;
}

+ (void)createWithNewFriendUser:(NewFriendUser *)newFriendUser
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    MyFriendUser *myFriend = [loginUser getMyfriendUserWithUid:newFriendUser.uid];
    if (!myFriend) {
        myFriend = [MyFriendUser MR_createEntityInContext:loginUser.managedObjectContext];
    }
    myFriend.uid = newFriendUser.uid;
    myFriend.mobile = newFriendUser.mobile;
    myFriend.position = newFriendUser.position;
    myFriend.provinceid = newFriendUser.provinceid;
    myFriend.provincename = newFriendUser.provincename;
    myFriend.cityid = newFriendUser.cityid;
    myFriend.cityname = newFriendUser.cityname;
    myFriend.friendship = newFriendUser.friendship;
    myFriend.shareurl = newFriendUser.shareurl;
    myFriend.avatar = newFriendUser.avatar;
    myFriend.name = newFriendUser.name;
    myFriend.address = newFriendUser.address;
    myFriend.email = newFriendUser.email;
    myFriend.investorauth = newFriendUser.investorauth;
    myFriend.startupauth = newFriendUser.startupauth;
    myFriend.company = newFriendUser.company;
    //    myFriend.status = userInfoM.status;
    
    [loginUser addRsMyFriendsObject:myFriend];
    [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
}


//创建接收消息的聊天对象
+ (MyFriendUser *)createMyFriendFromReceive:(NSDictionary *)dict
{
    NSDictionary *fromuser = dict[@"fromuser"];
    LogInUser *loginUser = [LogInUser getLogInUserWithUid:dict[@"uid"]];
    
    MyFriendUser *myFriend = [loginUser getMyfriendUserWithUid:fromuser[@"uid"]];
    if (!myFriend) {
        myFriend = [MyFriendUser MR_createEntityInContext:loginUser.managedObjectContext];
        myFriend.uid = fromuser[@"uid"];
        myFriend.avatar = fromuser[@"avatar"];
        myFriend.name = fromuser[@"name"];
        
        [loginUser addRsMyFriendsObject:myFriend];
    }
    myFriend.isChatNow = @(YES);
    
    [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    return myFriend;
}

//更新聊天状态
- (void)updateIsChatStatus:(BOOL)status
{
    self.isChatNow = @(status);
//    [MOC save];
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    //聊天状态发送改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatUserChanged" object:nil];
}

//更新所有未读消息为读取状态
- (void)updateAllMessageReadStatus
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsMyFriendUser",self,@"isRead",@(NO)];
    NSArray *unReadMessages = [ChatMessage MR_findAllWithPredicate:pre];
    
//    NSArray *unReadMessages = [[[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] where:@"isRead" isTrue:NO] results];
    for (ChatMessage *chatMsg in unReadMessages) {
        [chatMsg updateReadStatus:YES];
    }
    
    //聊天状态发送改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatUserChanged" object:nil];
    //更新总的聊天消息数量
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatMsgNumChanged" object:nil];
}

//获取最新的一条消息
- (ChatMessage *)getTheNewChatMessage
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"rsMyFriendUser",self];
    ChatMessage *chatMessage = [ChatMessage MR_findFirstWithPredicate:pre sortedBy:@"timestamp" ascending:NO inContext:self.managedObjectContext];
    return chatMessage;
    
//    return [[[[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] orderBy:@"timestamp" ascending:YES] results] lastObject];
}

//获取最后一条消息
- (ChatMessage *)getTheLastChatMessage
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"rsMyFriendUser",self];
    ChatMessage *chatMessage = [ChatMessage MR_findFirstWithPredicate:pre sortedBy:@"timestamp" ascending:NO inContext:self.managedObjectContext];
    return chatMessage;
//    return [[[[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] orderBy:@"timestamp" ascending:YES] results] lastObject];
}

//更新最新一条聊天时间
- (void)updateLastChatTime:(NSDate *)chatTime
{
    self.lastChatTime = chatTime;
//    [MOC save];
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
}

//获取未读取的聊天消息数量
- (NSInteger)unReadChatMessageNum
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsMyFriendUser",self,@"isRead",@(NO)];
    NSArray *users = [ChatMessage MR_findAllWithPredicate:pre inContext:self.managedObjectContext];
    return users.count;
//    return [[[[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] where:@"isRead" isTrue:NO] results] count];
}

//获取当前最大的消息ID
- (NSNumber *)getMaxChatMessageId
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"rsMyFriendUser",self];
    ChatMessage *chatMessage = [ChatMessage MR_findFirstWithPredicate:pre sortedBy:@"msgId" ascending:NO inContext:self.managedObjectContext];
    
//    ChatMessage *chatMessage = [[[[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] orderBy:@"msgId" ascending:NO] results] firstObject];
    if (chatMessage) {
        return chatMessage.msgId;
    }else{
        return @(0);
    }
}

//获取对应msgId的消息
- (ChatMessage *)getChatMessageWithMsgId:(NSString *)msgId
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsMyFriendUser",self,@"msgId",msgId];
    ChatMessage *chatMessage = [ChatMessage MR_findFirstWithPredicate:pre inContext:self.managedObjectContext];
    return chatMessage;
//    return [[[[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] where:@"msgId" equals:msgId] results] firstObject];
}

//获取所有的聊天消息列表
- (NSArray *)allChatMessages
{
//    DKManagedObjectQuery *query = [[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] orderBy:@"timestamp" ascending:YES];
//    //返回的数量 限制
////    [[query offset:1] limit:2];
//    return query.results;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"rsMyFriendUser",self];
    NSArray *all = [ChatMessage MR_findAllSortedBy:@"timestamp" ascending:YES withPredicate:pre];
    return all;
}

- (NSArray *)getChatMessagesWithOffset:(NSInteger)offset count:(NSInteger)count
{
    
    DKManagedObjectQuery *query = [[[ChatMessage queryInManagedObjectContext:self.managedObjectContext] where:@"rsMyFriendUser" equals:self] orderBy:@"timestamp" ascending:YES];
    //返回的数量 限制
    [[query offset:(int)offset] limit:(int)count];
//    DLog(@"message--- %d",[[query results] count]);
    return query.results;
}


@end
