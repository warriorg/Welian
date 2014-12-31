//
//  LogInUser.m
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "LogInUser.h"
#import "CompanyModel.h"
#import "FriendsFriendUser.h"
#import "MyFriendUser.h"
#import "NewFriendUser.h"
#import "SchoolModel.h"
#import "HomeMessage.h"


@implementation LogInUser

@dynamic isNow;
@dynamic checkcode;
@dynamic sessionid;
@dynamic url;
@dynamic auth;

@dynamic rsCompanys;
@dynamic rsSchools;
@dynamic rsMyFriends;
@dynamic rsFriendsFriends;
@dynamic rsNewFriends;
@dynamic rsHomeMessages;
@dynamic rsInvestIndustrys;
@dynamic rsInvestItems;
@dynamic rsInvestStages;

//创建新收据
+ (LogInUser *)createLogInUserModel:(UserInfoModel *)userInfoM
{
    LogInUser *loginuser = [LogInUser getLogInUserWithUid:userInfoM.uid];
    if (!loginuser) {
        loginuser = [LogInUser create];
    }
    loginuser.uid = userInfoM.uid;
    loginuser.mobile = userInfoM.mobile;
    loginuser.position = userInfoM.position;
    loginuser.provinceid = userInfoM.provinceid;
    loginuser.provincename = userInfoM.provincename;
    loginuser.cityid = userInfoM.cityid;
    loginuser.cityname = userInfoM.cityname;
    loginuser.friendship = userInfoM.friendship;
    loginuser.shareurl = userInfoM.shareurl;
    loginuser.avatar = userInfoM.avatar;
    loginuser.name = userInfoM.name;
    loginuser.address = userInfoM.address;
    loginuser.email = userInfoM.email;
    loginuser.investorauth = userInfoM.investorauth;
    loginuser.startupauth = userInfoM.startupauth;
    loginuser.company = userInfoM.company;
    loginuser.checkcode = userInfoM.checkcode;
    loginuser.sessionid = userInfoM.sessionid;
    loginuser.isNow = @(1);
    [MOC save];
    return loginuser;
}

+ (void)setUserUid:(NSNumber *)uid
{
    [[LogInUser getNowLogInUser] setUid:uid];
    [MOC save];
}

+ (void)setUserMobile:(NSString *)mobile
{
    [[LogInUser getNowLogInUser] setMobile:mobile];
    [MOC save];
}

+ (void)setUserPosition:(NSString*)position
{
    [[LogInUser getNowLogInUser] setPosition:position];
    [MOC save];
}

+ (void)setUserProvinceid:(NSNumber *)provinceid
{
    [[LogInUser getNowLogInUser] setProvinceid:provinceid];
    [MOC save];
}

+ (void)setUserProvincename:(NSString *)provincename
{
    [[LogInUser getNowLogInUser] setProvincename:provincename];
    [MOC save];
}

+ (void)setUserCityid:(NSNumber *)cityid
{
    [[LogInUser getNowLogInUser] setCityid:cityid];
    [MOC save];
}

+ (void)setUserCityname:(NSString *)cityname
{
    [[LogInUser getNowLogInUser] setCityname:cityname];
    [MOC save];
}

+ (void)setUserFriendship:(NSNumber *)friendship
{
    [[LogInUser getNowLogInUser] setFriendship:friendship];
    [MOC save];
}

+ (void)setUserShareurl:(NSString *)shareurl
{
    [[LogInUser getNowLogInUser] setShareurl:shareurl];
    [MOC save];
}

+ (void)setUserAvatar:(NSString *)avatar
{
    [[LogInUser getNowLogInUser] setAvatar:avatar];
    [MOC save];
}

+ (void)setUserName:(NSString *)name
{
    [[LogInUser getNowLogInUser] setName:name];
    [MOC save];
}

+ (void)setUserAddress:(NSString *)address
{
    [[LogInUser getNowLogInUser] setAddress:address];
    [MOC save];
}

+ (void)setUserEmail:(NSString *)email
{
    [[LogInUser getNowLogInUser] setEmail:email];
    [MOC save];
}

+ (void)setUserinvestorauth:(NSNumber *)investorauth
{
    [[LogInUser getNowLogInUser] setInvestorauth:investorauth];
    [MOC save];
}

+ (void)setUserstartupauth:(NSNumber *)startupauth
{
    [[LogInUser getNowLogInUser] setStartupauth:startupauth];
        [MOC save];
}

+ (void)setUsercompany:(NSString *)company
{
    [[LogInUser getNowLogInUser] setCompany:company];
        [MOC save];
}

+ (void)setUsercheckcode:(NSString *)checkcode
{
    [[LogInUser getNowLogInUser] setCheckcode:checkcode];
        [MOC save];
}

+ (void)setUserSessionid:(NSString *)sessionid
{
    [[LogInUser getNowLogInUser]setSessionid:sessionid];
    [MOC save];
}

+ (void)setUserisNow:(BOOL)isnow
{
    [[LogInUser getNowLogInUser] setIsNow:@(isnow)];
    [MOC save];
}

+ (void)setUserUrl:(NSString *)url
{
    [[LogInUser getNowLogInUser] setUrl:url];
    [MOC save];
}

+ (void)setuserAuth:(NSNumber *)auth
{
    [[LogInUser getNowLogInUser] setAuth:auth];
    [MOC save];
}

//通过uid查询
+ (LogInUser *)getLogInUserWithUid:(NSNumber*)uid
{
    LogInUser *loginuser = [[[[LogInUser queryInManagedObjectContext:MOC] where:@"uid" equals:uid.stringValue] results] firstObject];
    return loginuser;
}

// 当前登录账户信息
+ (LogInUser *)getNowLogInUser
{
    LogInUser *loginuser = [[[[LogInUser queryInManagedObjectContext:MOC] where:@"isNow" isTrue:YES] results] firstObject];
    return loginuser;
}

//获取正在聊天的好友列表
+ (NSArray *)chatUsers
{
    return [[[[[MyFriendUser queryInManagedObjectContext:MOC] where:@"isChatNow" isTrue:YES] where:@"rsLogInUser" equals:[self getNowLogInUser]] orderBy:@"lastChatTime" ascending:NO] results];
}

//所有未读取的聊天消息数量
- (NSInteger)allUnReadChatMessageNum
{
    NSInteger allCount = 0;
    for (MyFriendUser *friendUser in self.rsMyFriends.allObjects) {
        allCount += [friendUser unReadChatMessageNum];
    }
    return allCount;
}

@end
