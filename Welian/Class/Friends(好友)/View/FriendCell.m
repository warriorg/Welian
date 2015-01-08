//
//  FriendCell.m
//  weLian
//
//  Created by dong on 14/10/20.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "FriendCell.h"
#import "UIImageView+WebCache.h"

@implementation FriendCell

- (void)setUserMode:(FriendsUserModel *)userMode
{
    _userMode = userMode;
    
    [_iconImagg sd_setImageWithURL:[NSURL URLWithString:userMode.avatar] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    [_iconImagg.layer setMasksToBounds:YES];
    [_iconImagg.layer setCornerRadius:20];
    
    [_nameLabel setText:userMode.name];
    [_infoLabel setText:[NSString stringWithFormat:@"%@   %@",userMode.position,userMode.company]];
    if (userMode.investorauth.integerValue==1) {
        [_VCImageView setHidden:NO];
    }else{
        [_VCImageView setHidden:YES];
    }
    
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
