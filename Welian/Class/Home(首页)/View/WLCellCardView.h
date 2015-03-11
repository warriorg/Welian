//
//  WLCellCardView.h
//  Welian
//
//  Created by dong on 15/3/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardStatuModel.h"

@interface WLCellCardView : UIView

@property (nonatomic, strong) CardStatuModel *cardM;
@property (nonatomic, assign) BOOL isHidLine;

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *tapBut;

@end
