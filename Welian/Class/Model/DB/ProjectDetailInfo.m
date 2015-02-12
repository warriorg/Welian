//
//  ProjectDetailInfo.m
//  Welian
//
//  Created by weLian on 15/2/10.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectDetailInfo.h"
#import "BaseUser.h"
#import "InvestIndustry.h"
#import "PhotoInfos.h"


@implementation ProjectDetailInfo

@dynamic amount;
@dynamic commentcount;
@dynamic date;
@dynamic des;
@dynamic financing;
@dynamic intro;
@dynamic isfavorite;
@dynamic iszan;
@dynamic membercount;
@dynamic name;
@dynamic pid;
@dynamic share;
@dynamic shareurl;
@dynamic stage;
@dynamic status;
@dynamic website;
@dynamic zancount;
@dynamic rsProjectUser;
@dynamic rsIndustrys;
@dynamic rsPhotoInfos;

//融资阶段 0:种子轮投资  1:天使轮投资  2:pre-A轮投资 3:A轮投资 4:B轮投资  5:C轮投资
- (NSString *)displayStage
{
    NSString *status = @"";
    switch (self.stage.integerValue) {
        case 0:
            status = @"种子轮";
            break;
        case 1:
            status = @"天使轮";
            break;
        case 2:
            status = @"pre-A轮";
            break;
        case 3:
            status = @"A轮";
            break;
        case 4:
            status = @"B轮";
            break;
        case 5:
            status = @"C轮";
            break;
        default:
            break;
    }
    return status;
}

//赞的数量
- (NSString *)displayZancountInfo
{
    if (self.zancount.integerValue < 100) {
        return self.zancount.stringValue;
    }else{
        if (self.zancount.integerValue >= 1000 && self.zancount.integerValue < 10000) {
            return [NSString stringWithFormat:@"%.1fk",self.zancount.floatValue / 1000];
        }else{
            return [NSString stringWithFormat:@"%.1fw",self.zancount.floatValue / 10000];
        }
    }
}

//项目领域
- (NSString *)displayIndustrys
{
    //类型
    NSMutableString *types = [NSMutableString string];
    NSArray *industrys = self.rsIndustrys.allObjects;
    if (industrys.count > 0) {
        [types appendString:[industrys[0] industryname]];
        if(industrys.count > 1){
            for (int i = 1; i < industrys.count;i++) {
                IInvestIndustryModel *industry = industrys[i];
                [types appendFormat:@" | %@",industry.industryname];
            }
        }
    }else{
        [types appendString:@"暂无"];
    }
    return types;
}

//更新点赞数量
- (ProjectDetailInfo *)updateZancount:(NSNumber *)zancount
{
    self.zancount = zancount;
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
    return self;
}

//创建记录
+ (ProjectDetailInfo *)createWithIProjectDetailInfo:(IProjectDetailInfo *)iProjectDetailInfo
{
    ProjectDetailInfo *detailInfo = [ProjectDetailInfo MR_findFirstByAttribute:@"pid" withValue:iProjectDetailInfo.pid];
    if (!detailInfo) {
        detailInfo = [ProjectDetailInfo MR_createEntity];
    }
    detailInfo.amount = iProjectDetailInfo.amount;
    detailInfo.commentcount = iProjectDetailInfo.commentcount;
    detailInfo.date = iProjectDetailInfo.date;
    detailInfo.des = iProjectDetailInfo.des;
    detailInfo.financing = iProjectDetailInfo.financing;
    detailInfo.intro = iProjectDetailInfo.intro;
    detailInfo.isfavorite = iProjectDetailInfo.isfavorite;
    detailInfo.iszan = iProjectDetailInfo.iszan;
    detailInfo.membercount = iProjectDetailInfo.membercount;
    detailInfo.name = iProjectDetailInfo.name;
    detailInfo.pid = iProjectDetailInfo.pid;
    detailInfo.share = iProjectDetailInfo.share;
    detailInfo.shareurl = iProjectDetailInfo.shareurl;
    detailInfo.stage = iProjectDetailInfo.stage;
    detailInfo.status = iProjectDetailInfo.status;
    detailInfo.website = iProjectDetailInfo.website;
    detailInfo.zancount = iProjectDetailInfo.zancount;
    //设置用户
    ProjectUser *projectUser = [ProjectUser createWithIBaseUserM:iProjectDetailInfo.user];
    detailInfo.rsProjectUser = projectUser;
    
    //设置领域
    if (detailInfo.rsIndustrys.count > 0) {
        [detailInfo removeRsIndustrys:detailInfo.rsIndustrys];
    }
    for (IInvestIndustryModel *investIndustryModel in iProjectDetailInfo.industrys) {
        InvestIndustry *investIndustry = [InvestIndustry createInvestIndustryWith:investIndustryModel];
        [detailInfo addRsIndustrysObject:investIndustry];
    }
    
    //先删除
    if (detailInfo.rsIndustrys.count > 0) {
        [detailInfo removeRsPhotoInfos:detailInfo.rsPhotoInfos];
    }
    //设置照片信息
    for (IPhotoInfo *iPhotoInfo in iProjectDetailInfo.photos) {
        PhotoInfos *photoInfo = [PhotoInfos createWithPhoto:iPhotoInfo];
        [detailInfo addRsPhotoInfosObject:photoInfo];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return detailInfo;
}

//获取指定pid的项目
+ (ProjectDetailInfo *)getProjectDetailInfoWithPid:(NSNumber *)pid
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"pid",pid];
    ProjectDetailInfo *detailInfo = [ProjectDetailInfo MR_findFirstWithPredicate:pre];
    return detailInfo;
}

@end
