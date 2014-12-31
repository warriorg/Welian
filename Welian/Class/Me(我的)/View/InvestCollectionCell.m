//
//  InvestCollectionCell.m
//  Welian
//
//  Created by dong on 14/12/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestCollectionCell.h"

@implementation InvestCollectionCell

//- (void)setChecked:(BOOL)checked
//{
////    _m_checked = checked;
//    if (checked)
//    {
//        _checkImageView.image = [UIImage imageNamed:@"investor_attestation_selected.png"];
//    }
//    else
//    {
//        _checkImageView.image = [UIImage imageNamed:@"investor_attestation_to_select.png"];
//    }
//}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [_checkImageView setSelected:selected];
}

//- (void)setIndusM:(IInvestIndustryModel *)indusM
//{
//    _indusM = indusM;
//    [self setSelected:indusM.isSelect];
//    [_titeLabel setText:indusM.industryname];
//    
//}
//
//- (void)setStageM:(IInvestStageModel *)stageM
//{
//    _stageM = stageM;
//    [self setSelected:stageM.isSelect];
//    [_titeLabel setText:stageM.stagename];
//}

//- (void)setSelected:(BOOL)selected
//{
//    [super setSelected:selected];
//    [self setChecked:selected];
//}

- (void)awakeFromNib {
//        _checkImageView.image = [UIImage imageNamed:@"investor_attestation_selected.png"];
    // Initialization code
}

@end
