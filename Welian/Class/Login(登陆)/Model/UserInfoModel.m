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
    [encoder encodeObject:_name forKey:@"_userName"];
    [encoder encodeObject:_mobile forKey:@"_userPhone"];
    [encoder encodeObject:_userEmail forKey:@"_userEmail"];
    [encoder encodeObject:_avatar forKey:@"_userIcon"];
    [encoder encodeObject:_position forKey:@"_userJob"];
    [encoder encodeObject:_company forKey:@"_userIncName"];
    [encoder encodeObject:_userCity forKey:@"_userCity"];
    [encoder encodeObject:_userProvince forKey:@"_userProvince"];
    [encoder encodeObject:_checkcode forKey:@"_checkcode"];
    [encoder encodeObject:_sessionid forKey:@"_sessionId"];
    [encoder encodeObject:_uid forKey:@"_uid"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"_userName"];
        self.mobile = [aDecoder decodeObjectForKey:@"_userPhone"];
        self.userEmail = [aDecoder decodeObjectForKey:@"_userEmail"];
        self.avatar = [aDecoder decodeObjectForKey:@"_userIcon"];
        self.company = [aDecoder decodeObjectForKey:@"_userIncName"];
        self.position = [aDecoder decodeObjectForKey:@"_userJob"];
        self.userCity = [aDecoder decodeObjectForKey:@"_userCity"];
        self.userProvince = [aDecoder decodeObjectForKey:@"_userProvince"];
        self.checkcode = [aDecoder decodeObjectForKey:@"_checkcode"];
        self.sessionid = [aDecoder decodeObjectForKey:@"_sessionId"];
        self.uid = [aDecoder decodeObjectForKey:@"_uid"];
    }
    return self;
}

@end
