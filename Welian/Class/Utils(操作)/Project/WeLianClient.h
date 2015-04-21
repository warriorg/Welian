//
//  WeLianClient.h
//  Welian
//
//  Created by weLian on 15/4/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface WeLianClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

@end
