//
//  InvestIndustry.h
//  Welian
//
//  Created by dong on 14/12/29.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LogInUser, IInvestIndustryModel,ProjectDetailInfo;

@interface InvestIndustry : NSManagedObject

@property (nonatomic, retain) NSString * industryname;
@property (nonatomic, retain) NSNumber * industryid;
@property (nonatomic, retain) LogInUser *rsLogInUser;
@property (nonatomic, retain) ProjectDetailInfo *rsProjectDetailInfo;

//创建新收据
+ (InvestIndustry *)createInvestIndustry:(IInvestIndustryModel *)investIndustry;
//创建普通领域
+ (InvestIndustry *)createInvestIndustryWith:(IInvestIndustryModel *)investIndustry;

// //通过item查询
//+ (InvestIndustry *)getInvestIndustryWithName:(NSString *)name;

@end
