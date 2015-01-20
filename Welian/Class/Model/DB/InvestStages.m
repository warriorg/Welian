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
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    InvestStages *investitem = [loginUser getInvestStagesWithStage:investItemM.stagename];
    if (!investitem) {
        investitem = [InvestStages MR_createEntityInContext:loginUser.managedObjectContext];
    }
    investitem.stagename = investItemM.stagename;
    investitem.stage = investItemM.stage;
    
    [loginUser addRsInvestStagesObject:investitem];
    [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
//    investitem.rsLogInUser = [LogInUser getCurrentLoginUser];
//    [MOC save];
    return investitem;
}

// //通过item查询
//+ (InvestStages *)getInvestStagesWithStage:(NSString *)item
//{
//    InvestStages *investStage = [[[[[InvestStages queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"stagename" equals:item] results] firstObject];
//    return investStage;
//}


@end
