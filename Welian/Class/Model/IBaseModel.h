//
//  IBaseModel.h
//  Welian
//
//  Created by weLian on 15/4/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IFBase.h"

@interface IBaseModel : IFBase

@property (strong, nonatomic) NSString *errormsg;//错误信息
@property (strong, nonatomic) NSNumber *state;//状态编码 “state”:1000，1001 没登录，1003，密码错误    2000 系统错误
@property (strong, nonatomic) NSNumber *Success;
@property (strong, nonatomic) NSString *sessionid;
@property (strong, nonatomic) NSDictionary *data;

- (BOOL)isSuccess;
- (NSError *)error;

@end
