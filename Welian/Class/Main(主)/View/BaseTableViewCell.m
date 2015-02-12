//
//  BaseTableViewCell.m
//  Welian
//
//  Created by weLian on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()

@property (assign, nonatomic) UIView *bottomLineView;

@end

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //选择的背景
//        UIView *select_bg = [[UIView alloc] initWithFrame:CGRectZero];
//        select_bg.backgroundColor = [UIColor colorWithWhite:0 alpha:.2f];
//        self.selectedBackgroundView = select_bg;
        
        //cell下面的分割线
        UIView *bottomLineView = [[UIView alloc] init];
        bottomLineView.backgroundColor = RGB(231.f, 231.f, 231.f);
        [self addSubview:bottomLineView];
        self.bottomLineView = bottomLineView;
    }
    return self;
}

- (void)setHidBottomLine:(BOOL)hidBottomLine
{
    _hidBottomLine = hidBottomLine;
    _bottomLineView.hidden = hidBottomLine;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bottomLineView.frame = CGRectMake(.0f, self.height - .5f, self.width, .5f);
}

@end
