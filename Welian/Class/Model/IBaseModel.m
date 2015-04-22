//
//  IBaseModel.m
//  Welian
//
//  Created by weLian on 15/4/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "IBaseModel.h"

@implementation IBaseModel

- (void)customOperation:(NSDictionary *)dict
{
//    NSNumber *state = dict[@"state"];
    self.Success = (self.state.intValue == 1000) ? @(YES) : @(NO);
    
    if ([self isSuccess]) {
        if ([_errormsg isKindOfClass:[NSNull class]]) {
            self.errormsg = @"无返回错误信息.";
        }else{
            if (!_errormsg.length) self.errormsg = @"无返回错误信息.";
        }
    }
}

- (BOOL)isSuccess
{
    return _Success.boolValue;
}

- (NSError *)error
{
    if (self.isSuccess) {
        return nil;
    }
    
    NSError *error = [NSError errorWithMsg:_errormsg];
    return error;
}

@end
