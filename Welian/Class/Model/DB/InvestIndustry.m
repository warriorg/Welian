//
//  InvestIndustry.m
//  Welian
//
//  Created by dong on 14/12/29.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestIndustry.h"
#import "LogInUser.h"
#import "IInvestIndustryModel.h"

@implementation InvestIndustry

@dynamic industryname;
@dynamic industryid;
@dynamic rsLogInUser;

//创建新收据
+ (InvestIndustry *)createInvestIndustry:(IInvestIndustryModel *)investIndustry
{
    InvestIndustry *investitem = [InvestIndustry getInvestIndustryWithName:investIndustry.industryname];
    if (!investitem) {
        investitem = [InvestIndustry create];
    }
    investitem.industryid = investIndustry.industryid;
    investitem.industryname = investIndustry.industryname;
    investitem.rsLogInUser = [LogInUser getNowLogInUser];
    [MOC save];
    return investitem;
}

// //通过item查询
+ (InvestIndustry *)getInvestIndustryWithName:(NSString *)name
{
    InvestIndustry *investIndustry = [[[[[InvestIndustry queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getNowLogInUser]] where:@"uid" equals:name] results] firstObject];
    return investIndustry;
}


@end
