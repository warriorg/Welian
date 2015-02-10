//
//  ProjectInfo.h
//  Welian
//
//  Created by weLian on 15/2/10.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IProjectInfo;
@interface ProjectInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * commentcount;//评论数量
@property (nonatomic, retain) NSString * date;//时间
@property (nonatomic, retain) NSString * des;//描述
@property (nonatomic, retain) NSString * industrys;//领域
@property (nonatomic, retain) NSString * intro;//简介
@property (nonatomic, retain) NSNumber * isZan;//是否点赞
@property (nonatomic, retain) NSNumber * membercount;//成员数量
@property (nonatomic, retain) NSString * name;//项目名称
@property (nonatomic, retain) NSNumber * pid;//项目id
@property (nonatomic, retain) NSNumber * status;//// 0 暂不融资   1正在融资
@property (nonatomic, retain) NSNumber * zancount;//点赞数量

//创建项目
+ (void)createProjectInfoWith:(IProjectInfo *)iProjectInfo;

//删除所有的对象
+ (void)deleteAllProjectInfo;
//获取所有的排序后数据
+ (NSArray *)allProjectInfos;

//赞的数量
- (NSString *)displayZancountInfo;

@end
