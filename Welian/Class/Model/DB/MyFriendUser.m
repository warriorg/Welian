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

//更新聊天状态
- (void)updateIsChatStatus:(BOOL)status
{
    self.isChatNow = @(status);
    [MOC save];
    
    //聊天状态发送改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatUserChanged" object:nil];
}

//获取未读取的聊天消息数量
- (int)unReadChatMessageNum
{
    return [[[[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] where:@"isRead" isTrue:NO] results] count];
}

//获取所有的聊天消息列表
- (NSArray *)allChatMessages
{
    DKManagedObjectQuery *query = [[[ChatMessage queryInManagedObjectContext:MOC] where:@"rsMyFriendUser" equals:self] orderBy:@"timestamp" ascending:NO];
    //返回的数量 限制
//    [[query offset:5] limit:10];
    
    return query.results;
}

@end
