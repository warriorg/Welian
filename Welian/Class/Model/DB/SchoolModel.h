//
//  SchoolModel.h
//  Welian
//
//  Created by dong on 14/12/16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SchoolCompanyDate.h"
@class ISchoolResult;
@class LogInUser;

@interface SchoolModel : SchoolCompanyDate

/**  专业id   */
@property (nonatomic, retain) NSNumber * specialtyid;
/**  专业名称   */
@property (nonatomic, retain) NSString * specialtyname;
/**  usid   */
@property (nonatomic, retain) NSNumber * usid;
/**  学校名称   */
@property (nonatomic, retain) NSString * schoolname;
/**  学校id   */
@property (nonatomic, retain) NSNumber * schoolid;

@property (nonatomic, retain) LogInUser *rsLogInUser;

// 查询所有数据并返回
+ (NSArray *)allSchoolModels;

//创建新收据
+ (void)createCompanyModel:(ISchoolResult *)iSchool;

//通过ucid查询
+ (SchoolModel *)getCompanyModelWithUcid:(NSNumber*)usid;

@end
