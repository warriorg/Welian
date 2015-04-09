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

//案例
- (NSString *)displayInvestItems
{
    //类型
    NSMutableString *types = [NSMutableString string];
    self.items = [self.items sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 itemid] integerValue] > [[obj2 itemid] integerValue];
    }];
    if (self.items.count > 0) {
        [types appendFormat:@"%@",[[(InvestItemM *)self.items[0] item] deleteTopAndBottomKonggeAndHuiche]];
        if(self.items.count > 1){
            for (int i = 1; i < self.items.count;i++) {
                InvestItemM *industry = self.items[i];
                [types appendFormat:@" | %@",[industry.item deleteTopAndBottomKonggeAndHuiche]];
            }
        }
    }else{
        [types appendString:@""];
    }
    return types;
}

//领域
- (NSString *)displayInvestIndustrys
{
    //类型
    NSMutableString *types = [NSMutableString string];
    self.industry = [self.industry sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 industryid] integerValue] > [[obj2 industryid] integerValue];
    }];
    if (self.industry.count > 0) {
        [types appendFormat:@"%@",[[self.industry[0] industryname] deleteTopAndBottomKonggeAndHuiche]];
        if(self.industry.count > 1){
            for (int i = 1; i < self.industry.count;i++) {
                IInvestIndustryModel *industry = self.industry[i];
                [types appendFormat:@" | %@",[industry.industryname deleteTopAndBottomKonggeAndHuiche]];
            }
        }
    }else{
        [types appendString:@""];
    }
    return types;
}

//阶段
- (NSString *)displayInvestStages
{
    //类型
    NSMutableString *types = [NSMutableString string];
    self.stages = [self.stages sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 stage] integerValue] > [[obj2 stage] integerValue];
    }];
    if (self.stages.count > 0) {
        [types appendFormat:@"%@",[[self.stages[0] stagename] deleteTopAndBottomKonggeAndHuiche]];
        if(self.stages.count > 1){
            for (int i = 1; i < self.stages.count;i++) {
                IInvestStageModel *industry = self.stages[i];
                [types appendFormat:@" | %@",[industry.stagename deleteTopAndBottomKonggeAndHuiche]];
            }
        }
    }else{
        [types appendString:@""];
    }
    return types;
}

@end
