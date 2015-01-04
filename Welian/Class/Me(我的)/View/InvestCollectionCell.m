//
//  InvestCollectionCell.m
//  Welian
//
//  Created by dong on 14/12/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestCollectionCell.h"

@implementation InvestCollectionCell

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [_checkImageView setSelected:selected];
}


- (void)awakeFromNib {
//        _checkImageView.image = [UIImage imageNamed:@"investor_attestation_selected.png"];
    // Initialization code
}

@end
