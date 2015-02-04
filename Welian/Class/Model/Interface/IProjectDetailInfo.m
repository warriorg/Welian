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

@end
