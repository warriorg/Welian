//
//  BadgeBaseCell.h
//  Welian
//
//  Created by dong on 15/1/12.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeBaseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titLabel;
@property (weak, nonatomic) IBOutlet UILabel *deputLabel;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImage;

@end
