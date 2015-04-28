//
//  ProjectUser.m
//  Welian
//
//  Created by weLian on 15/2/11.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectUser.h"
#import "ProjectDetailInfo.h"


@implementation ProjectUser

@dynamic rsProjectDetailInfo;

//创建对象
+ (ProjectUser *)createWithIBaseUserM:(IBaseUserM *)iBaseUserM
{
    ProjectUser *baseUser = [self getBaseUserWith:iBaseUserM.uid];
    if (!baseUser) {
        baseUser = [ProjectUser MR_createEntity];
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
//    baseUser.startupauth = iBaseUserM.startupauth;
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
+ (ProjectUser *)getBaseUserWith:(NSNumber *)uid
{
    return [ProjectUser MR_findFirstByAttribute:@"uid" withValue:uid];
}

@end
