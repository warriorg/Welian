//
//  IBaseUserM.h
//  Welian
//
//  Created by dong on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface IBaseUserM : IFBase

@property (nonatomic, strong) NSNumber *uid;    //uid唯一标示
@property (nonatomic, strong) NSString *name;   //用户姓名
@property (nonatomic, strong) NSString *wlname; //如活动报名列表返回的 微链中的名字
@property (nonatomic, strong) NSString *avatar; //用户头像
@property (nonatomic, strong) NSString *company;//用户公司
@property (nonatomic, strong) NSString *position;//用户职务
@property (nonatomic, strong) NSString *mobile; //用户手机号
@property (nonatomic, strong) NSString *email;//用户邮箱
@property (nonatomic, strong) NSNumber *provinceid;//省id
@property (nonatomic, strong) NSString *provincename;//省份名称
@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, strong) NSNumber *cityid;//城市id
@property (nonatomic, strong) NSString *cityname;//城市名称
@property (nonatomic, strong) NSString *shareurl;//对外分享url
@property (nonatomic, strong) NSString *inviteurl;//邀请url

/**  投资者认证  0 默认状态  1  认证成功  -2 正在审核  -1 认证失败 */
@property (nonatomic, strong) NSNumber *investorauth;
/**  好友关系，1好友，2好友的好友,-1自己，0没关系   */
@property (nonatomic, strong) NSNumber *friendship;
@property (nonatomic, strong) NSNumber *checked;//手机号码是否验证

@property (nonatomic, strong) NSNumber *friendcount;//好友数量
@property (nonatomic, strong) NSNumber *feedcount;// 动态数量
@property (nonatomic, strong) NSNumber *friend2count;// 二度好友 数量
@property (nonatomic, strong) NSNumber *samefriendscount; // 共同好友数量  取自己信息的时候没有

@end
