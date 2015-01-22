//
//  WLShareMenuView.h
//  Welian
//
//  Created by weLian on 15/1/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLShareMenuItem.h"

@protocol WLShareMenuViewDelegate <NSObject>

@optional
/**
 *  点击第三方功能回调方法
 *
 *  @param shareMenuItem 被点击的第三方Model对象，可以在这里做一些特殊的定制
 *  @param index         被点击的位置
 */
- (void)didSelecteShareMenuItem:(WLShareMenuItem *)shareMenuItem atIndex:(NSInteger)index;

@end

@interface WLShareMenuView : UIView

/**
 *  第三方功能Models
 */
@property (strong,nonatomic) NSArray *shareMenuItems;

@property (nonatomic, weak) id <WLShareMenuViewDelegate> delegate;

/**
 *  根据数据源刷新第三方功能按钮的布局
 */
- (void)reloadData;

@end
