//
//  CompanyModel.m
//  Welian
//
//  Created by dong on 14/12/16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CompanyModel.h"
#import "ICompanyResult.h"
#import "LogInUser.h"

@implementation CompanyModel

@dynamic companyid;
@dynamic companyname;
@dynamic jobid;
@dynamic jobname;
@dynamic ucid;
@dynamic rsLogInUser;

//创建新收据
+ (CompanyModel*)createCompanyModel:(ICompanyResult *)iCompany
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    CompanyModel *company = [loginUser getCompanyModelWithUcid:iCompany.ucid];
    if (!company) {
        company = [CompanyModel MR_createEntityInContext:loginUser.managedObjectContext];
    }
    company.companyname = iCompany.companyname;
    company.companyid = iCompany.companyid;
    company.startmonth = iCompany.startmonth;
    company.startyear = iCompany.startyear;
    company.endyear = iCompany.endyear;
    company.endmonth = iCompany.endmonth;
    company.jobname = iCompany.jobname;
    company.jobid = iCompany.jobid;
    company.ucid = iCompany.ucid;
    
    [loginUser addRsCompanysObject:company];
    [loginUser.managedObjectContext MR_saveToPersistentStoreAndWait];
//    company.rsLogInUser = [LogInUser getCurrentLoginUser];
//    [MOC save];
    return company;

}

//通过ucid查询
//+ (CompanyModel *)getCompanyModelWithUcid:(NSNumber*)ucid
//{
//    CompanyModel *company = [[[[[CompanyModel queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] where:@"ucid" equals:ucid] results] firstObject];
//    
//    return company;
//}

// 查询所有数据并返回
//+ (NSArray *)allCompanyModels
//{
//    return [[[CompanyModel queryInManagedObjectContext:MOC] where:@"rsLogInUser" equals:[LogInUser getCurrentLoginUser]] results];
//}


@end
