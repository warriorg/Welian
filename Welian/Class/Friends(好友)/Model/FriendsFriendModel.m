//
//  FriendsFriendModel.m
//  weLian
//
//  Created by dong on 14/10/30.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "FriendsFriendModel.h"
#import "FriendsinfoModel.h"

@implementation FriendsFriendModel

- (NSDictionary *)arrayModelClasses
{
    return @{@"friends" : [FriendsinfoModel class]};
}

@end
