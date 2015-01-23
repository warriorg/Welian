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
//    [self.webView setDebug:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [WLHUDView hiddenHud];
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
- (void)toOrderVC:(CDVInvokedUrlCommand *)command
{
    
}

//微信支付
- (void)wechatPay:(NSArray *)infos
{
    
}

//可以调用分享
- (void)canShareWithInfo:(NSDictionary *)dict
{
    
}

//普通活动报名
- (void)entry:(CDVInvokedUrlCommand *)command
{
    
}

//发送回复
- (void)send:(CDVInvokedUrlCommand *)command backInfo:(NSString *)backInfo
{
//    NSString *callbackID = command.callbackId;
    CDVPluginResult* pluginResult = nil;
    //    NSString* myarg = [command.arguments objectAtIndex:0];
    
    //    if (myarg != nil) {
    //        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:backInfo];
    //    } else {
    //        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    //    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // 清除内存中的图片缓存
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
    DLog(@"%@ ------  didReceiveMemoryWarning",[self class]);
}


@end
