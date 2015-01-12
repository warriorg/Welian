//
//  MainViewController.h
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface MainViewController : UITabBarController
single_interface(MainViewController)

// 根据更新信息设置 提示角标
- (void)updataItembadge;

- (void)loadNewStustupdata;

@end
