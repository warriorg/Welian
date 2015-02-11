//
//  ProjectInfo.m
//  Welian
//
//  Created by weLian on 15/2/10.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectInfo.h"


@implementation ProjectInfo

@dynamic commentcount;
@dynamic date;
@dynamic des;
@dynamic industrys;
@dynamic intro;
@dynamic isZan;
@dynamic membercount;
@dynamic name;
@dynamic pid;
@dynamic status;
@dynamic zancount;

//创建项目
+ (void)createProjectInfoWith:(IProjectInfo *)iProjectInfo
{
    ProjectInfo *projectInfo = [ProjectInfo MR_createEntity];
    projectInfo.pid = iProjectInfo.pid;
    projectInfo.name = iProjectInfo.name;
    projectInfo.intro = iProjectInfo.intro;
    projectInfo.des = iProjectInfo.des;
    projectInfo.date = iProjectInfo.date;
    projectInfo.membercount = iProjectInfo.membercount;
    projectInfo.commentcount = iProjectInfo.commentcount;
    projectInfo.status = iProjectInfo.status;
    projectInfo.zancount = iProjectInfo.zancount;
    projectInfo.isZan = iProjectInfo.isZan;
    projectInfo.industrys = [iProjectInfo displayIndustrys];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

//删除所有的对象
+ (void)deleteAllProjectInfo
{
    NSArray *all = [ProjectInfo MR_findAll];
    for (ProjectInfo *projectInfo in all) {
        [projectInfo MR_deleteEntity];
    }
}

//获取所有的排序后数据
+ (NSArray *)allProjectInfos
{
    NSArray *all = [ProjectInfo MR_findAllSortedBy:@"date" ascending:NO];
    //添加数据
    NSMutableArray *headerKeys = [NSMutableArray array];
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    NSMutableArray *tempFroGroup = nil;
    BOOL checkValueAtIndex = NO;
    for (int i = 0; i < all.count; i++) {
        ProjectInfo *project = all[i];
        //监测数组中是否包含当前日期，没有创建
        if (![headerKeys containsObject:project.date]) {
            [headerKeys addObject:project.date];
            tempFroGroup = [NSMutableArray array];
            checkValueAtIndex = NO;
        }
        
        //有就把数据添加进去
        if ([headerKeys containsObject:project.date]) {
            [tempFroGroup addObject:project];
            if (checkValueAtIndex == NO) {
                [arrayForArrays addObject:tempFroGroup];
                checkValueAtIndex = YES;
            }
        }
    }
    NSArray *arrayWithArray = @[headerKeys,arrayForArrays];
    return arrayWithArray;
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

@end
