//
//  ProjectDetailInfo.h
//  Welian
//
//  Created by weLian on 15/2/10.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectUser, InvestIndustry, PhotoInfos,IProjectDetailInfo;

@interface ProjectDetailInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * commentcount;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * des;
@property (nonatomic, retain) NSString * financing;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSNumber * isfavorite;
@property (nonatomic, retain) NSNumber * iszan;
@property (nonatomic, retain) NSNumber * membercount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) NSNumber * share;
@property (nonatomic, retain) NSString * shareurl;
@property (nonatomic, retain) NSNumber * stage;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSNumber * zancount;
@property (nonatomic, retain) ProjectUser * rsProjectUser;
@property (nonatomic, retain) NSSet *rsIndustrys;
@property (nonatomic, retain) NSSet *rsPhotoInfos;

//融资阶段
- (NSString *)displayStage;
//赞的数量
- (NSString *)displayZancountInfo;
//项目领域
- (NSString *)displayIndustrys;
//更新点赞数量
- (ProjectDetailInfo *)updateZancount:(NSNumber *)zancount;

//创建记录
+ (ProjectDetailInfo *)createWithIProjectDetailInfo:(IProjectDetailInfo *)iProjectDetailInfo;
//获取指定pid的项目
+ (ProjectDetailInfo *)getProjectDetailInfoWithPid:(NSNumber *)pid;


@end

@interface ProjectDetailInfo (CoreDataGeneratedAccessors)

- (void)addRsIndustrysObject:(InvestIndustry *)value;
- (void)removeRsIndustrysObject:(InvestIndustry *)value;
- (void)addRsIndustrys:(NSSet *)values;
- (void)removeRsIndustrys:(NSSet *)values;

- (void)addRsPhotoInfosObject:(PhotoInfos *)value;
- (void)removeRsPhotoInfosObject:(PhotoInfos *)value;
- (void)addRsPhotoInfos:(NSSet *)values;
- (void)removeRsPhotoInfos:(NSSet *)values;

@end
