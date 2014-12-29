//
//  IIMeInvestAuthModel.m
//  Welian
//
//  Created by dong on 14/12/29.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IIMeInvestAuthModel.h"
#import "IInvestStageModel.h"
#import "InvestItemM.h"
#import "IInvestIndustryModel.h"

@implementation IIMeInvestAuthModel

- (void)customOperation:(NSDictionary *)dict
{
    self.stages = [IInvestStageModel objectsWithInfo:self.stages];
    self.items = [InvestItemM objectsWithInfo:self.items];
    self.industry = [IInvestIndustryModel objectsWithInfo:self.industry];
}

@end
