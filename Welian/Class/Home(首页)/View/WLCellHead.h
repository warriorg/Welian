//
//  WLCellHead.h
//  微链
//
//  Created by dong on 14/11/19.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLBasicTrends;

@interface WLCellHead : UIView
// 头像
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) WLBasicTrends *user;

@property (nonatomic, weak) UIViewController *controllVC;

@end
