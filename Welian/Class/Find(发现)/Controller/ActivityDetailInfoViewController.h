//
//  ActivityDetailInfoViewController.h
//  Welian
//
//  Created by weLian on 15/2/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

//#import "BasicViewController.h"
#import "NLMainViewController.h"

@interface ActivityDetailInfoViewController : NLMainViewController//BasicViewController

- (instancetype)initWithActivityInfo:(ActivityInfo *)activityInfo;
- (instancetype)initWIthActivityId:(NSNumber *)activityId;

@end
