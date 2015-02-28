//
//  NeedAddUser.h
//  Welian
//
//  Created by weLian on 15/1/9.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseUser.h"

@class LogInUser;

@interface NeedAddUser : BaseUser

//friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系  4.等待验证 */
@property (nonatomic, retain) NSString * pinyin;
@property (nonatomic, retain) NSString * wlname;
@property (nonatomic, retain) NSNumber * userType;//1：手机好友  2：微信好友
@property (nonatomic, retain) LogInUser * rsLoginUser;

//创建需要添加的好友对象
//+ (void)createNeedAddUserWithInfo:(NSArray *)users withType:(NSInteger)type;

//获取排序后的通讯录联系人
+ (NSMutableArray *)allNeedAddUsersWithType:(NSInteger)type;



//创建需要添加的好友对象
//+ (void)createNeedAddUserWithDict:(NSDictionary *)dict withType:(NSInteger)type;
////获取已经存在的好友对象
//+ (NeedAddUser *)getNeedAddUserWithUid:(NSNumber *)uid;
////获取已经存在的好友对象
//+ (NeedAddUser *)getNeedAddUserWithMobile:(NSString *)mobile;
//获取排序后的通讯录联系人
//+ (NSMutableArray *)allNeedAddUserWithType:(NSInteger)type;

//更新好友关系状态
- (NeedAddUser *)updateFriendShip:(NSInteger)type;

@end
