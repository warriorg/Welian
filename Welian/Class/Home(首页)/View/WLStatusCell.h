//
//  WLStatusCell.h
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLStatusDock.h"
@class WLStatusFrame;

//typedef void(^WLCellMoreBlock)(WLStatusFrame *statusF);


@interface WLStatusCell : UITableViewCell

/** 右上角按钮 */
@property (nonatomic, strong) UIButton *moreBut;

/** 微博工具条 */
@property (nonatomic, strong) WLStatusDock *dock;

/**
 *  创建一个cell
 *
 *  @param tableView 从哪个tableView的缓存池中取出cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;
//+ (instancetype)cellWithTableView:(UITableView *)tableView withBlok:(WLCellMoreBlock)moreBlock;

/**
 
 *  模型（数据 + 子控件的frame）
 */
@property (nonatomic, strong) WLStatusFrame *statusFrame;


@end
