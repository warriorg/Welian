//
//  ProjcetDetailImageViewCell.m
//  Welian
//
//  Created by weLian on 15/2/5.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjcetDetailImageViewCell.h"

@implementation ProjcetDetailImageViewCell

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
    _photoView.frame = self.bounds;
}

#pragma mark - Private
- (void)setup
{
//    UIImageView *logoImageView = [[UIImageView alloc] init];
//    logoImageView.backgroundColor = [UIColor clearColor];
//    logoImageView.layer.cornerRadius = 15;
//    logoImageView.layer.masksToBounds = YES;
//    logoImageView.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:logoImageView];
    WLPhotoView *photoView = [[WLPhotoView alloc] init];
    [self addSubview:photoView];
    self.photoView = photoView;
}

@end
