//
//  InvestorUserCell.m
//  weLian
//
//  Created by dong on 14-10-16.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "InvestorUserCell.h"
#import "UIImage+ImageEffects.h"

@implementation InvestorUserCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self =  [super initWithCoder:aDecoder];
    if (self) {
        [self setupBg];
    }
    return self;
    
}

- (void)awakeFromNib
{
    [self.iconImage.layer setMasksToBounds:YES];
    [self.iconImage.layer setCornerRadius:IWIconWHSmall*0.5];
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


@end
