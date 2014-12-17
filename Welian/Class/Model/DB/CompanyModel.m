//
//  CompanyModel.m
//  Welian
//
//  Created by dong on 14/12/16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "CompanyModel.h"
#import "ICompanyResult.h"

@implementation CompanyModel

@dynamic companyid;
@dynamic companyname;
@dynamic jobid;
@dynamic jobname;
@dynamic ucid;


//创建新收据
+ (void)createCompanyModel:(ICompanyResult *)iCompany
{
    CompanyModel *company = [self getCompanyModelWithUcid:iCompany.ucid];
    if (!company) {

        company = [CompanyModel create];
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
    
    [MOC save];
}

//通过ucid查询
+ (CompanyModel *)getCompanyModelWithUcid:(NSNumber*)ucid
{
    CompanyModel *company = [[[[CompanyModel queryInManagedObjectContext:MOC] where:@"ucid" equals:ucid.stringValue] results] firstObject];
    return company;
}

// 查询所有数据并返回
+ (NSArray *)allCompanyModels
{
    return [[CompanyModel queryInManagedObjectContext:MOC] results];
}


@end
