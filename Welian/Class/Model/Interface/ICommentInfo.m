//
//  ICommentInfo.m
//  Welian
//
//  Created by weLian on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ICommentInfo.h"

@implementation ICommentInfo

- (void)customOperation:(NSDictionary *)dict
{
    self.user = [IBaseUserM objectWithDict:dict[@"user"]];
    self.touser = [IBaseUserM objectWithDict:dict[@"touser"]];
}

@end
