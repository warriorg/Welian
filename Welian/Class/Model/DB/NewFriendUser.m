//
//  NewFriendUser.m
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "NewFriendUser.h"
#import "LogInUser.h"
#import "NewFriendModel.h"

@implementation NewFriendUser

@dynamic created;
@dynamic isLook;
@dynamic pushType;
@dynamic msg;
@dynamic isAgree;
@dynamic operateType;
@dynamic rsLogInUser;

//创建新收据
+ (NewFriendUser *)createNewFriendUserModel:(NewFriendModel *)userInfoM
{
    NewFriendUser *newFriend = [NewFriendUser getNewFriendUserWithUid:userInfoM.uid];
    if (!newFriend) {
        newFriend = [NewFriendUser create];
    }
    
    newFriend.uid = userInfoM.uid;
    newFriend.mobile = userInfoM.mobile;
    newFriend.position = userInfoM.position;
    newFriend.provinceid = userInfoM.provinceid;
    newFriend.provincename = userInfoM.provincename;
    newFriend.cityid = userInfoM.cityid;
    newFriend.cityname = userInfoM.cityname;
    newFriend.friendship = userInfoM.friendship;
    newFriend.shareurl = userInfoM.shareurl;
    newFriend.avatar = userInfoM.avatar;
    newFriend.name = userInfoM.name;
    newFriend.address = userInfoM.address;
    newFriend.email = userInfoM.email;
    newFriend.investorauth = userInfoM.investorauth;
    newFriend.startupauth = userInfoM.startupauth;
    newFriend.company = userInfoM.company;
    newFriend.created = userInfoM.created;
    newFriend.isLook = userInfoM.isLook;
    newFriend.pushType = userInfoM.type;
    newFriend.msg = userInfoM.msg;
    newFriend.isAgree = userInfoM.isAgree;
    newFriend.operateType = userInfoM.operateType;
    newFriend.rsLogInUser = [LogInUser getNowLogInUser];
    
    [MOC save];
    return newFriend;
}

// //通过uid查询
+ (NewFriendUser *)getNewFriendUserWithUid:(NSNumber *)uid
{
    NewFriendUser *newFriend = [[[[[NewFriendUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getNowLogInUser]] where:@"uid" equals:uid] results] firstObject];
    return newFriend;
}

//更新操作按钮状态
- (NewFriendUser *)updateOperateType:(NSInteger)type
{
    self.operateType = @(type);
    [MOC save];
    return self;
}

@end
