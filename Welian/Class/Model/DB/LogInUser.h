//
//  LogInUser.h
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseUser.h"
#import "UserInfoModel.h"

@class CompanyModel, FriendsFriendUser, MyFriendUser, NewFriendUser, SchoolModel, HomeMessage, InvestStages, InvestIndustry, InvestItems, NeedAddUser;

@interface LogInUser : BaseUser

@property (nonatomic, retain) NSNumber * isNow;
@property (nonatomic, retain) NSString * checkcode;
@property (nonatomic, retain) NSString * sessionid;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * auth;
@property (nonatomic, retain) NSString * openid;
@property (nonatomic, retain) NSString * unionid;

@property (nonatomic, retain) NSSet *rsCompanys;
@property (nonatomic, retain) NSSet *rsSchools;
@property (nonatomic, retain) NSSet *rsMyFriends;
@property (nonatomic, retain) NSSet *rsFriendsFriends;
@property (nonatomic, retain) NSSet *rsNewFriends;
@property (nonatomic, retain) NSSet *rsHomeMessages;

@property (nonatomic, retain) NSSet *rsInvestStages;
@property (nonatomic, retain) NSSet *rsInvestItems;
@property (nonatomic, retain) NSSet *rsInvestIndustrys;
@property (nonatomic, retain) NSSet *rsNeedAddUsers;


//获取当前登陆的账户
+ (LogInUser *)getCurrentLoginUser;

//<-------------------------------->

//创建新收据
+ (LogInUser *)createLogInUserModel:(UserInfoModel *)userInfoM;

//通过ucid查询
+ (LogInUser *)getLogInUserWithUid:(NSNumber*)uid;

//获取正在聊天的好友列表
- (NSArray *)chatUsers;
//获取新的好友列表
- (NSArray *)allMyNewFriends;

//所有未读取的聊天消息数量
- (NSInteger)allUnReadChatMessageNum;

//更新所有新的好友中，待验证的状态为添加状态
- (void)updateAllNewFriendsOperateStatus;
//更新所有添加好友中，待验证的状态为添加状态
- (void)updateAllNeedAddFriendOperateStatus;

//---------------------  我的好友  MyFriendUser操作 ---------------------/
// //通过uid查询
- (MyFriendUser *)getMyfriendUserWithUid:(NSNumber *)uid;
// 所有好友
- (NSArray *)getAllMyFriendUsers;


//---------------------- SchoolModel ------------
//通过ucid查询
- (SchoolModel *)getSchoolModelWithUcid:(NSNumber*)usid;

//---------------------- CompanyModel ------------
//通过ucid查询
- (CompanyModel *)getCompanyModelWithUcid:(NSNumber*)ucid;
// 查询所有数据并返回
- (NSArray *)allCompanyModels;

//---------------------- NewFriendUser -------
- (NewFriendUser *)getNewFriendUserWithUid:(NSNumber *)uid;


//---------------------HomeMessage----------
// //通过commentid查询
- (HomeMessage *)getHomeMessageWithUid:(NSNumber *)commentid;
// 获取未读消息
- (NSArray *)getIsLookNotMessages;
// 获取全部消息
- (NSArray *)getAllMessages;

//--------------------InvestIndustry-----------
// //通过item查询
- (InvestIndustry *)getInvestIndustryWithName:(NSString *)name;

//--------------------InvestStages-------------
// //通过item查询
- (InvestStages *)getInvestStagesWithStage:(NSString *)item;

//--------------------InvestItems--------------
// 获取全部消息
- (NSArray *)getAllInvestItems;
// //通过item查询
- (InvestItems *)getInvestItemsWithItem:(NSString *)item;


//--------------------NeedAddUser---------------
//获取已经存在的好友对象
- (NeedAddUser *)getNeedAddUserWithUid:(NSNumber *)uid;
//获取已经存在的好友对象
- (NeedAddUser *)getNeedAddUserWithMobile:(NSString *)mobile;





// 首页动态第一个id
@property (nonatomic, retain) NSNumber * firststustid;
// 首页动态更新个数
@property (nonatomic, retain) NSNumber * newstustcount;
// 首页消息个数
@property (nonatomic, retain) NSNumber * homemessagebadge;
// 所有投资人个数
@property (nonatomic, retain) NSNumber * investorcount;
// 是否有新的活动
@property (nonatomic, retain) NSNumber * isactivebadge;
// 投资人认证状态更新
@property (nonatomic, retain) NSNumber * isinvestorbadge;
// 新好友请求个数
@property (nonatomic, retain) NSNumber * newfriendbadge;
// 发现模块 活动个数
@property (nonatomic, retain) NSNumber * activecount;

