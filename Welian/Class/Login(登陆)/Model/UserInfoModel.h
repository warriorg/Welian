//
//  UserInfoModel.h
//  Welian
//
//  Created by dong on 14-9-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
/**
 * 用户姓名
 */
@property (nonatomic, strong) NSString *userName;
/**
 *  用户手机号
 */
@property (nonatomic, strong) NSString *userPhone;
/**
 *  用户头像
 */
@property (nonatomic, strong) NSData   *userIcon;
/**
 *  用户公司
 */
@property (nonatomic, strong) NSString *userIncName;
/**
 *  用户职务
 */
@property (nonatomic, strong) NSString *userJob;
/**
 *  用户邮箱
 */
@property (nonatomic, strong) NSString *userEmail;
/**
 *  省
 */
@property (nonatomic, strong) NSString *userProvince;
/**
 *  市
 */
@property (nonatomic, strong) NSString *userCity;


@end
