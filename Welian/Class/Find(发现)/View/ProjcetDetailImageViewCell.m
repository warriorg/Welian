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
    self.layer.borderColor = RGB(229.f, 229.f, 229.f).CGColor;
    self.layer.borderWidth = 0.5f;
//    UIImageView *logoImageView = [[UIImageView alloc] init];
//    logoImageView.backgroundColor = [UIColor clearColor];
//    logoImageView.layer.cornerRadius = 15;
//    logoImageView.layer.masksToBounds = YES;
//    logoImageView.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:logoImageView];
    WLPhotoView *photoView = [[WLPhotoView alloc] init];
    photoView.contentMode = UIViewContentModeScaleAspectFill;
    // 超出边界范围的内容都裁剪
    photoView.clipsToBounds = YES;
    [self addSubview:photoView];
    self.photoView = photoView;
}

@end
