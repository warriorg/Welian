//
//  ActivityInfo.h
//  Welian
//
//  Created by weLian on 15/3/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LogInUser,IActivityInfo;

@interface ActivityInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * activeid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * logo;
@property (nonatomic, retain) NSString * startime;
@property (nonatomic, retain) NSString * endtime;
@property (nonatomic, retain) NSNumber * status;//0 还没开始，1进行中。2结束
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * limited;//限制参加人数
@property (nonatomic, retain) NSNumber * joined;//已经报名人数
@property (nonatomic, retain) NSNumber * isjoined;//是否已经报名，0 未报名，1已报名
@property (nonatomic, retain) NSString * intro;//简介
@property (nonatomic, retain) NSNumber * isfavorite;//0 没收藏，1收藏
@property (nonatomic, retain) NSString * shareurl;// 分享url
@property (nonatomic, retain) NSString * url;// 详情url
@property (nonatomic, retain) NSNumber * type;//1收费，0免费
@property (nonatomic, retain) NSString * sponsor;//主办方
@property (nonatomic, retain) NSNumber * activeType; //0：普通   1：收藏  2：我参加的
@property (nonatomic, retain) LogInUser *rsLoginUser;

//创建活动
+ (ActivityInfo *)createActivityInfoWith:(IActivityInfo *)iActivityInfo withType:(NSNumber *)activityType;
//更新活动
+ (ActivityInfo *)updateActivityInfoWith:(IActivityInfo *)iActivityInfo withType:(NSNumber *)activityType;

//获取活动
+ (ActivityInfo *)getActivityInfoWithActiveId:(NSNumber *)activeid Type:(NSNumber *)activityType;

//删除所有指定类型的对象
+ (void)deleteAllActivityInfoWithType:(NSNumber *)type;
//删除指定类型的单个对象
+ (void)deleteActivityInfoWithType:(NSNumber *)type ActiveId:(NSNumber *)activeid;

//获取所有的普通的项目排序后数据
+ (NSArray *)allNormalActivityInfos;
//获取自己的项目或者自己收藏的
+ (NSArray *)allMyActivityInfoWithType:(NSNumber *)activityType;


//更新收藏状态
- (ActivityInfo *)updateFavorite:(NSNumber *)isFavorite;
//更新报名状态
- (ActivityInfo *)updateIsjoined:(NSNumber *)isJoined;
//更新已报名人数
- (ActivityInfo *)updateJoined:(NSNumber *)joined;

//获取活动开始是周几
- (NSString *)displayStartWeekDay;
//获取活动结束是周几
- (NSString *)displayEndWeekDay;
//获取活动时间
- (NSString *)displayStartTimeInfo;

@end
