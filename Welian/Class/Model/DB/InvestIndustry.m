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
@dynamic rsProjectDetailInfo;

//创建新收据
+ (InvestIndustry *)createInvestIndustry:(IInvestIndustryModel *)investIndustry
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    InvestIndustry *investitem = [loginUser getInvestIndustryWithName:investIndustry.industryname];
    if (!investitem) {
        investitem = [InvestIndustry MR_createEntityInContext:loginUser.managedObjectContext];
    }
    investitem.industryid = investIndustry.industryid;
    investitem.industryname = investIndustry.industryname;
    
    [loginUser addRsInvestIndustrysObject:investitem];
    [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
    return investitem;
}

// //通过item查询
//+ (InvestIndustry *)getInvestIndustryWithName:(NSString *)name
//{
//    InvestIndustry *investIndustry = [[[[[InvestIndustry queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"industryname" equals:name] results] firstObject];
//    return investIndustry;
//}


@end
