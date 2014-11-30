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
@class WLStatusM;
@class CommentHeadFrame;

typedef void (^FeedAndZanBlock)(WLStatusM *starusM);

typedef void (^OpenUpBlock)(BOOL isOpen);

@interface WLContentCellView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) UIViewController *homeVC;

/** 微博工具条 */
@property (nonatomic, strong) WLStatusDock *dock;

@property (nonatomic, copy) FeedAndZanBlock feedzanBlock;

@property (nonatomic, copy) OpenUpBlock openupBlock;

/**
 *  模型（数据 + 子控件的frame）
 */
@property (nonatomic, strong) WLStatusFrame *statusFrame;

@property (nonatomic, strong) CommentHeadFrame *commentFrame;

@end
