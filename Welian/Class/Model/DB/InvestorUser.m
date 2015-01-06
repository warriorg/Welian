//
//  InvestorUser.m
//  Welian
//
//  Created by dong on 14/12/18.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestorUser.h"
#import "InvestorUserM.h"

@implementation InvestorUser

@dynamic items;


// 查询所有数据并返回
+ (NSArray *)allInvestorUsers
{
    return [[InvestorUser queryInManagedObjectContext:MOC] results];
}

//创建新收据
+ (void)createInvestor:(InvestorUserM *)iInvestor
{
    InvestorUser *investM = [self getInvestorUserWithUcid:iInvestor.uid];
    if (!investM) {
        investM = [InvestorUser create];
    }
    investM.uid = iInvestor.uid;
    investM.avatar = iInvestor.avatar;
    investM.name = iInvestor.name;
    investM.address = iInvestor.address;
    investM.cityid = iInvestor.cityid;
    investM.cityname = iInvestor.cityname;
    investM.company = iInvestor.company;
    investM.email = iInvestor.email;
    investM.position = iInvestor.position;
    investM.provinceid = iInvestor.provinceid;
    investM.friendship = iInvestor.friendship;
    investM.investorauth = iInvestor.investorauth;
    investM.inviteurl = iInvestor.inviteurl;
    investM.mobile = iInvestor.mobile;
    investM.startupauth = iInvestor.startupauth;
    investM.provincename = iInvestor.provincename;
    investM.items = iInvestor.items;
    investM.shareurl = iInvestor.shareurl;
    
    [MOC save];
    
}

//通过uid查询
+ (InvestorUser *)getInvestorUserWithUcid:(NSNumber*)uid
{
    InvestorUser *investM = [[[[InvestorUser queryInManagedObjectContext:MOC] where:@"uid" equals:uid] results] firstObject];
    return investM;
}


@end
