//
//  BaseCDVViewController.h
//  Welian
//
//  Created by weLian on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Cordova/CDVViewController.h>

@interface BaseCDVViewController : CDVViewController

//分享
//- (void)shareWithInfo:(NSDictionary *)commandDic;
//进入活动详情页面
- (void)toActivityDetailVC:(NSArray *)infos;

//进入地图页面
- (void)toMapVC:(NSArray *)infos;

//显示已报名人数
- (void)showEntry:(NSArray *)infos;

//进入订单页面
- (void)toOrderVC:(NSArray *)infos;

//微信支付
- (void)wechatPay:(NSArray *)infos;

//可以调用分享
- (void)canShareWithInfo:(NSDictionary *)dict;

@end
