//
//  IBaseUserM.m
//  Welian
//
//  Created by dong on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IBaseUserM.h"

@implementation IBaseUserM

- (void)customOperation:(NSDictionary *)dict
{

}


+ (IBaseUserM *)getLoginUserBaseInfo
{
    LogInUser *meuser = [LogInUser getCurrentLoginUser];
    IBaseUserM *loginUser = [[IBaseUserM alloc] init];
    loginUser.name = meuser.name;
    loginUser.avatar = meuser.avatar;
    loginUser.uid = meuser.uid;
    loginUser.position = meuser.position;
    loginUser.company = meuser.company;
    loginUser.friendship = meuser.firststustid;
    loginUser.investorauth = meuser.investorauth;
    
    return loginUser;
}

@end
