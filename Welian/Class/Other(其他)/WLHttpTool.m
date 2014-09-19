//
//  WLHttpTool.m
//  Welian
//
//  Created by dong on 14-9-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLHttpTool.h"

@implementation WLHttpTool

+ (WLHttpTool*)sharedService
{
    static WLHttpTool *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithHostName:WLHttpServer];
    });
    
    return _sharedClient;
}

- (MKNetworkOperation *)reqestApi:(NSString *)apiStr parameters:(NSDictionary*)parameterDic successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock
{
    MKNetworkOperation *op = [[WLHttpTool sharedService] operationWithPath:apiStr params:parameterDic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [completedOperation responseJSON];
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
    }];
    return op;

}

@end
