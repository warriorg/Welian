//
//  FriendCell.h
//  weLian
//
//  Created by dong on 14/10/20.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface FriendCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImagg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (nonatomic, strong) UserInfoModel *userMode;

@end
