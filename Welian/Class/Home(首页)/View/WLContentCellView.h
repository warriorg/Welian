//
//  WLContentCellView.h
//  weLian
//
//  Created by dong on 14/11/22.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLStatusFrame;
@class WLStatusDock;

@interface WLContentCellView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) UIViewController *homeVC;

/** 微博工具条 */
@property (nonatomic, strong) WLStatusDock *dock;

/**
 *  模型（数据 + 子控件的frame）
 */
@property (nonatomic, strong) WLStatusFrame *statusFrame;

@end
