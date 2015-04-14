//
//  WLUserStatusesResult.m
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLUserStatusesResult.h"
#import "MJExtension.h"
#import "WLStatusM.h"

@implementation WLUserStatusesResult

- (NSDictionary *)arrayModelClasses
{
    return @{@"data": [WLStatusM class]};
}

@end
