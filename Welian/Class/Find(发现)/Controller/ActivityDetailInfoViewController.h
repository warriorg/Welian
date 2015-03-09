//
//  ActivityDetailInfoViewController.h
//  Welian
//
//  Created by weLian on 15/2/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BasicViewController.h"

@interface ActivityDetailInfoViewController : BasicViewController

- (instancetype)initWithActivityInfo:(ActivityInfo *)activityInfo;
- (instancetype)initWIthActivityId:(NSNumber *)activityId;

@end
