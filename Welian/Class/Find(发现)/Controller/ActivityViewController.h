//
//  ActivityViewController.h
//  Welian
//
//  Created by weLian on 14/12/19.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Cordova/CDVViewController.h>

@interface ActivityViewController : CDVViewController

//- (void)hideHeader;
//- (void)backToFindVC;
//分享
- (void)shareWithInfo:(NSDictionary *)commandDic;

//进入活动详情页面
- (void)toActivityDetailVC:(NSArray *)infos;

@end
