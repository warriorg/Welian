//
//  BaseUser.h
//  Welian
//
//  Created by dong on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BaseUser : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * friendship;
@property (nonatomic, retain) NSNumber * investorauth;/**  投资者认证  0 默认状态  1  认证成功  -2 正在审核  -1 认证失败 */
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

@end
