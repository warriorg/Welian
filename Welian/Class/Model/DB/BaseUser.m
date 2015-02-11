//
//  BaseUser.m
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "BaseUser.h"


@implementation BaseUser

@dynamic avatar;
@dynamic name;
@dynamic uid;
@dynamic address;
@dynamic email;
@dynamic friendship;
@dynamic investorauth;
@dynamic inviteurl;
@dynamic mobile;
@dynamic startupauth;
@dynamic company;
@dynamic position;
@dynamic provinceid;
@dynamic provincename;
@dynamic cityid;
@dynamic cityname;
@dynamic shareurl;
@dynamic rsProjectDetailInfo;

//创建对象
+ (BaseUser *)createWithIBaseUserM:(IBaseUserM *)iBaseUserM
{
    BaseUser *baseUser = [self getBaseUserWith:iBaseUserM.uid];
    if (!baseUser) {
        baseUser = [BaseUser MR_createEntity];
    }
    baseUser.avatar = iBaseUserM.avatar;
    baseUser.name = iBaseUserM.name;
    baseUser.uid = iBaseUserM.uid;
    baseUser.address = iBaseUserM.address;
    baseUser.email = iBaseUserM.email;
    baseUser.friendship = iBaseUserM.friendship;
    baseUser.investorauth = iBaseUserM.investorauth;
    baseUser.inviteurl = iBaseUserM.inviteurl;
    baseUser.mobile = iBaseUserM.mobile;
    baseUser.startupauth = iBaseUserM.startupauth;
    baseUser.company = iBaseUserM.company;
    baseUser.position = iBaseUserM.position;
    baseUser.provinceid = iBaseUserM.provinceid;
    baseUser.provincename = iBaseUserM.provincename;
    baseUser.cityid = iBaseUserM.cityid;
    baseUser.cityname = iBaseUserM.cityname;
    baseUser.shareurl = iBaseUserM.shareurl;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return baseUser;
}

//获取指定uid的对象
+ (BaseUser *)getBaseUserWith:(NSNumber *)uid
{
    return [BaseUser MR_findFirstByAttribute:@"uid" withValue:uid];
}

@end
