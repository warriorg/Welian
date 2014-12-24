//
//  CompanyModel.h
//  Welian
//
//  Created by dong on 14/12/16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SchoolCompanyDate.h"
@class ICompanyResult;
@class LogInUser;

@interface CompanyModel : SchoolCompanyDate

/**  企业id   */
@property (nonatomic, retain) NSNumber * companyid;
/**  企业名称   */
@property (nonatomic, retain) NSString * companyname;
/**  职位id   */
@property (nonatomic, retain) NSNumber * jobid;
/**  职位名称   */
@property (nonatomic, retain) NSString * jobname;
/**  ucid   */
@property (nonatomic, retain) NSNumber * ucid;

@property (nonatomic, retain) LogInUser *rsLogInUser;

// 查询所有数据并返回
+ (NSArray *)allCompanyModels;

//创建新收据
+ (void)createCompanyModel:(ICompanyResult *)iCompany;

//通过ucid查询
+ (CompanyModel *)getCompanyModelWithUcid:(NSNumber*)ucid;

@end
