//
//  CardStatuModel.h
//  Welian
//
//  Created by dong on 15/3/9.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface CardStatuModel : IFBase

@property (nonatomic, strong) NSNumber *cid;
 //3 活动，10项目，11 网页
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *content;

@end
