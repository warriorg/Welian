//
//  WLStatusCell.h
//  Welian
//
//  Created by dong on 14-9-24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WLStatusFrame;

@interface WLStatusCell : UITableViewCell

/**
 *  创建一个cell
 *
 *  @param tableView 从哪个tableView的缓存池中取出cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;


/**
 
 *  模型（数据 + 子控件的frame）
 */
@property (nonatomic, strong) WLStatusFrame *statusFrame;


@end
