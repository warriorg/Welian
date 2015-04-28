//
//  FriendCell.h
//  weLian
//
//  Created by dong on 14/10/20.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImagg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *VCImageView;

@property (nonatomic, strong) IBaseUserM *userMode;

@end
