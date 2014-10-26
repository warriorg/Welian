//
//  InvestorUserCell.m
//  weLian
//
//  Created by dong on 14-10-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestorUserCell.h"
#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"

@implementation InvestorUserCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self =  [super initWithCoder:aDecoder];
    if (self) {
        [self setupBg];
//        [self.iconImage.layer setCornerRadius:IWIconWHSmall*0.5];
//        [self.iconImage.layer setMasksToBounds:YES];
        
    }
    return self;
    
}

/**
 *  设置背景
 */
- (void)setupBg
{
    // 1.默认
    UIImageView *bg = [[UIImageView alloc] init];
    bg.image = [UIImage resizedImage:@"cellbackground_normal"];
    self.backgroundView = bg;
    // 2.选中
    UIImageView *selectedBg = [[UIImageView alloc] init];
    selectedBg.image = [UIImage resizedImage:@"cellbackground_highlight"];
    self.selectedBackgroundView = selectedBg;
}



- (void)setInvestorM:(InvestorUserM *)investorM
{
    _investorM = investorM;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:investorM.avatar] placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    [_iconImage.layer setMasksToBounds:YES];
    [_iconImage.layer setCornerRadius:IWIconWHSmall*0.5];
    
    [self.nameLabel setText:investorM.name];
    
    [self.infoLabel setText:[NSString stringWithFormat:@"%@  %@",investorM.position,investorM.company]];
    
    [self.caseLabel setText:[NSString stringWithFormat:@"投资案例:%@",investorM.items]];
}



@end
