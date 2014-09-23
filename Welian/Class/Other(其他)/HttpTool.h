//
//  HttpTool.h
//  Welian
//
//  Created by dong on 14-9-19.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef void (^HttpSuccessBlock)(NSDictionary *JSON);
typedef void (^HttpFailureBlock)(NSError *error);

@interface HttpTool : AFHTTPRequestOperationManager

+ (HttpTool *)sharedService;

#pragma mark - POST请求
- (void)reqestParameters:(NSDictionary *)parameterDic successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock;


#pragma mark - 带上传图片POST请求
- (void)reqestWithSessIDParameters:(NSDictionary *)parameterDic successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock;

@end
