//
//  IBaseUserM.h
//  Welian
//
//  Created by dong on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface IBaseUserM : IFBase

/**  对外分享url   */
@property (nonatomic, strong) NSString *shareurl;

/**  投资者认证  0 默认状态  1  认证成功  -2 正在审核  -1 认证失败 */
@property (nonatomic, strong) NSNumber *investorauth;

/**  创业者认证   */
@property (nonatomic, strong) NSNumber *startupauth;

/**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
@property (nonatomic, strong) NSNumber *friendship;

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
@property (nonatomic, strong) NSString *email;

/**省id*/
@property (nonatomic, strong) NSNumber *provinceid;

/**  省份名称   */
@property (nonatomic, strong) NSString *provincename;

/**  地址   */
@property (nonatomic, strong) NSString *address;

/**  城市id*/
@property (nonatomic, strong) NSNumber *cityid;

/**  城市名称   */
@property (nonatomic, strong) NSString *cityname;

/**  uid唯一标示   */
@property (nonatomic, strong) NSNumber *uid;

/**  邀请url   */
@property (nonatomic, strong) NSString *inviteurl;

@end
