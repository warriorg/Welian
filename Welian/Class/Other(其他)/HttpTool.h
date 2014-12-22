//
//  HttpTool.h
//  Welian
//
//  Created by dong on 14-9-19.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef void (^HttpSuccessBlock)(id JSON);
typedef void (^HttpFailureBlock)(NSError *error);

@interface HttpTool : AFHTTPRequestOperationManager

+ (HttpTool *)sharedService;

#pragma mark - POST请求
- (void)reqestParameters:(NSDictionary *)parameterDic successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock withHUD:(BOOL)isHUD andDim:(BOOL)isDim;


#pragma mark - 带SessIDPOST请求
- (void)reqestWithSessIDParameters:(NSDictionary *)parameterDic successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock withHUD:(BOOL)isHUD andDim:(BOOL)isDim;


#pragma mark - Get请求
- (void)reqestGetWithPath:(NSString *)path successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock withHUD:(BOOL)isHUD andDim:(BOOL)isDim;

@end
