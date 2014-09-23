//
//  UserInfoTool.m
//  Welian
//
//  Created by dong on 14-9-21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "UserInfoTool.h"

@implementation UserInfoTool
{
    UserInfoModel *_userInfoM;
}
single_implementation(UserInfoTool)

//- (id)init
//{
//    if (self = [super init]) {
//        _userInfoM = [NSKeyedUnarchiver unarchiveObjectWithFile:kFile];
//    }
//    return self;
//}

- (UserInfoModel*)getUserInfoModel
{
    if (_userInfoM== nil) {
        _userInfoM = [NSKeyedUnarchiver unarchiveObjectWithFile:kFile];
    }
    if (_userInfoM == nil) {
        _userInfoM = [[UserInfoModel alloc] init];
    }
    return _userInfoM;
}

- (void)saveUserInfo:(UserInfoModel *)userInfoM
{
    _userInfoM = userInfoM;
    
    [NSKeyedArchiver archiveRootObject:userInfoM toFile:kFile];
}


@end
