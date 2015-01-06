//
//  ActivityDetailViewController.h
//  Welian
//
//  Created by weLian on 15/1/6.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <Cordova/CDVViewController.h>

@interface ActivityDetailViewController : CDVViewController

- (instancetype)initWithShareDic:(NSDictionary *)dict;

//进入地图页面
- (void)toMapVC:(NSArray *)infos;

//显示已报名人数
- (void)showEntry:(NSArray *)infos;

//进入订单页面
- (void)toOrderVC:(NSArray *)infos;

@end
