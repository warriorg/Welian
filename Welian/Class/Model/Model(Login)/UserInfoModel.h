//
//  UserInfoModel.h
//  Welian
//
//  Created by dong on 14-9-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IBaseUserM.h"

@class LogInUser;

@interface UserInfoModel : IBaseUserM

+ (UserInfoModel *)userinfoWithLoginUser:(LogInUser *)userinf;

/**  密码 验证码   */
@property (nonatomic, strong) NSString *checkcode;

/**  sessionId   */
@property (nonatomic, strong) NSString *sessionid;

@end
