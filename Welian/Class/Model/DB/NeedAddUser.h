//
//  NeedAddUser.h
//  Welian
//
//  Created by weLian on 15/1/9.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseUser.h"

@class LogInUser;

@interface NeedAddUser : BaseUser

//friendship /**  好友关系，1好友，2好友的好友,-1自己，0没关系   */   
@property (nonatomic, retain) NSString * pinyin;
@property (nonatomic, retain) NSString * wlname;
@property (nonatomic, retain) NSNumber * userType;//1：手机好友  2：微信好友
@property (nonatomic, retain) LogInUser *rsLoginUser;

@end
