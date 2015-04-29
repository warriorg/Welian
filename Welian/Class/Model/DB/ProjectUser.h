//
//  ProjectUser.h
//  Welian
//
//  Created by weLian on 15/2/11.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseUser.h"

@class ProjectDetailInfo, IBaseUserM;

@interface ProjectUser : BaseUser

@property (nonatomic, retain) ProjectDetailInfo *rsProjectDetailInfo;

//创建对象
+ (ProjectUser *)createWithIBaseUserM:(IBaseUserM *)iBaseUserM;
//获取指定uid的对象
+ (ProjectUser *)getBaseUserWith:(NSNumber *)uid;

@end
