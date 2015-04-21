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
    NSNumber *state = dict[@"state"];
    self.Success = (state.intValue == 1000) ? @(YES) : @(NO);
    
    if ([self isSuccess]) {
        if ([_errorcode isKindOfClass:[NSNull class]]) {
            self.errorcode = @"无返回错误信息.";
        }else{
            if (!_errorcode.length) self.errorcode = @"无返回错误信息.";
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
    
    NSError *error = [NSError errorWithMsg:_errorcode];
    return error;
}

@end
