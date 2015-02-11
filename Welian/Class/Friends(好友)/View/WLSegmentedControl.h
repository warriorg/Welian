//
//  WLSegmentedControl.h
//  Welian
//
//  Created by weLian on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WLSegmentedControlDelegate <NSObject>

@required
//代理函数 获取当前下标
- (void)wlSegmentedControlSelectAtIndex:(NSInteger)index;

@end

@interface WLSegmentedControl : UIView

@property (assign, nonatomic) id<WLSegmentedControlDelegate>delegate;

@property (strong, nonatomic) NSArray *bridges;

@property (assign, nonatomic) BOOL showSmallImage;//是否显示右下角图标
@property (assign, nonatomic) BOOL lineHeightAll;//分割线高度等于当前View高度

- (id)initWithFrame:(CGRect)frame Titles:(NSArray *)titles Images:(NSArray *)images Bridges:(NSArray *)bridges isHorizontal:(BOOL)isHorizontal;

//提供方法改变 index
//- (void)changeSegmentedControlWithIndex:(NSInteger)index;

@end
