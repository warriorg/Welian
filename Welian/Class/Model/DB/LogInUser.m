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
#import "NeedAddUser.h"
#import "InvestIndustry.h"
#import "InvestStages.h"
#import "InvestItems.h"

@implementation LogInUser

@dynamic isNow;
@dynamic checkcode;
@dynamic sessionid;
@dynamic url;
@dynamic auth;
@dynamic openid;
@dynamic unionid;

@dynamic firststustid;
@dynamic newstustcount;
@dynamic homemessagebadge;
@dynamic investorcount;
@dynamic projectcount;
@dynamic isprojectbadge;
@dynamic isactivebadge;
@dynamic isinvestorbadge;
@dynamic newfriendbadge;
@dynamic activecount;

@dynamic rsCompanys;
@dynamic rsSchools;
@dynamic rsMyFriends;
@dynamic rsFriendsFriends;
@dynamic rsNewFriends;
@dynamic rsHomeMessages;
@dynamic rsInvestIndustrys;
@dynamic rsInvestItems;
@dynamic rsInvestStages;
@dynamic rsNeedAddUsers;
@dynamic rsProjectInfos;
@dynamic rsActivityInfos;


//获取当前登陆的账户
+ (LogInUser *)getCurrentLoginUser
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"isNow",@(YES)];
    LogInUser *loginUser = [LogInUser MR_findFirstWithPredicate:pre];
    return loginUser;
}

//创建新收据
+ (LogInUser *)createLogInUserModel:(UserInfoModel *)userInfoM
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"uid",userInfoM.uid];
    LogInUser *loginuser = [LogInUser MR_findFirstWithPredicate:pre];
//    LogInUser *loginuser = [LogInUser getLogInUserWithUid:userInfoM.uid];
    if (!loginuser) {
        loginuser = [LogInUser MR_createEntity];
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
    loginuser.inviteurl = userInfoM.inviteurl;
    loginuser.isNow = @(1);
//    [MOC save];
    [[loginuser managedObjectContext] MR_saveToPersistentStoreAndWait];
    return loginuser;
}

////创建新收据
//+ (LogInUser *)createLogInUserModel:(UserInfoModel *)userInfoM
//{
//    LogInUser *loginuser = [LogInUser getLogInUserWithUid:userInfoM.uid];
//    if (!loginuser) {
//        loginuser = [LogInUser create];
//    }
//    loginuser.uid = userInfoM.uid;
//    loginuser.mobile = userInfoM.mobile;
//    loginuser.position = userInfoM.position;
//    loginuser.provinceid = userInfoM.provinceid;
//    loginuser.provincename = userInfoM.provincename;
//    loginuser.cityid = userInfoM.cityid;
//    loginuser.cityname = userInfoM.cityname;
//    loginuser.friendship = userInfoM.friendship;
//    loginuser.shareurl = userInfoM.shareurl;
//    loginuser.avatar = userInfoM.avatar;
//    loginuser.name = userInfoM.name;
//    loginuser.address = userInfoM.address;
//    loginuser.email = userInfoM.email;
//    loginuser.investorauth = userInfoM.investorauth;
//    loginuser.startupauth = userInfoM.startupauth;
//    loginuser.company = userInfoM.company;
//    loginuser.checkcode = userInfoM.checkcode;
//    loginuser.sessionid = userInfoM.sessionid;
//    loginuser.inviteurl = userInfoM.inviteurl;
//    loginuser.isNow = @(1);
//    [MOC save];
//    return loginuser;
//}


+ (void)setUserFirststustid:(NSNumber *)firststustid
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.firststustid = firststustid;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setFirststustid:firststustid];
//    [MOC save];
}
+ (void)setUserNewstustcount:(NSNumber *)newstustcount
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.newstustcount = newstustcount;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setNewstustcount:newstustcount];
//    [MOC save];
}
+ (void)setUserHomemessagebadge:(NSNumber *)homemessagebadge
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.homemessagebadge = homemessagebadge;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setHomemessagebadge:homemessagebadge];
//    [MOC save];
}
+ (void)setUserInvestorcount:(NSNumber *)investorcount
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.investorcount = investorcount;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setInvestorcount:investorcount];
//    [MOC save];
}
+ (void)setUserProjectcount:(NSNumber *)projectcount
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.projectcount = projectcount;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
}
+ (void)setUserActivecount:(NSNumber *)activecount
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.activecount = activecount;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setActivecount:activecount];
//    [MOC save];
}
+ (void)setUserIsactivebadge:(BOOL)isactivebadge
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.isactivebadge = @(isactivebadge);
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setIsactivebadge:@(isactivebadge)];
//    [MOC save];
}
+ (void)setUserIsinvestorbadge:(BOOL)isinvestorbadge
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.isinvestorbadge = @(isinvestorbadge);
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setIsinvestorbadge:@(isinvestorbadge)];
//    [MOC save];
}
+ (void)setUserIsProjectBadge:(BOOL)isprojectbadge
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.isprojectbadge = @(isprojectbadge);
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
}
+ (void)setUserNewfriendbadge:(NSNumber *)newfriendbadge
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.newfriendbadge = newfriendbadge;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setNewfriendbadge:newfriendbadge];
//    [MOC save];
}


