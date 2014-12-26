//
//  LoginUserModel.h
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IBaseUserM.h"

@interface LoginUserModel : IBaseUserM

/**  密码 验证码   */
@property (nonatomic, strong) NSString *checkcode;

/**  sessionId   */
@property (nonatomic, strong) NSString *sessionid;

@end
