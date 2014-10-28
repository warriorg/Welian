//
//  FriendsNewCell.m
//  weLian
//
//  Created by dong on 14/10/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "FriendsNewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"

@implementation FriendsNewCell

- (void)setFriendM:(NewFriendModel *)friendM
{
    _friendM = friendM;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:friendM.avatar] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    [_iconImage.layer setMasksToBounds:YES];
    [_iconImage.layer setCornerRadius:20];
    
    [_nameLabel setText:friendM.name];
    [_massgeLabel setText:friendM.message];
    [_accBut setBackgroundImage:[UIImage resizedImage:@"bluebutton"] forState:UIControlStateNormal];
    [_accBut setBackgroundImage:[UIImage resizedImage:@"bluebuttton_pressed"] forState:UIControlStateHighlighted];
    if ([friendM.isAgree isEqualToString:@"0"]) {
        [_accBut setHidden:NO];
        [_accLabel setHidden:YES];
    }else if([friendM.isAgree isEqualToString:@"1"]){
        [_accBut setHidden:YES];
        [_accLabel setHidden:NO];
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
