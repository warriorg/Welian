//
//  IFriend2InfoModel.m
//  Welian
//
//  Created by weLian on 15/4/28.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFriend2InfoModel.h"

@implementation IFriend2InfoModel

- (void)customOperation:(NSDictionary *)dict
{
    self.samefriends = [IBaseUserM objectsWithInfo:self.samefriends];
}

@end
