//
//  UserInfoModel.m
//  Welian
//
//  Created by dong on 14-9-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

#pragma mark 归档的时候调用
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_userName forKey:@"_userName"];
    [encoder encodeObject:_userPhone forKey:@"_userPhone"];
    [encoder encodeObject:_userEmail forKey:@"_userEmail"];
    [encoder encodeObject:_userIcon forKey:@"_userIcon"];
    [encoder encodeObject:_userJob forKey:@"_userJob"];
    [encoder encodeObject:_userIncName forKey:@"_userIncName"];
    [encoder encodeObject:_userCity forKey:@"_userCity"];
    [encoder encodeObject:_userProvince forKey:@"_userProvince"];
    [encoder encodeObject:_checkcode forKey:@"_checkcode"];
    [encoder encodeObject:_sessionId forKey:@"_sessionId"];
    [encoder encodeObject:_uid forKey:@"_uid"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userName = [aDecoder decodeObjectForKey:@"_userName"];
        self.userPhone = [aDecoder decodeObjectForKey:@"_userPhone"];
        self.userEmail = [aDecoder decodeObjectForKey:@"_userEmail"];
        self.userIcon = [aDecoder decodeObjectForKey:@"_userIcon"];
        self.userIncName = [aDecoder decodeObjectForKey:@"_userIncName"];
        self.userJob = [aDecoder decodeObjectForKey:@"_userJob"];
        self.userCity = [aDecoder decodeObjectForKey:@"_userCity"];
        self.userProvince = [aDecoder decodeObjectForKey:@"_userProvince"];
        self.checkcode = [aDecoder decodeObjectForKey:@"_checkcode"];
        self.sessionId = [aDecoder decodeObjectForKey:@"_sessionId"];
        self.uid = [aDecoder decodeObjectForKey:@"_uid"];
    }
    return self;
}

@end
