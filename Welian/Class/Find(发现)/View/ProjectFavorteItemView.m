//
//  ProjectFavorteItemView.m
//  Welian
//
//  Created by weLian on 15/2/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectFavorteItemView.h"

@interface ProjectFavorteItemView ()

@end

@implementation ProjectFavorteItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _logoImageView.frame = self.bounds;
    
    [_numLabel sizeToFit];
    _numLabel.width = self.width - 4.f;
    _numLabel.centerX = self.width / 2.f;
    _numLabel.centerY = self.height / 2.f;
}

#pragma mark - Private
- (void)setup
{
    self.layer.cornerRadius = 15;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = [UIFont systemFontOfSize:12.f];
    numLabel.adjustsFontSizeToFitWidth = YES;
    numLabel.minimumScaleFactor = 0.6f;
    numLabel.textColor = [UIColor whiteColor];
    numLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:numLabel];
    self.numLabel = numLabel;
}

@end
