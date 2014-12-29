//
//  InvestCollectionCell.m
//  Welian
//
//  Created by dong on 14/12/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestCollectionCell.h"

@implementation InvestCollectionCell

- (void)setChecked:(BOOL)checked
{
    if (checked)
    {
        _checkImageView.image = [UIImage imageNamed:@"investor_attestation_to_select.png"];
    }
    else
    {
        _checkImageView.image = [UIImage imageNamed:@"investor_attestation_selected.png"];
    }
    m_checked = checked;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
