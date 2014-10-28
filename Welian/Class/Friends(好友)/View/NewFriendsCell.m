//
//  NewFriendsCell.m
//  weLian
//
//  Created by dong on 14/10/20.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "NewFriendsCell.h"

@implementation NewFriendsCell

- (void)awakeFromNib {
    [_tipLabel.layer setMasksToBounds:YES];
    [_tipLabel.layer setCornerRadius:11];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