+ (void)setUserUid:(NSNumber *)uid
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.uid = uid;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setUid:uid];
//    [MOC save];
}

+ (void)setUserMobile:(NSString *)mobile
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.mobile = mobile;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setMobile:mobile];
//    [MOC save];
}

+ (void)setUserPosition:(NSString*)position
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.position = position;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setPosition:position];
//    [MOC save];
}

+ (void)setUserProvinceid:(NSNumber *)provinceid
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.provinceid = provinceid;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setProvinceid:provinceid];
//    [MOC save];
}

+ (void)setUserProvincename:(NSString *)provincename
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.provincename = provincename;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setProvincename:provincename];
//    [MOC save];
}

+ (void)setUserCityid:(NSNumber *)cityid
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.cityid = cityid;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setCityid:cityid];
//    [MOC save];
}

+ (void)setUserCityname:(NSString *)cityname
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.cityname = cityname;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setCityname:cityname];
//    [MOC save];
}

+ (void)setUserFriendship:(NSNumber *)friendship
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.friendship = friendship;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setFriendship:friendship];
//    [MOC save];
}

+ (void)setUserShareurl:(NSString *)shareurl
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.shareurl = shareurl;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setShareurl:shareurl];
//    [MOC save];
}

+ (void)setUserAvatar:(NSString *)avatar
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.avatar = avatar;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setAvatar:avatar];
//    [MOC save];
}

+ (void)setUserName:(NSString *)name
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.name = name;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setName:name];
//    [MOC save];
}

+ (void)setUserAddress:(NSString *)address
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.address = address;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setAddress:address];
//    [MOC save];
}

+ (void)setUserEmail:(NSString *)email
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.email = email;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setEmail:email];
//    [MOC save];
}

+ (void)setUserinvestorauth:(NSNumber *)investorauth
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.investorauth = investorauth;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setInvestorauth:investorauth];
//    [MOC save];
}

+ (void)setUserstartupauth:(NSNumber *)startupauth
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.startupauth = startupauth;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setStartupauth:startupauth];
//        [MOC save];
}

+ (void)setUsercompany:(NSString *)company
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.company = company;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setCompany:company];
//        [MOC save];
}

+ (void)setUsercheckcode:(NSString *)checkcode
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.checkcode = checkcode;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setCheckcode:checkcode];
//        [MOC save];
}

+ (void)setUserSessionid:(NSString *)sessionid
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.sessionid = sessionid;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser]setSessionid:sessionid];
//    [MOC save];
}

+ (void)setUserisNow:(BOOL)isnow
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.isNow = @(isnow);
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setIsNow:@(isnow)];
//    [MOC save];
}

+ (void)setUserUrl:(NSString *)url
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.url = url;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setUrl:url];
//    [MOC save];
}

//+ (void)setuserAuth:(NSNumber *)auth
//{
//    [[LogInUser getNowLogInUser] setAuth:auth];
//    [MOC save];
//}

+ (void)setUseropenid:(NSString *)openid
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.openid = openid;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setOpenid:openid];
//    [MOC save];
}
+ (void)setUserunionid:(NSString *)unionid
{
    LogInUser *loginUser = [self getCurrentLoginUser];
    loginUser.unionid = unionid;
    [[loginUser managedObjectContext] MR_saveToPersistentStoreAndWait];
    
//    [[LogInUser getNowLogInUser] setUnionid:unionid];
//    [MOC save];
}

//通过uid查询
+ (LogInUser *)getLogInUserWithUid:(NSNumber*)uid
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"uid",uid];
    LogInUser *loginuser = [LogInUser MR_findFirstWithPredicate:pre];
    
//    LogInUser *loginuser = [[[[LogInUser queryInManagedObjectContext:MOC] where:@"uid" equals:uid.stringValue] results] firstObject];
    return loginuser;
}

