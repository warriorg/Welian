//
//  CreateProjectModel.h
//  Welian
//
//  Created by dong on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectBaseModel.h"

@interface CreateProjectModel : ProjectBaseModel

//**项目描述*//
@property (nonatomic, strong) NSString *des;
//**项目网址*//
@property (nonatomic, strong) NSString *website;
// 图片
@property (nonatomic, strong) NSArray *photos;
// 成员
@property (nonatomic, strong) NSArray *members;

@end
