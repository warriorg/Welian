//
//  IProjectDetailInfo.m
//  Welian
//
//  Created by weLian on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IProjectDetailInfo.h"
#import "ICommentInfo.h"
#import "IInvestIndustryModel.h"
#import "IPhotoInfo.h"

@implementation IProjectDetailInfo

- (void)customOperation:(NSDictionary *)dict
{
    self.des = dict[@"description"];
    self.user = [IBaseUserM objectWithDict:dict[@"user"]];
    self.photos = [IPhotoInfo objectsWithInfo:self.photos];
    self.industrys = [IInvestIndustryModel objectsWithInfo:self.industrys];
    self.comments = [ICommentInfo objectsWithInfo:self.comments];
    self.zanusers = [IBaseUserM objectsWithInfo:self.zanusers];
}

//融资阶段 0:种子轮投资  1:天使轮投资  2:pre-A轮投资 3:A轮投资 4:B轮投资  5:C轮投资
- (NSString *)displayStage
{
    NSString *status = @"";
    switch (self.stage.integerValue) {
        case 0:
            status = @"种子轮";
            break;
        case 1:
            status = @"天使轮";
            break;
        case 2:
            status = @"pre-A轮";
            break;
        case 3:
            status = @"A轮";
            break;
        case 4:
            status = @"B轮";
            break;
        case 5:
            status = @"C轮";
            break;
        default:
            break;
    }
    return status;
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

// 取领域id
- (NSArray *)getindustrysID
{
    NSMutableArray *industIDArray = [NSMutableArray array];
    for (IInvestIndustryModel *industM in self.industrys) {
        [industIDArray addObject:industM.industryid];
    }
    return industIDArray;
}
// 取领域name
- (NSArray *)getindustrysName
{
    NSMutableArray *industIDArray = [NSMutableArray array];
    for (IInvestIndustryModel *industM in self.industrys) {
        [industIDArray addObject:industM.industryname];
    }
    return industIDArray;
}

@end
