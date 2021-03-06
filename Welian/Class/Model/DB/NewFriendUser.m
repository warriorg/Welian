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

@dynamic messageid;
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
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    NewFriendUser *newFriend = [loginUser getNewFriendUserWithUid:userInfoM.uid];
    if (!newFriend) {
        newFriend = [NewFriendUser MR_createEntityInContext:loginUser.managedObjectContext];
    }
    
    newFriend.messageid = userInfoM.messageid;
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
//    newFriend.startupauth = userInfoM.startupauth;
    newFriend.company = userInfoM.company;
    newFriend.created = userInfoM.created;
    newFriend.isLook = userInfoM.isLook;
    newFriend.pushType = userInfoM.type;
    newFriend.msg = userInfoM.msg;
    newFriend.isAgree = userInfoM.isAgree;
    newFriend.operateType = userInfoM.operateType;
    
    [loginUser addRsNewFriendsObject:newFriend];
    [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
//    newFriend.rsLogInUser = [LogInUser getCurrentLoginUser];
//    [MOC save];
    return newFriend;
}

// //通过uid查询
//+ (NewFriendUser *)getNewFriendUserWithUid:(NSNumber *)uid
//{
//    NewFriendUser *newFriend = [[[[[NewFriendUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"uid" equals:uid] results] firstObject];
//    return newFriend;
//}

//更新操作按钮状态
- (NewFriendUser *)updateOperateType:(NSInteger)type
{
    //操作类型0：添加 1：接受  2:已添加 3：待验证
    self.operateType = @(type);
//    [MOC save];
    [[self managedObjectContext] MR_saveToPersistentStoreAndWait];
    return self;
}

@end
