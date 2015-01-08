//
//  BaseCDVViewController.m
//  Welian
//
//  Created by weLian on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BaseCDVViewController.h"

@implementation BaseCDVViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //铺到状态栏底下而是从状态栏下面
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.webView setDebug:YES];
}

/**
 When web application loads Add stuff to the DOM, mainly the user-defined settings from the Settings.plist file, and
 the device's data such as device ID, platform version, etc.
 */
- (void)webViewDidStartLoad:(UIWebView*)theWebView
{
    [super webViewDidStartLoad:theWebView];
    NSLog(@"Resetting plugins due to page load.");
    [WLHUDView showHUDWithStr:@"加载中..." dim:NO];
}

/**
 Called when the webview finishes loading.  This stops the activity view.
 */
- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    [super webViewDidFinishLoad:theWebView];
    [WLHUDView hiddenHud];
}


#pragma mark - Private
//进入活动详情页面
- (void)toActivityDetailVC:(NSArray *)infos
{
    
}

//进入地图页面
- (void)toMapVC:(NSArray *)infos
{
    
}

//显示已报名人数
- (void)showEntry:(NSArray *)infos
{
    
}

//进入订单页面
- (void)toOrderVC:(NSArray *)infos
{
    
}

//微信支付
- (void)wechatPay
{
    
}

@end
