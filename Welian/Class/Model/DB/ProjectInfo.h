//
//  ProjectInfo.h
//  Welian
//
//  Created by weLian on 15/2/10.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IProjectInfo ,LogInUser;
@interface ProjectInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * commentcount;//评论数量
@property (nonatomic, retain) NSString * date;//时间
@property (nonatomic, retain) NSString * des;//描述
@property (nonatomic, retain) NSString * industrys;//领域
@property (nonatomic, retain) NSString * intro;//简介
@property (nonatomic, retain) NSNumber * iszan;//是否点赞
@property (nonatomic, retain) NSNumber * membercount;//成员数量
@property (nonatomic, retain) NSString * name;//项目名称
@property (nonatomic, retain) NSNumber * pid;//项目id
@property (nonatomic, retain) NSNumber * status;//// 0 暂不融资   1正在融资
@property (nonatomic, retain) NSNumber * zancount;//点赞数量

@property (nonatomic, retain) NSNumber * type;//0：普通   1：收藏  2：创建
@property (nonatomic, retain) LogInUser * rsLoginUser;

//创建项目
+ (void)createProjectInfoWith:(IProjectInfo *)iProjectInfo withType:(NSNumber *)type;
//获取项目
+ (ProjectInfo *)getProjectInfoWithPid:(NSNumber *)pid Type:(NSNumber *)type;

//删除所有指定类型的对象
+ (void)deleteAllProjectInfoWithType:(NSNumber *)type;
//删除指定类型的单个对象
+ (void)deleteProjectInfoWithType:(NSNumber *)type Pid:(NSNumber *)pid;
//获取所有的普通的项目排序后数据
+ (NSArray *)allNormalProjectInfos;
//获取自己的项目或者自己收藏的
+ (NSArray *)allMyProjectInfoWithType:(NSNumber *)type;

//赞的数量
- (NSString *)displayZancountInfo;

@end
