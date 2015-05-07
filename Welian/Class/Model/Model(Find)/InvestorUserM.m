//
//  InvestorUserM.m
//  weLian
//
//  Created by dong on 14-10-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestorUserM.h"

@implementation InvestorUserM

- (void)customOperation:(NSDictionary *)dict
{
    NSArray *itemsA = [dict objectForKey:@"items"];
    NSMutableString *itmesStr = [NSMutableString string];
    for (NSInteger i = 0; i<itemsA.count; i++) {
        NSDictionary *itemDic = itemsA[i];
        if (i==itemsA.count-1) {
            [itmesStr appendFormat:@"%@",[itemDic objectForKey:@"item"]];
        }else{
            [itmesStr appendFormat:@"%@，",[itemDic objectForKey:@"item"]];
        }
        
    }
    self.items = [NSString stringWithString:itmesStr];
}


@end
