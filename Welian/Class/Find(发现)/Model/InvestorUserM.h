//
//  InvestorUserM.h
//  weLian
//
//  Created by dong on 14-10-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "IBaseUserM.h"

@interface InvestorUserM : IBaseUserM

/**  投资案例 列表  用 , 分开   */
@property (nonatomic, strong) NSString *items;

@end
