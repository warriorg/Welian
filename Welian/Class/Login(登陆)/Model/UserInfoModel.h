//
//  UserInfoModel.h
//  Welian
//
//  Created by dong on 14-9-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject <NSCoding>
/**
 * 用户姓名
 */
@property (nonatomic, strong) NSString *name;
/**
 *  用户手机号
 */
@property (nonatomic, strong) NSString *mobile;
/**
 *  用户头像
 */
@property (nonatomic, strong) NSString   *avatar;
/**
 *  用户公司
 */
@property (nonatomic, strong) NSString *company;
/**
 *  用户职务
 */
@property (nonatomic, strong) NSString *position;
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

/**  密码 验证码   */
@property (nonatomic, strong) NSString *checkcode;

/**  sessionId   */
@property (nonatomic, strong) NSString *sessionid;

/**  uid唯一标示   */
@property (nonatomic, strong) NSString *uid;

@end
