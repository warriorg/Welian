//
//  IActivityInfo.m
//  Welian
//
//  Created by weLian on 15/3/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IActivityInfo.h"

@implementation IActivityInfo

- (void)customOperation:(NSDictionary *)dict
{
    self.guests = [IBaseUserM objectsWithInfo:self.guests];
    //主办方
    NSArray *sponsorsArray = dict[@"sponsors"];
    //类型
    NSMutableString *types = [NSMutableString string];
    if (sponsorsArray.count > 0) {
        [types appendFormat:@"%@",[[sponsorsArray[0] objectForKey:@"name"] deleteTopAndBottomKonggeAndHuiche]];
        if(sponsorsArray.count > 1){
            for (int i = 1; i < sponsorsArray.count;i++) {
                NSDictionary *industry = sponsorsArray[i];
                [types appendFormat:@" | %@",[[industry objectForKey:@"name"] deleteTopAndBottomKonggeAndHuiche]];
            }
        }
    }else{
        [types appendString:@"未知"];
    }
    self.sponsors = types;
}

@end
