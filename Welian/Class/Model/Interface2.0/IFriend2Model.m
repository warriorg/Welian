//
//  IFriend2Model.m
//  Welian
//
//  Created by weLian on 15/4/28.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFriend2Model.h"

@implementation IFriend2Model

- (void)customOperation:(NSDictionary *)dict
{
    self.friendCount = dict[@"count"];
    self.friends = [IFriend2InfoModel objectsWithInfo:self.friends];
}

@end
