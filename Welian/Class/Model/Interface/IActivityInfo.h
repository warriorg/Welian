//
//  IActivityInfo.h
//  Welian
//
//  Created by weLian on 15/3/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface IActivityInfo : IFBase

@property (nonatomic,strong) NSNumber *activeid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *logo;
@property (nonatomic,strong) NSString *startime;
@property (nonatomic,strong) NSString *endtime;
@property (nonatomic,strong) NSNumber *status;//0 还没开始，1进行中。2结束
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSNumber *limited;//限制参加人数
@property (nonatomic,strong) NSNumber *joined;//已经报名人数
@property (nonatomic,strong) NSNumber *isjoined;//是否已经报名，0 未报名，1已报名
@property (nonatomic,strong) NSString *intro;//简介
@property (nonatomic,strong) NSNumber *isfavorite;////0 没收藏，1收藏
@property (nonatomic,strong) NSString *shareurl; // 分享url
@property (nonatomic,strong) NSString *url; //详情url
@property (nonatomic,strong) NSNumber *type;//1收费，0免费
@property (nonatomic,strong) NSArray *guests;//嘉宾
@property (nonatomic,strong) NSString *sponsors;//主办方

@end
