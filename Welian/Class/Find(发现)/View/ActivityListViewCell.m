//
//  ActivityListViewCell.m
//  Welian
//
//  Created by weLian on 15/2/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityListViewCell.h"

#define kImageViewWidth 80.f
#define kMarginLeft 15.f

@interface ActivityListViewCell ()

@property (assign,nonatomic) UIImageView *iconImageView;
@property (assign,nonatomic) UILabel *titleLabel;
@property (assign,nonatomic) UIButton *timeBtn;
@property (assign,nonatomic) UIButton *locationBtn;
@property (assign,nonatomic) UILabel *statusLabel;
@property (assign,nonatomic) UILabel *numLabel;

@end

@implementation ActivityListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _iconImageView.size = CGSizeMake(kImageViewWidth, self.contentView.height - kMarginLeft * 2.f);
    _iconImageView.left = kMarginLeft;
    _iconImageView.centerY = self.contentView.height / 2.f;
    
    _titleLabel.width = self.contentView.width - _iconImageView.right - kMarginLeft *2.f;
    [_titleLabel sizeToFit];
    _titleLabel.left = _iconImageView.right + kMarginLeft;
    _titleLabel.top = _iconImageView.top;
    
    [_timeBtn sizeToFit];
    _timeBtn.left = _titleLabel.left;
    _timeBtn.bottom = _iconImageView.bottom;
    
    [_statusLabel sizeToFit];
    _statusLabel.right = self.contentView.width - kMarginLeft;
    _statusLabel.centerY = _timeBtn.centerY;
    
    [_numLabel sizeToFit];
    _numLabel.right = _statusLabel.left;
    _numLabel.centerY = _statusLabel.centerY;
    
    [_locationBtn sizeToFit];
    _locationBtn.width = _numLabel.left - _timeBtn.right - kMarginLeft * 2.f;
    _locationBtn.left = _timeBtn.right + kMarginLeft;
    _locationBtn.centerY = _timeBtn.centerY;
}

#pragma mark - Private
- (void)setup
{
    //图标
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    [iconImageView setDebug:YES];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = RGB(51.f, 51.f, 51.f);
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    titleLabel.text = @"杭州布鲁姆斯伯里沙龙（下午茶）";
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //时间
    UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    timeBtn.backgroundColor = [UIColor clearColor];
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [timeBtn setTitle:@"6/18" forState:UIControlStateNormal];
    [timeBtn setTitleColor:RGB(0.f, 93.f, 180.f) forState:UIControlStateNormal];
    [timeBtn setImage:[UIImage imageNamed:@"me_myactivity_time"] forState:UIControlStateNormal];
    [self.contentView addSubview:timeBtn];
    self.timeBtn = timeBtn;
    
    //城市
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.backgroundColor = [UIColor clearColor];
    locationBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [locationBtn setTitle:@"上海" forState:UIControlStateNormal];
    [locationBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"me_mycard_lacation"] forState:UIControlStateNormal];
    [self.contentView addSubview:locationBtn];
    self.locationBtn = locationBtn;
    
    //状态
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textColor = [UIColor lightGrayColor];
    statusLabel.font = [UIFont systemFontOfSize:14.f];
    statusLabel.text = @"报名";
    [self.contentView addSubview:statusLabel];
    self.statusLabel = statusLabel;
    
    //人数
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.textColor = RGB(0.f, 93.f, 180.f);
    numLabel.font = [UIFont systemFontOfSize:14.f];
    numLabel.text = @"10";
    [self.contentView addSubview:numLabel];
    self.numLabel = numLabel;
}

@end
