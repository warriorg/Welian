//
//  SchoolModel.m
//  Welian
//
//  Created by dong on 14/12/16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "SchoolModel.h"
#import "ISchoolResult.h"
#import "LogInUser.h"

@implementation SchoolModel

@dynamic specialtyid;
@dynamic specialtyname;
@dynamic usid;
@dynamic schoolname;
@dynamic schoolid;
@dynamic rsLogInUser;

// 查询所有数据并返回
+ (NSArray *)allSchoolModels
{
//    return [[SchoolModel queryInManagedObjectContext:MOC] results];
    return [SchoolModel MR_findAll];
}

//创建新收据
+ (SchoolModel *)createCompanyModel:(ISchoolResult *)iSchool
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    SchoolModel *schoolM = [loginUser getSchoolModelWithUcid:iSchool.usid];
    if (!schoolM) {
        schoolM = [SchoolModel MR_createEntityInContext:loginUser.managedObjectContext];
    }
    schoolM.schoolname = iSchool.schoolname;
    schoolM.schoolid = iSchool.schoolid;
    schoolM.startmonth = iSchool.startmonth;
    schoolM.startyear = iSchool.startyear;
    schoolM.endyear = iSchool.endyear;
    schoolM.endmonth = iSchool.endmonth;
    schoolM.specialtyname = iSchool.specialtyname;
    schoolM.specialtyid = iSchool.specialtyid;
    schoolM.usid = iSchool.usid;
    
    [loginUser addRsSchoolsObject:schoolM];
    [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
    
//    schoolM.rsLogInUser = [LogInUser getCurrentLoginUser];
//    [MOC save];
    return schoolM;
}

//通过ucid查询
//+ (SchoolModel *)getCompanyModelWithUcid:(NSNumber*)usid
//{
//    SchoolModel *schoolM = [[[[[SchoolModel queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"usid" equals:usid] results] firstObject];
//    
//    return schoolM;
//}


@end
