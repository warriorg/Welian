//
//  WLMessageCardView.h
//  Welian
//
//  Created by weLian on 15/3/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLCellCardView.h"
#import "MLEmojiLabel.h"

#import "WLMessageModel.h"

@interface WLMessageCardView : UIView

@property (nonatomic,strong) CardStatuModel *cardInfo;

//用于显示卡片类型的控件
@property (nonatomic,assign) WLCellCardView *cardView;

/**
 *  根据消息Model对象计算消息内容的高度
 *
 *  @param message 目标消息Model对象
 *
 *  @return 返回所需高度
 */
+ (CGFloat)calculateCellHeightWithMessage:(id <WLMessageModel>)message;

@end
