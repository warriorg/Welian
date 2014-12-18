//
//  InvestorUser.h
//  Welian
//
//  Created by dong on 14/12/18.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseUser.h"
@class InvestorUserM;

@interface InvestorUser : BaseUser

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * cityid;
@property (nonatomic, retain) NSString * cityname;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * friendship;
@property (nonatomic, retain) NSNumber * investorauth;
@property (nonatomic, retain) NSString * inviteurl;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * provincename;
@property (nonatomic, retain) NSString * shareurl;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSNumber * provinceid;
@property (nonatomic, retain) NSNumber * startupauth;
@property (nonatomic, retain) NSString * items;

// 查询所有数据并返回
+ (NSArray *)allInvestorUsers;

//创建新收据
+ (void)createInvestor:(InvestorUserM *)iInvestor;

//通过uid查询
+ (InvestorUser *)getInvestorUserWithUcid:(NSNumber*)uid;

@end
