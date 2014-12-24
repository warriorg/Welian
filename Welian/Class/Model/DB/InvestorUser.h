//
//  InvestorUser.h
//  Welian
//
//  Created by dong on 14/12/18.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseUser.h"
@class InvestorUserM;

@interface InvestorUser : BaseUser

@property (nonatomic, retain) NSString * items;

// 查询所有数据并返回
+ (NSArray *)allInvestorUsers;

//创建新收据
+ (void)createInvestor:(InvestorUserM *)iInvestor;

//通过uid查询
+ (InvestorUser *)getInvestorUserWithUcid:(NSNumber*)uid;

@end
