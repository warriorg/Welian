//
//  FeedAndZanModel.h
//  weLian
//
//  Created by dong on 14/11/13.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedAndZanFrameM.h"

@interface FeedAndZanModel : NSObject

/**  时间   */
@property (nonatomic, strong) NSString *created;

/**  fcid   */
@property (nonatomic, strong) NSString *fcid;

/**  用户信息   */
@property (nonatomic, strong) UserInfoModel *user;

@end
