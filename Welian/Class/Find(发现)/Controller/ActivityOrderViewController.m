//
//  ActivityOrderViewController.m
//  Welian
//
//  Created by weLian on 15/1/6.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityOrderViewController.h"

@interface ActivityOrderViewController ()

@end

@implementation ActivityOrderViewController

- (void)dealloc
{
    _orderInfo = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
//微信支付
- (void)wechatPay
{
    DLog(@"调用微信支付");
}

@end
