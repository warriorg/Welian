//
//  NewFriendUser.h
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseUser.h"

@class LogInUser, NewFriendModel;

@interface NewFriendUser : BaseUser

@property (nonatomic, retain) NSString * created;
@property (nonatomic, retain) NSNumber * isLook;
@property (nonatomic, retain) NSString * pushType;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSNumber * isAgree;
@property (nonatomic, retain) NSNumber * operateType;//操作类型0：添加 1：接受  2:已添加 3：待验证
@property (nonatomic, retain) LogInUser *rsLogInUser;

//创建新收据
+ (NewFriendUser *)createNewFriendUserModel:(NewFriendModel *)userInfoM;

// //通过uid查询
+ (NewFriendUser *)getNewFriendUserWithUid:(NSNumber *)uid;

//更新操作按钮状态
- (void)updateOperateType:(NSInteger)type;


@end