//获取正在聊天的好友列表
- (NSArray *)chatUsers
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",self,@"isChatNow",@(YES)];
    NSArray *users = [MyFriendUser MR_findAllSortedBy:@"lastChatTime" ascending:NO withPredicate:pre];
    return users;
//    return [[[[[MyFriendUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:self] where:@"isChatNow" isTrue:YES] orderBy:@"lastChatTime" ascending:NO] results];
}

//获取新的好友列表
- (NSArray *)allMyNewFriends
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"rsLogInUser",self];
    NSArray *allFriends = [NewFriendUser MR_findAllSortedBy:@"created" ascending:NO withPredicate:pre];
    return allFriends;

//    return [[[[NewFriendUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:self] orderBy:@"created" ascending:NO] results];
}

//所有未读取的聊天消息数量
- (NSInteger)allUnReadChatMessageNum
{
    NSInteger allCount = 0;
    for (MyFriendUser *friendUser in self.rsMyFriends.allObjects) {
        allCount += friendUser.unReadChatMsg.integerValue;//[friendUser unReadChatMessageNum];
    }
    return allCount;
}

//更新所有新的好友中，待验证的状态为添加状态
- (void)updateAllNewFriendsOperateStatus
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",self,@"operateType",@(3)];
    NSArray *waitNewFriends = [NewFriendUser MR_findAllWithPredicate:pre inContext:[self managedObjectContext]];
    
//    NSArray *waitNewFriends = [[[[NewFriendUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:self] where:@"operateType" equals:@"3"] results];
    for (NewFriendUser *newFriendUser in waitNewFriends) {
        [newFriendUser updateOperateType:0];
    }
}

//更新所有添加好友中，待验证的状态为添加状态
- (void)updateAllNeedAddFriendOperateStatus
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLoginUser",self,@"friendship",@"4"];
    NSArray *waitAddFriends = [NeedAddUser MR_findAllWithPredicate:pre inContext:[self managedObjectContext]];
    
//    NSArray *waitAddFriends = [[[[NeedAddUser queryInManagedObjectContext:MOC] where:@"rsLoginUser" equals:self] where:@"friendship" equals:@"4"] results];
    for (NeedAddUser *needAdd in waitAddFriends) {
        [needAdd updateFriendShip:2];
    }
}

//---------------------  我的好友  MyFriendUser操作 ---------------------/
// //通过uid查询
- (MyFriendUser *)getMyfriendUserWithUid:(NSNumber *)uid
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",self,@"uid",uid];
    MyFriendUser *myFriend = [MyFriendUser MR_findFirstWithPredicate:pre inContext:[self managedObjectContext]];
//    MyFriendUser *myFriend = [[[[[MyFriendUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"uid" equals:uid] results] firstObject];
    return myFriend;
}

// 所有好友
- (NSArray *)getAllMyFriendUsers
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K > %@ && %K == %@", @"rsLogInUser",self,@"uid",@"100",@"isMyFriend",@(YES)];
    NSArray *allFriends = [MyFriendUser MR_findAllWithPredicate:pre inContext:[self managedObjectContext]];
    return allFriends;
//    return  [[[[MyFriendUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"uid" greaterThan:@"100"] results];
}

//---------------------- SchoolModel ------------
//通过ucid查询
- (SchoolModel *)getSchoolModelWithUcid:(NSNumber*)usid
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",self,@"usid",usid];
    SchoolModel *schoolM = [SchoolModel MR_findFirstWithPredicate:pre inContext:[self managedObjectContext]];
//    SchoolModel *schoolM = [[[[[SchoolModel queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"usid" equals:usid] results] firstObject];
    
    return schoolM;
}

//---------------------- CompanyModel ------------
//通过ucid查询
- (CompanyModel *)getCompanyModelWithUcid:(NSNumber*)ucid
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",self,@"ucid",ucid];
    CompanyModel *company = [CompanyModel MR_findFirstWithPredicate:pre inContext:[self managedObjectContext]];
    
//    CompanyModel *company = [[[[[CompanyModel queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"ucid" equals:ucid] results] firstObject];
    return company;
}

// 查询所有数据并返回
- (NSArray *)allCompanyModels
{
// return [[[CompanyModel queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] results];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"rsLogInUser",self];
    NSArray *allCompanys = [CompanyModel MR_findAllWithPredicate:pre inContext:[self managedObjectContext]];
    return allCompanys;
}

//---------------------- NewFriendUser -------
- (NewFriendUser *)getNewFriendUserWithUid:(NSNumber *)uid
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",self,@"uid",uid];
    NewFriendUser *newFriend = [NewFriendUser MR_findFirstWithPredicate:pre inContext:[self managedObjectContext]];
