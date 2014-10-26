//
//  InvestAuthModel.h
//  weLian
//
//  Created by dong on 14-10-9.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    InvestAuthTypeNone      = 0,        // 默认
    InvestAuthTypeInvestor  = 1,   // 认证
    InvestAuthTypeRefused   = -1,  // 不通过
    InvestAuthTypeIng       = -2      // 审核中。。。
} InvestAuthType;


@interface InvestAuthModel : NSObject
///*  认证图片 */
@property (nonatomic, strong) NSString *url;
///*  投资案例 */
@property (nonatomic, strong) NSArray *itemsArray;

@property (nonatomic, strong) NSString *items;
///*  审核进度 */
@property (nonatomic, assign) InvestAuthType auth;
@end
