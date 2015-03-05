//
//  WLCellCardView.m
//  Welian
//
//  Created by dong on 15/3/3.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WLCellCardView.h"

@implementation WLCellCardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6.0;
        self.layer.borderWidth = 0.6;
        self.layer.borderColor = [WLRGB(173, 173, 173) CGColor];
        [self addUIView];
    }
    return self;
}

- (void)addUIView
{
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 40, 40)];
    [_iconImage setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:_iconImage];
    
    _titLabel = [[UILabel alloc] init];
    _titLabel.font = WLFONT(15);
    _titLabel.textColor = WLRGB(51, 51, 51);
    [self addSubview:_titLabel];
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = WLFONT(13);
    _detailLabel.textColor = WLRGB(173, 173, 173);
    [self addSubview:_detailLabel];
    
    _tapBut = [[UIButton alloc] init];
    [self addSubview:_tapBut];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _tapBut.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _titLabel.frame = CGRectMake(55, 8, frame.size.width-55-8, 21);
    _titLabel.text = @"微链";
    _detailLabel.frame = CGRectMake(55, CGRectGetMaxY(_titLabel.frame), frame.size.width-55-8, 21);
    _detailLabel.text = @"专注于互联网创业的社交平台";
}


@end