//    NewFriendUser *newFriend = [[[[[NewFriendUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"uid" equals:uid] results] firstObject];
    return newFriend;
}

//---------------------HomeMessage----------
// //通过commentid查询
- (HomeMessage *)getHomeMessageWithUid:(NSNumber *)commentid
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",self,@"commentid",commentid];
    HomeMessage *homeMessage = [HomeMessage MR_findFirstWithPredicate:pre inContext:[self managedObjectContext]];
//    HomeMessage *homeMessage = [[[[[HomeMessage queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"commentid" equals:commentid] results] firstObject];
    return homeMessage;
}

// 获取未读消息
- (NSArray *)getIsLookNotMessages
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",self,@"isLook",@(NO)];
    NSArray *homearray = [HomeMessage MR_findAllWithPredicate:pre inContext:[self managedObjectContext]];
//    NSArray *homearray = [[[[HomeMessage queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"isLook" isTrue:NO] results];
    for (HomeMessage *meee  in homearray) {
        meee.isLook = @(1);
    }
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
//    [MOC save];
    return homearray;
    
}

//改变所有未读消息状态为已读
- (void)updateALLNotLookMessages
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",self,@"isLook",@(NO)];
    NSArray *homearray = [HomeMessage MR_findAllWithPredicate:pre inContext:[self managedObjectContext]];
    for (HomeMessage *meee  in homearray) {
        meee.isLook = @(1);
    }
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
}

// 获取全部消息
- (NSArray *)getAllMessages
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"rsLogInUser",self];
    NSArray *allHomeMessages = [HomeMessage MR_findAllSortedBy:@"created" ascending:NO withPredicate:pre];
    return allHomeMessages;
    
//    NSSortDescriptor *bookNameDes=[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO];
//    
//    return [[[[HomeMessage queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] results]  sortedArrayUsingDescriptors:@[bookNameDes]];
}

//--------------------InvestIndustry-----------
// //通过item查询
- (InvestIndustry *)getInvestIndustryWithName:(NSString *)name
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",self,@"industryname",name];
    InvestIndustry *investIndustry = [InvestIndustry MR_findFirstWithPredicate:pre inContext:[self managedObjectContext]];
//    InvestIndustry *investIndustry = [[[[[InvestIndustry queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"industryname" equals:name] results] firstObject];
    return investIndustry;
}

//--------------------InvestStages-------------
// //通过item查询
- (InvestStages *)getInvestStagesWithStage:(NSString *)item
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",self,@"stagename",item];
    InvestStages *investStage = [InvestStages MR_findFirstWithPredicate:pre inContext:[self managedObjectContext]];
//    InvestStages *investStage = [[[[[InvestStages queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"stagename" equals:item] results] firstObject];
    return investStage;
}

//--------------------InvestItems--------------
// 获取全部消息
- (NSArray *)getAllInvestItems
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"rsLogInUser",self];
    NSArray *allInvestItems = [InvestItems MR_findAllSortedBy:@"time" ascending:NO withPredicate:pre];
    return allInvestItems;
    
//    NSSortDescriptor *bookNameDes=[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO];
//    return [[[[InvestItems queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] results]  sortedArrayUsingDescriptors:@[bookNameDes]];
}

// //通过item查询
- (InvestItems *)getInvestItemsWithItem:(NSString *)item
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",self,@"item",item];
    InvestItems *investItem = [InvestItems MR_findFirstWithPredicate:pre inContext:[self managedObjectContext]];
//    InvestItems *investItem = [[[[[InvestItems queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"item" equals:item] results] firstObject];
    return investItem;
}

//--------------------NeedAddUser---------------
//获取已经存在的好友对象
- (NeedAddUser *)getNeedAddUserWithUid:(NSNumber *)uid
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLoginUser",self,@"uid",uid];
    NeedAddUser *needAddUser = [NeedAddUser MR_findFirstWithPredicate:pre inContext:[self managedObjectContext]];
    return needAddUser;
//    return [[[[[NeedAddUser queryInManagedObjectContext:MOC] where:@"rsLoginUser" equals:[LogInUser getCurrentLoginUser]] where:@"uid" equals:uid.stringValue] results] firstObject];
}

//获取已经存在的好友对象
- (NeedAddUser *)getNeedAddUserWithMobile:(NSString *)mobile
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsLogInUser",self,@"mobile",mobile];
    NeedAddUser *needAddUser = [NeedAddUser MR_findFirstWithPredicate:pre inContext:[self managedObjectContext]];
    return needAddUser;
}

@end
