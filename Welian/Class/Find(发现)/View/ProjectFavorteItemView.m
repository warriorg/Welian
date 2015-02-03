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
}

#pragma mark - Private
- (void)setup
{
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:logoImageView];
    self.logoImageView = logoImageView;
}

@end
