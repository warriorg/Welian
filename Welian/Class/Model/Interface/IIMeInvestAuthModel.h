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

@end
