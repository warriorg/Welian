//
//  WLContentCellFrame.h
//  weLian
//
//  Created by dong on 14/11/21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WLStatusM;

@interface WLContentCellFrame : NSObject

- (instancetype)initWithWidth:(CGFloat)width withShowMoreBut:(BOOL)showMoreBut;

/** 内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;
/** 配图 */
@property (nonatomic, assign, readonly) CGRect photoListViewF;
///****项目和活动*****////
@property (nonatomic, assign, readonly) CGRect cellCardF;

/** 整体的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

/** dock Y  */
@property (nonatomic, assign, readonly) CGRect dockFrame;

/** 查看全部按钮  */
@property (nonatomic, assign, readonly) CGRect moreButFrame;

@property (nonatomic, assign) BOOL isShowMoreBut;
/**
 *  微博数据模型
 */
@property (nonatomic, strong) WLStatusM *status;

@end
