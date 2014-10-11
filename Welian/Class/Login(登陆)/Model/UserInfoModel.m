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
    [encoder encodeObject:_email forKey:@"_userEmail"];
    [encoder encodeObject:_avatar forKey:@"_userIcon"];
    [encoder encodeObject:_position forKey:@"_userJob"];
    [encoder encodeObject:_company forKey:@"_userIncName"];
    [encoder encodeObject:_cityname forKey:@"_cityname"];
    [encoder encodeObject:_provicename forKey:@"_provicename"];
    [encoder encodeObject:_checkcode forKey:@"_checkcode"];
    [encoder encodeObject:_sessionid forKey:@"_sessionId"];
    [encoder encodeObject:_cityid forKey:@"_cityid"];
    [encoder encodeObject:_uid forKey:@"_uid"];
    [encoder encodeObject:_provinceid forKey:@"_provinceid"];
    [encoder encodeObject:_investorauth forKey:@"_investorauth"];
    [encoder encodeObject:_startupauth forKey:@"_startupauth"];
    [encoder encodeObject:_friendship forKey:@"_friendship"];
    [encoder encodeObject:_shareurl forKey:@"_shareurl"];
    [encoder encodeObject:_address forKey:@"_address"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"_userName"];
        self.mobile = [aDecoder decodeObjectForKey:@"_userPhone"];
        self.email = [aDecoder decodeObjectForKey:@"_userEmail"];
        self.avatar = [aDecoder decodeObjectForKey:@"_userIcon"];
        self.company = [aDecoder decodeObjectForKey:@"_userIncName"];
        self.position = [aDecoder decodeObjectForKey:@"_userJob"];
        self.cityname = [aDecoder decodeObjectForKey:@"_cityname"];
        self.provicename = [aDecoder decodeObjectForKey:@"_provicename"];
        self.checkcode = [aDecoder decodeObjectForKey:@"_checkcode"];
        self.sessionid = [aDecoder decodeObjectForKey:@"_sessionId"];
        self.cityid = [aDecoder decodeObjectForKey:@"_cityid"];
        self.uid = [aDecoder decodeObjectForKey:@"_uid"];
        self.provinceid = [aDecoder decodeObjectForKey:@"_provinceid"];
        self.investorauth = [aDecoder decodeObjectForKey:@"_investorauth"];
        self.startupauth = [aDecoder decodeObjectForKey:@"_startupauth"];
        self.friendship = [aDecoder decodeObjectForKey:@"_friendship"];
        self.shareurl = [aDecoder decodeObjectForKey:@"_shareurl"];
        self.address = [aDecoder decodeObjectForKey:@"_address"];
    }
    return self;
}

@end
