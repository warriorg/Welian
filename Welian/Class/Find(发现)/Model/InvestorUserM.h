//
//  InvestorUserM.h
//  weLian
//
//  Created by dong on 14-10-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvestorUserM : NSObject

/**  姓名   */
@property (nonatomic, strong) NSString *name;

/**  uid   */
@property (nonatomic, strong) NSNumber *uid;

/**  公司   */
@property (nonatomic, strong) NSString *company;

/**  职务   */
@property (nonatomic, strong) NSString *position;

/**  头像路径   */
@property (nonatomic, strong) NSString *avatar;

/**  投资案例 列表  用 , 分开   */
@property (nonatomic, strong) NSString *items;

/**  省份   */
@property (nonatomic, strong) NSString *provincename;

/**  城市   */
@property (nonatomic, strong) NSString *cityname;

/**  <#Description#>   */
@property (nonatomic, strong) NSString *startupauth;


/**  <#Description#>   */
@property (nonatomic, strong) NSString *investorauth;

/**  <#Description#>   */
@property (nonatomic, strong) NSString *friendship;


@end
