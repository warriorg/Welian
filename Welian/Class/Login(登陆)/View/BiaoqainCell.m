//
//  BiaoqainCell.m
//  Athena
//
//  Created by 张艳东 on 14-7-9.
//  Copyright (c) 2014年 souche. All rights reserved.
//

#import "BiaoqainCell.h"
#import "UIImage+ImageEffects.h"

@implementation BiaoqainCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _burt = [[UIButton alloc] init];
        [_burt setUserInteractionEnabled:NO];
        [_burt setTitleColor:WLRGB(125, 125, 125) forState:UIControlStateNormal];
        [_burt setBackgroundImage:[UIImage resizedImage:@"search_bg"] forState:UIControlStateNormal];
        [_burt setBackgroundImage:[UIImage resizedImage:@"search_bg_pre"] forState:UIControlStateHighlighted];
        [_burt.titleLabel setFont:WLFONT(16)];
        [self addSubview:_burt];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
