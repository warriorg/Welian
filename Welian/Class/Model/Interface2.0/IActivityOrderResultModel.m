//
//  IActivityOrderResultModel.m
//  Welian
//
//  Created by weLian on 15/4/29.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IActivityOrderResultModel.h"

@implementation IActivityOrderResultModel

- (void)customOperation:(NSDictionary *)dict
{
    self.alipay = [IAlipayInfoModel objectWithDict:dict[@"alipay"]];
}

@end
