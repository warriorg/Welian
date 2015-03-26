//
//  IIMeInvestAuthModel.h
//  Welian
//
//  Created by dong on 14/12/29.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface IIMeInvestAuthModel : IFBase
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSNumber *auth;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *industry;
@property (nonatomic, strong) NSArray *stages;

//案例
- (NSString *)displayInvestItems;
//领域
- (NSString *)displayInvestIndustrys;
//阶段
- (NSString *)displayInvestStages;

@end
