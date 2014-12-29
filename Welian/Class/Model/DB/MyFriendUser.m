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

@implementation MyFriendUser

@dynamic status;
@dynamic isChatNow;
@dynamic rsChatMessages;
@dynamic rsLogInUser;

//创建新收据
+ (MyFriendUser *)createMyFriendUserModel:(FriendsUserModel *)userInfoM
{
    MyFriendUser *myFriend = [MyFriendUser getMyfriendUserWithUid:userInfoM.uid];
    if (!myFriend) {
        myFriend = [MyFriendUser create];
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
    myFriend.rsLogInUser = [LogInUser getNowLogInUser];
    [MOC save];
    return myFriend;
}


// //通过uid查询
+ (MyFriendUser *)getMyfriendUserWithUid:(NSNumber *)uid
{
//    [LogInUser getNowLogInUser].rsMyFriends.allObjects
//    NSPredicate * filter = [NSPredicate predicateWithFormat:@"uid = %@",uid];
    
    MyFriendUser *myFriend = [[[[[MyFriendUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getNowLogInUser]] where:@"uid" equals:uid] results] firstObject];
    return myFriend;
}

//创建接收消息的聊天对象
+ (MyFriendUser *)createMyFriendFromReceive:(NSDictionary *)dict
{
    NSDictionary *fromuser = dict[@"fromuser"];
    LogInUser *user = [LogInUser getLogInUserWithUid:dict[@"uid"]];
    MyFriendUser *myFriend = [MyFriendUser getMyfriendUserWithUid:fromuser[@"uid"]];
    if (!myFriend) {
        myFriend = [MyFriendUser create];
        myFriend.uid = fromuser[@"uid"];
        myFriend.avatar = fromuser[@"avatar"];
        myFriend.name = fromuser[@"name"];
        myFriend.rsLogInUser = user;
    }
    myFriend.isChatNow = @(YES);
    [MOC save];
    return myFriend;
}

//更新聊天状态
- (void)updateIsChatStatus:(BOOL)status
{
    self.isChatNow = @(status);
    [MOC save];
    
    //聊天状态发送改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatUserChanged" object:nil];
}

//更新所有未读消息为读取状态
- (void)updateAllMessageReadStatus
{
    NSArray *unReadMessages = [[[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] where:@"isRead" isTrue:NO] results];
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
    return [[[[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] orderBy:@"timestamp" ascending:YES] results] lastObject];
}

//获取未读取的聊天消息数量
- (NSInteger)unReadChatMessageNum
{
    return [[[[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] where:@"isRead" isTrue:NO] results] count];
}

//获取当前最大的消息ID
- (NSString *)getMaxChatMessageId
{
    ChatMessage *chatMessage = [[[[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] orderBy:@"msgId" ascending:NO] results] firstObject];
    if (chatMessage) {
        return chatMessage.msgId;
    }else{
        return @"0";
    }
}

//获取对应msgId的消息
- (ChatMessage *)getChatMessageWithMsgId:(NSString *)msgId
{
    return [[[[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] where:@"msgId" equals:msgId] results] firstObject];
}

//获取所有的聊天消息列表
- (NSArray *)allChatMessages
{
    DKManagedObjectQuery *query = [[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] orderBy:@"timestamp" ascending:YES];
    //返回的数量 限制
//    [[query offset:5] limit:10];
    
    return query.results;
}


@end
