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

- (void)setFriendM:(NewFriendUser *)friendM
{
    _friendM = friendM;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:friendM.avatar] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    [_iconImage.layer setMasksToBounds:YES];
    [_iconImage.layer setCornerRadius:20];
    
    [_nameLabel setText:friendM.name];
    [_massgeLabel setText:friendM.msg];
    
    if ([friendM.isAgree boolValue]||[friendM.pushType isEqualToString:@"friendAdd"]) {
        [_accBut setHidden:YES];
        [_accLabel setHidden:NO];
    }else {
        if ([friendM.pushType isEqualToString:@"friendRequest"]) {
            [_accBut setBackgroundImage:[UIImage resizedImage:@"bluebutton"] forState:UIControlStateNormal];
            [_accBut setBackgroundImage:[UIImage resizedImage:@"bluebuttton_pressed"] forState:UIControlStateHighlighted];
        }else if([friendM.pushType isEqualToString:@"friendCommand"]){
            
            [_accBut setBackgroundImage:[UIImage resizedImage:@"yellowbutton"] forState:UIControlStateNormal];
            [_accBut setBackgroundImage:[UIImage resizedImage:@"yellowbutton_pressed"] forState:UIControlStateHighlighted];
            [_accBut setTitle:@"添加" forState:UIControlStateNormal];
        }
        
        [_accBut setHidden:NO];
        [_accLabel setHidden:YES];
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
