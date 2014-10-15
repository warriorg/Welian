//
//  UserInfoTool.h
//  Welian
//
//  Created by dong on 14-9-21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "Singleton.h"

@interface UserInfoTool : NSObject
single_interface(UserInfoTool)

- (void)saveUserInfo:(UserInfoModel*)userInfoM;
- (UserInfoModel*)getUserInfoModel;

@property (nonatomic, strong) UserInfoModel *userInfoM;


@end
