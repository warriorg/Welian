//
//  IProjectInfo.m
//  Welian
//
//  Created by weLian on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IProjectInfo.h"
#import "IInvestIndustryModel.h"

@implementation IProjectInfo

- (void)customOperation:(NSDictionary *)dict
{
    self.des = dict[@"description"];
    self.industrys = [IInvestIndustryModel objectsWithInfo:self.industrys];
}

//赞的数量
- (NSString *)displayZancountInfo
{
    if (self.zancount.integerValue < 100) {
        return self.zancount.stringValue;
    }else{
        if (self.zancount.integerValue >= 1000 && self.zancount.integerValue < 10000) {
            return [NSString stringWithFormat:@"%.1fk",self.zancount.floatValue / 1000];
        }else{
            return [NSString stringWithFormat:@"%.1fw",self.zancount.floatValue / 10000];
        }
    }
}

//项目领域
- (NSString *)displayIndustrys
{
    //类型
    NSMutableString *types = [NSMutableString string];
    if (self.industrys.count > 0) {
        [types appendFormat:@"%@",[[self.industrys[0] industryname] deleteTopAndBottomKonggeAndHuiche]];
        if(self.industrys.count > 1){
            for (int i = 1; i < self.industrys.count;i++) {
                IInvestIndustryModel *industry = self.industrys[i];
                [types appendFormat:@" | %@",[industry.industryname deleteTopAndBottomKonggeAndHuiche]];
            }
        }
    }else{
        [types appendString:@"暂无"];
    }
    return types;
}

@end
