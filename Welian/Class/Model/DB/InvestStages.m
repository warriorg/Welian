//
//  InvestStages.m
//  Welian
//
//  Created by dong on 14/12/29.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestStages.h"
#import "LogInUser.h"
#import "IInvestStageModel.h"

@implementation InvestStages

@dynamic stage;
@dynamic stagename;
@dynamic rsLogInUser;

//创建新收据
+ (InvestStages *)createInvestStages:(IInvestStageModel *)investItemM
{
    InvestStages *investitem = [InvestStages getInvestStagesWithStage:investItemM.stagename];
    if (!investitem) {
        investitem = [InvestStages create];
    }
    investitem.stagename = investItemM.stagename;
    investitem.stage = investItemM.stage;
    return investitem;
}

// //通过item查询
+ (InvestStages *)getInvestStagesWithStage:(NSString *)item
{
    InvestStages *investStage = [[[[[InvestStages queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getNowLogInUser]] where:@"uid" equals:item] results] firstObject];
    return investStage;
}


@end
