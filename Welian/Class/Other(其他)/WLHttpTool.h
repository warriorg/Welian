//
//  WLHttpTool.h
//  Welian
//
//  Created by dong on 14-9-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "MKNetworkEngine.h"

typedef void (^HttpSuccessBlock)(id JSON);
typedef void (^HttpFailureBlock)(NSError *error);

@interface WLHttpTool : MKNetworkEngine

+ (WLHttpTool *)sharedService;

- (MKNetworkOperation *)reqestApi:(NSString *)apiStr parameters:(NSDictionary*)parameterDic successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock;

@end
