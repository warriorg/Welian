//
//  ProjectBaseModel.h
//  Welian
//
//  Created by dong on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface ProjectBaseModel : IFBase

//**项目名称*//
@property (nonatomic, strong) NSString *name;
//**项目id*//
@property (nonatomic, strong) NSNumber *pid;
//**项目简介 一句话*//
@property (nonatomic, strong) NSString *intro;
//**项目领域*//
@property (nonatomic, strong) NSArray *industry;

@property (nonatomic, strong) NSArray *industryName;

@end
