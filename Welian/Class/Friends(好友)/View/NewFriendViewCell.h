//
//  NewFriendViewCell.h
//  Welian
//
//  Created by weLian on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface NewFriendViewCell : BaseTableViewCell

@property (assign, nonatomic) UIImageView *logoImageView;
@property (assign, nonatomic) UILabel *nameLabel;
@property (assign, nonatomic) UILabel *messageLabel;
@property (assign, nonatomic) UIButton *operateBtn;

//返回cell的高度
+ (CGFloat)configureWith;

@end
