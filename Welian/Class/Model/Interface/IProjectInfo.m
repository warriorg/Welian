//
//  IProjectInfo.m
//  Welian
//
//  Created by weLian on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IProjectInfo.h"

@implementation IProjectInfo

- (void)customOperation:(NSDictionary *)dict
{
    self.des = dict[@"description"];
}

@end
