//
//  InvestorUserM.h
//  weLian
//
//  Created by dong on 14-10-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface InvestorUserM : IFBase

@property (nonatomic, retain) NSString * address;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSNumber * friendship;
@property (nonatomic, strong) NSNumber * investorauth;
@property (nonatomic, strong) NSString * inviteurl;
@property (nonatomic, strong) NSString * mobile;

@property (nonatomic, strong) NSNumber * startupauth;

/**  姓名   */
@property (nonatomic, strong) NSString *name;

/**  uid   */
@property (nonatomic, strong) NSNumber *uid;

/**  公司   */
@property (nonatomic, strong) NSString * company;

/**  职务   */
@property (nonatomic, strong) NSString * position;

/**  头像路径   */
@property (nonatomic, strong) NSString *avatar;

/**  投资案例 列表  用 , 分开   */
@property (nonatomic, strong) NSString *items;

/**  省份   */
@property (nonatomic, strong) NSNumber * provinceid;
@property (nonatomic, strong) NSString * provincename;
/**  城市   */
@property (nonatomic, strong) NSNumber * cityid;
@property (nonatomic, strong) NSString * cityname;

@property (nonatomic, strong) NSString * shareurl;


@end
