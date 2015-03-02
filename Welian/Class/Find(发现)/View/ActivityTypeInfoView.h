//
//  ActivityTypeInfoView.h
//  Welian
//
//  Created by weLian on 15/2/11.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectTypeInfoBlock)(NSString *info);

@interface ActivityTypeInfoView : UIView

@property (strong,nonatomic) NSArray *datasource;
@property (strong,nonatomic) selectTypeInfoBlock block;
@property (strong,nonatomic) NSString *normalInfo;//现实当前选择的内容
@property (assign,nonatomic) BOOL showLocation;//显示当前定位城市

- (void)showInViewFromLeft:(UIView *)view;
- (void)dismissToLeft;
- (void)showInViewFromRight:(UIView *)view;
- (void)dismissToRight;

- (void)showInViewWithFrame:(CGRect)frame;
- (void)dismissWithFrame:(CGRect)frame;

@end
