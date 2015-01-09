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


@implementation LogInUser

@dynamic isNow;
@dynamic checkcode;
@dynamic sessionid;
@dynamic url;
@dynamic auth;
@dynamic openid;
@dynamic unionid;

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

+ (void)setUseropenid:(NSString *)openid
{
    [[LogInUser getNowLogInUser] setOpenid:openid];
    [MOC save];
}
+ (void)setUserunionid:(NSString *)unionid
{
    [[LogInUser getNowLogInUser] setUnionid:unionid];
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

//创建需要添加的好友对象
- (void)createNeedAddUserWithDict:(NSDictionary *)dict  withType:(NSInteger)type
{
    //    avatar = "http://img.welian.com/1418279171961-200-194_x.png";
    //    friendship = 1;
    //    mobile = 15068114669;
    //    name = "\U590f\U663e\U6797\Uff0c\U4f20\U9001\U95e8";
    //    uid = 10071;
    //    wlname = "\U590f\U663e\U6797";
    NSNumber *uid = [dict[@"uid"] integerValue] == 0 ? nil : @([dict[@"uid"] integerValue]);
    NSString *name = dict[@"name"];
    NSString *wlName = dict[@"wlname"];
    NSString *mobile = dict[@"mobile"];
    NSString *avatar = dict[@"avatar"];
    NSNumber *friendship = dict[@"friendship"] == nil ? @(0) : @([dict[@"friendship"] integerValue]);
    if (friendship.integerValue == -1) {
        //自己
        return;
    }
    
    NeedAddUser *needAddUser = (uid != nil ? [self getNeedAddUserWithUid:uid] : [self getNeedAddUserWithMobile:mobile]);
    if (!needAddUser) {
        needAddUser = [NeedAddUser create];
    }
    needAddUser.avatar = avatar;
    needAddUser.friendship = friendship;
    needAddUser.mobile = mobile;
    needAddUser.name = name;
    needAddUser.wlname = wlName;
    needAddUser.pinyin = [name getHanziFirstString];
    needAddUser.userType = @(type);
    [MOC save];
}

//获取已经存在的好友对象
- (NeedAddUser *)getNeedAddUserWithUid:(NSNumber *)uid
{
    return [[[[[NeedAddUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:self] where:@"uid" equals:uid.stringValue] results] firstObject];
}

//获取已经存在的好友对象
- (NeedAddUser *)getNeedAddUserWithMobile:(NSString *)mobile
{
    return [[[[[NeedAddUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:self] where:@"mobile" equals:mobile] results] firstObject];
}

//获取排序后的通讯录联系人
- (NSMutableArray *)allNeedAddUserWithType:(NSInteger)type
{
    //friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
    //系统非好友联系人
    NSArray *systemNoFriendArray = [[[[[[NeedAddUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:self] where:@"userType" equals:@(type).stringValue] where:@"friendship" equals:@"2"] orderBy:@"pinyin" ascending:YES] results];
    
    //系统好友联系人
    NSArray *systemFriendArray = [[[[[[NeedAddUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:self] where:@"userType" equals:@(type).stringValue] where:@"friendship" equals:@"1"] orderBy:@"pinyin" ascending:YES] results];
    
    //获取按照首字母排序的，其他联系人
    NSArray *otherUserArray = [[[[[[NeedAddUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:self] where:@"userType" equals:@(type).stringValue] where:@"friendship" equals:@"0"] orderBy:@"pinyin" ascending:YES] results];
    
    //排序
    NSMutableArray *arrayForArrays = [NSMutableArray array];
//    NSMutableArray *headerKeys = [NSMutableArray array];
//    BOOL checkValueAtIndex = NO;
//    NSMutableArray *tempFroGroup = nil;
//    
//    NSMutableArray *allUserArray = [NSMutableArray arrayWithArray:otherUserArray];
//    //按照拼音首字母对这些Strings进行排序
//    for (int i = 0; i < allUserArray.count; i++) {
//        NeedAddUser *needUser = allUserArray[i];
//        //监测数组中是否包含该首字母，没有创建
//        if (![headerKeys containsObject:needUser.pinyin]) {
//            [headerKeys addObject:needUser.pinyin];
//            tempFroGroup = [NSMutableArray array];
//            checkValueAtIndex = NO;
//        }
//        
//        //有就把数据添加进去
//        if ([headerKeys containsObject:needUser.pinyin]) {
//            [tempFroGroup addObject:needUser];
//            if (checkValueAtIndex == NO) {
//                [arrayForArrays addObject:tempFroGroup];
//                checkValueAtIndex = YES;
//            }
//        }
//    }
//    NSArray *sortedCitys = @[headerKeys,arrayForArrays];
    [arrayForArrays addObjectsFromArray:systemNoFriendArray];
    [arrayForArrays addObjectsFromArray:systemFriendArray];
    [arrayForArrays addObjectsFromArray:otherUserArray];
    return arrayForArrays;
}

//获取正在聊天的好友列表
- (NSArray *)chatUsers
{
    return [[[[[MyFriendUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:self] where:@"isChatNow" isTrue:YES] orderBy:@"lastChatTime" ascending:NO] results];
}

//获取新的好友列表
- (NSArray *)allMyNewFriends
{
    return [[[[NewFriendUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:self] orderBy:@"created" ascending:NO] results];
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

//更新所有新的好友中，待验证的状态为添加状态
- (void)updateAllNewFriendsOperateStatus
{
    NSArray *waitNewFriends = [[[[NewFriendUser queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:self] where:@"operateType" equals:@"3"] results];
    for (NewFriendUser *newFriendUser in waitNewFriends) {
        [newFriendUser updateOperateType:0];
    }
}

@end
