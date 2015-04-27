//
//  ILoginUserModel.h
//  Welian
//
//  Created by weLian on 15/4/22.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IBaseUserModel.h"

@interface ILoginUserModel : IBaseUserModel

@property (nonatomic, strong) NSString *mobile; //用户手机号
@property (nonatomic, strong) NSString *email;//用户邮箱
@property (nonatomic, strong) NSNumber *provinceid;//省id
@property (nonatomic, strong) NSString *provincename;//省份名称
@property (nonatomic, strong) NSString *address;//地址
@property (nonatomic, strong) NSNumber *cityid;//城市id
@property (nonatomic, strong) NSString *cityname;//城市名称
@property (nonatomic, strong) NSString *shareurl;//对外分享url
@property (nonatomic, strong) NSString *inviteurl;//邀请url
@property (nonatomic, strong) NSNumber *friendcount;//好友数量
@property (nonatomic, strong) NSNumber *feedcount;// 动态数量
@property (nonatomic, strong) NSNumber *friend2count;// 二度好友 数量
@property (nonatomic, strong) NSNumber *samefriendscount; // 共同好友数量  取自己信息的时候没有

//@property (nonatomic, strong) NSNumber *flag;//标记是否第一次登录

@end

/*
 data =     {
 avatar = "http://img.welian.com/1418619525311-200-200_x.jpg";
 company = "\U676d\U5dde\U4f20\U9001\U95e8\U7f51\U7edc\U6280\U672f\U6709\U9650\U516c\U53f8";
 friendship = "-1";
 investorauth = 0;
 inviteurl = "http://my.welian.com/invite/i/y4K3Wo9v42w=";
 mobile = 15869043065;
 name = "\U5218\U6b66";
 position = "iOS\U9ad8\U7ea7\U5f00\U53d1\U5de5\U7a0b\U5e08";
 shareurl = "http://my.welian.com/card/i/y4K3Wo9v42w=";
 startupauth = 0;
 uid = 11078;
 };
 sessionid = 37dfb467067b8c24537e3d5256e8c08b;
 state = 1000;
 */

/*
 {"data":{"flag":0},"state":3000,"errorcode":"微信账号没有登陆过"}
 */
