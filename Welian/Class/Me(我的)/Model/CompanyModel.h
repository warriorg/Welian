//
//  CompanyModel.h
//  Welian
//
//  Created by dong on 14-9-20.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "SchoolCompanyDate.h"

@interface CompanyModel : SchoolCompanyDate
/**  企业id   */
@property (nonatomic, assign) NSInteger companyid;
/**  企业名称   */
@property (nonatomic, strong) NSString *company;

@end
