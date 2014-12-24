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

@class CompanyModel, FriendsFriendUser, MyFriendUser, NewFriendUser, SchoolModel;

@interface LogInUser : BaseUser

@property (nonatomic, retain) NSString * checkcode;
@property (nonatomic, retain) NSString * sessionid;

@property (nonatomic, retain) NSSet *rsCompanys;
@property (nonatomic, retain) NSSet *rsSchools;
@property (nonatomic, retain) NSSet *rsMyFriends;
@property (nonatomic, retain) NSSet *rsFriendsFriends;
@property (nonatomic, retain) NSSet *rsNewFriends;
@end

@interface LogInUser (CoreDataGeneratedAccessors)

//创建新收据
+ (LogInUser *)createLogInUserModel:(UserInfoModel *)userInfoM;

//通过ucid查询
+ (LogInUser *)getLogInUserWithUid:(NSNumber*)uid;

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

@end
