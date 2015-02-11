//
//  BaseUser.h
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectDetailInfo,IBaseUserM;

@interface BaseUser : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * friendship;
@property (nonatomic, retain) NSNumber * investorauth;
@property (nonatomic, retain) NSString * inviteurl;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSNumber * startupauth;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSNumber * provinceid;
@property (nonatomic, retain) NSString * provincename;
@property (nonatomic, retain) NSNumber * cityid;
@property (nonatomic, retain) NSString * cityname;
@property (nonatomic, retain) NSString * shareurl;
@property (nonatomic, retain) ProjectDetailInfo *rsProjectDetailInfo;

//创建对象
+ (BaseUser *)createWithIBaseUserM:(IBaseUserM *)iBaseUserM;
//获取指定uid的对象
+ (BaseUser *)getBaseUserWith:(NSNumber *)uid;

@end