+ (void)setUserFirststustid:(NSNumber *)firststustid;
+ (void)setUserNewstustcount:(NSNumber *)newstustcount;
+ (void)setUserHomemessagebadge:(NSNumber *)homemessagebadge;
+ (void)setUserInvestorcount:(NSNumber *)investorcount;
+ (void)setUserActivecount:(NSNumber *)activecount;
+ (void)setUserIsactivebadge:(BOOL)isactivebadge;
+ (void)setUserIsinvestorbadge:(BOOL)isinvestorbadge;
+ (void)setUserNewfriendbadge:(NSNumber *)newfriendbadge;



+ (void)setUserUid:(NSNumber *)uid;
+ (void)setUserPosition:(NSString*)position;
+ (void)setUserProvinceid:(NSNumber *)provinceid;
+ (void)setUserProvincename:(NSString *)provincename;
+ (void)setUserCityid:(NSNumber *)cityid;
+ (void)setUserCityname:(NSString *)cityname;
+ (void)setUserFriendship:(NSNumber *)friendship;
+ (void)setUserShareurl:(NSString *)shareurl;
+ (void)setUserAvatar:(NSString *)avatar;
+ (void)setUserName:(NSString *)name;
+ (void)setUserAddress:(NSString *)address;
+ (void)setUserEmail:(NSString *)email;
+ (void)setUserinvestorauth:(NSNumber *)investorauth;
+ (void)setUserstartupauth:(NSNumber *)startupauth;
+ (void)setUsercompany:(NSString *)company;
+ (void)setUsercheckcode:(NSString *)checkcode;
+ (void)setUserSessionid:(NSString *)sessionid;
+ (void)setUserisNow:(BOOL)isnow;
+ (void)setUserUrl:(NSString *)url;
+ (void)setUseropenid:(NSString *)openid;
+ (void)setUserunionid:(NSString *)unionid;

@end

@interface LogInUser (CoreDataGeneratedAccessors)

- (void)addRsCompanysObject:(CompanyModel *)value;
- (void)removeRsCompanysObject:(CompanyModel *)value;
- (void)addRsCompanys:(NSSet *)values;
- (void)removeRsCompanys:(NSSet *)values;

- (void)addRsSchoolsObject:(SchoolModel *)value;
- (void)removeRsSchoolsObject:(SchoolModel *)value;
- (void)addRsSchools:(NSSet *)values;
- (void)removeRsSchools:(NSSet *)values;

- (void)addRsMyFriendsObject:(MyFriendUser *)value;
- (void)removeRsMyFriendsObject:(MyFriendUser *)value;
- (void)addRsMyFriends:(NSSet *)values;
- (void)removeRsMyFriends:(NSSet *)values;

- (void)addRsFriendsFriendsObject:(FriendsFriendUser *)value;
- (void)removeRsFriendsFriendsObject:(FriendsFriendUser *)value;
- (void)addRsFriendsFriends:(NSSet *)values;
- (void)removeRsFriendsFriends:(NSSet *)values;

- (void)addRsNewFriendsObject:(NewFriendUser *)value;
- (void)removeRsNewFriendsObject:(NewFriendUser *)value;
- (void)addRsNewFriends:(NSSet *)values;
- (void)removeRsNewFriends:(NSSet *)values;

- (void)addRsHomeMessagesObject:(HomeMessage *)value;
- (void)removeRsHomeMessagesObject:(HomeMessage *)value;
- (void)addRsHomeMessages:(NSSet *)values;
- (void)removeRsHomeMessages:(NSSet *)values;

- (void)addRsInvestItemsObject:(InvestItems *)value;
- (void)removeRsInvestItemsObject:(InvestItems *)value;
- (void)addRsInvestItems:(NSSet *)values;
- (void)removeRsInvestItems:(NSSet *)values;

- (void)addRsInvestStagesObject:(InvestStages *)value;
- (void)removeRsInvestStagesObject:(InvestStages *)value;
- (void)addRsInvestStages:(NSSet *)values;
- (void)removeRsInvestStages:(NSSet *)values;

- (void)addRsInvestIndustryObject:(InvestIndustry *)value;
- (void)removeRsInvestIndustryObject:(InvestIndustry *)value;
- (void)addRsInvestIndustry:(NSSet *)values;
- (void)removeRsInvestIndustry:(NSSet *)values;

- (void)addRsNeedAddUsersObject:(NeedAddUser *)value;
- (void)removeRsNeedAddUsersObject:(NeedAddUser *)value;
- (void)addRsNeedAddUsers:(NSSet *)values;
- (void)removeRsNeedAddUsers:(NSSet *)values;

@end
