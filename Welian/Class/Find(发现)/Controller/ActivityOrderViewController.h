//
//  ActivityOrderViewController.h
//  Welian
//
//  Created by weLian on 15/1/6.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Cordova/CDVViewController.h>

@interface ActivityOrderViewController : CDVViewController

@property (nonatomic, strong) NSString *orderInfo;

//微信支付
- (void)wechatPay;

@end
