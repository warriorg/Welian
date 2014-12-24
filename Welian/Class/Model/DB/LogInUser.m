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


@implementation LogInUser

@dynamic checkcode;
@dynamic sessionid;
@dynamic rsCompanys;
@dynamic rsSchools;
@dynamic rsMyFriends;
@dynamic rsFriendsFriends;
@dynamic rsNewFriends;

//创建新收据
+ (LogInUser *)createLogInUserModel:(UserInfoModel *)userInfoM
{
    LogInUser *loginuser = [LogInUser getLogInUserWithUid:userInfoM.uid];
    if (!loginuser) {
        loginuser = [LogInUser create];
    }
    loginuser.uid = userInfoM.uid;
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
    
    return loginuser;
}


//通过uid查询
+ (LogInUser *)getLogInUserWithUid:(NSNumber*)uid
{
    LogInUser *loginuser = [[[LogInUser queryInManagedObjectContext:MOC] where:@"uid" equals:uid.stringValue] result];
    return loginuser;
}

@end
