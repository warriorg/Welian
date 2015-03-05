//
//  ActivityListViewCell.m
//  Welian
//
//  Created by weLian on 15/2/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityListViewCell.h"

#define kImageViewWidth 90.f
#define kImageViewHeight 68.f
#define kMarginLeft 15.f
#define kMarginEdge 10.f

@interface ActivityListViewCell ()

@property (assign,nonatomic) UIImageView *iconImageView;
@property (assign,nonatomic) UIImageView *joinedImageView;
@property (assign,nonatomic) UILabel *titleLabel;
@property (assign,nonatomic) UIButton *timeBtn;
@property (assign,nonatomic) UIButton *locationBtn;
@property (assign,nonatomic) UILabel *statusLabel;
@property (assign,nonatomic) UILabel *numLabel;
@property (assign,nonatomic) UILabel *dateLabel;

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

- (void)setActivityInfo:(ActivityInfo *)activityInfo
{
    [super willChangeValueForKey:@"activityInfo"];
    _activityInfo = activityInfo;
    [super didChangeValueForKey:@"activityInfo"];
    //设置图片
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_activityInfo.logo]
                      placeholderImage:nil
                               options:SDWebImageRetryFailed|SDWebImageLowPriority
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 //黑白
                                 if (_activityInfo.status.integerValue == 2) {
                                     [_iconImageView setImage:[image partialImageWithPercentage:0 vertical:YES grayscaleRest:YES]];
                                 }
                             }];
    
    _joinedImageView.hidden = !_activityInfo.isjoined.boolValue;
    _titleLabel.text = _activityInfo.name;
    
    //设置城市
    [_locationBtn setTitle:(_activityInfo.city.length > 0 ? _activityInfo.city : @"未知") forState:UIControlStateNormal];
    //设置日期
    [_timeBtn setTitle:[[_activityInfo.startime dateFromNormalString] formattedDateWithFormat:@"MM/dd"] forState:UIControlStateNormal];
    _dateLabel.text = [_activityInfo displayStartWeekDay];
    if(_activityInfo.joined.integerValue == _activityInfo.limited.integerValue){
        _numLabel.hidden = YES;
        _statusLabel.text = @"已报满";
    }else{
        _statusLabel.text = @"报名";
        _numLabel.hidden = NO;
        _numLabel.text = _activityInfo.joined.stringValue;
    }
    
    //设置字体颜色
    [_timeBtn setTitleColor:(_activityInfo.status.integerValue == 2 ? kNormalTextColor : KBlueTextColor) forState:UIControlStateNormal];
    _numLabel.textColor = _activityInfo.status.integerValue == 2 ? kNormalTextColor : KBlueTextColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _iconImageView.size = CGSizeMake(kImageViewWidth, self.contentView.height - kMarginLeft * 2.f);
    _iconImageView.left = kMarginLeft;
    _iconImageView.centerY = self.contentView.height / 2.f;
    
    [_joinedImageView sizeToFit];
    _joinedImageView.right = self.contentView.width;
    _joinedImageView.top = 0.f;
    
    _titleLabel.width = self.contentView.width - _iconImageView.right - kMarginEdge - (_joinedImageView.hidden == NO ? _joinedImageView.width : kMarginEdge);
    [_titleLabel sizeToFit];
    _titleLabel.left = _iconImageView.right + kMarginEdge;
    _titleLabel.top = _iconImageView.top;
    
    [_timeBtn sizeToFit];
    _timeBtn.width = _timeBtn.width + 5.f;
    _timeBtn.left = _titleLabel.left;
    _timeBtn.bottom = _iconImageView.bottom;
    
    [_dateLabel sizeToFit];
    _dateLabel.left = _timeBtn.right;
    _dateLabel.centerY = _timeBtn.centerY;
    
    [_statusLabel sizeToFit];
    _statusLabel.right = self.contentView.width - kMarginLeft;
    _statusLabel.centerY = _timeBtn.centerY;
    
    [_numLabel sizeToFit];
    _numLabel.right = _statusLabel.left;
    _numLabel.centerY = _statusLabel.centerY;
    
    [_locationBtn sizeToFit];
    _locationBtn.width = _numLabel.left - _dateLabel.right - kMarginEdge * 2.f;
    _locationBtn.left = _dateLabel.right + kMarginEdge;
    _locationBtn.centerY = _dateLabel.centerY;
}

#pragma mark - Private
- (void)setup
{
    //图标
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
//    [iconImageView setDebug:YES];
    
    //以报名标记
    UIImageView *joinedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discovery_activity_list_already"]];
    joinedImageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:joinedImageView];
    self.joinedImageView = joinedImageView;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = kTitleNormalTextColor;
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    titleLabel.text = @"杭州布鲁姆斯伯里沙龙咯好哦好哦配合哦好累了据了解";
    titleLabel.numberOfLines = 2;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
//    [titleLabel setDebug:YES];
    
    //时间
    UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    timeBtn.backgroundColor = [UIColor clearColor];
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [timeBtn setTitle:@"6/18" forState:UIControlStateNormal];
    [timeBtn setTitleColor:KBlueTextColor forState:UIControlStateNormal];
    [timeBtn setImage:[UIImage imageNamed:@"discovery_activity_list_time"] forState:UIControlStateNormal];
    timeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    [self.contentView addSubview:timeBtn];
    self.timeBtn = timeBtn;
    
    //星期几
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textColor = kNormalTextColor;
    dateLabel.font = [UIFont systemFontOfSize:12.f];
    dateLabel.text = @"周日";
    [self.contentView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    //城市
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.backgroundColor = [UIColor clearColor];
    locationBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [locationBtn setTitle:@"上海" forState:UIControlStateNormal];
    [locationBtn setTitleColor:kNormalTextColor forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"discovery_activity_list_place"] forState:UIControlStateNormal];
    [self.contentView addSubview:locationBtn];
    self.locationBtn = locationBtn;
//    [locationBtn setDebug:YES];
    
    //状态
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textColor = kNormalTextColor;
    statusLabel.font = [UIFont systemFontOfSize:12.f];
    statusLabel.text = @"报名";
    [self.contentView addSubview:statusLabel];
    self.statusLabel = statusLabel;
    
    //人数
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.textColor = KBlueTextColor;
    numLabel.font = [UIFont systemFontOfSize:12.f];
    numLabel.text = @"10";
    [self.contentView addSubview:numLabel];
    self.numLabel = numLabel;
}

@end
