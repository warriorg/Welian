//
//  ProjectViewCell.m
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectViewCell.h"

#define kMarginLeft 15.f

@interface ProjectViewCell ()

//赞
@property (assign,nonatomic) UIView *praiseView;
@property (assign,nonatomic) UIImageView *praiseImageView;
@property (assign,nonatomic) UILabel *praiseNumLabel;
//内容
@property (assign,nonatomic) UILabel *nameLabel;
@property (assign,nonatomic) UILabel *msgLabel;
@property (assign,nonatomic) UILabel *statusLabel;

- (void)setup;

@end

@implementation ProjectViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setProjectInfo:(NSDictionary *)projectInfo
{
    [super willChangeValueForKey:@"projectInfo"];
    _projectInfo = projectInfo;
    [super didChangeValueForKey:@"projectInfo"];
    //@"zhan":@"100",@"name":@"快推",@"info":@"全球领先移动招聘平台",@"status":@"正在融资"
    _praiseNumLabel.text = _projectInfo[@"zhan"];
    _nameLabel.text = _projectInfo[@"name"];
    _msgLabel.text = _projectInfo[@"info"];
    _statusLabel.text = _projectInfo[@"status"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _praiseView.size = CGSizeMake(29.f, 40.f);
    _praiseView.centerY = self.height / 2.f;
    _praiseView.left = kMarginLeft;
    
    [_praiseImageView sizeToFit];
    _praiseImageView.centerX = _praiseView.width / 2.f;
    _praiseImageView.top = 5.f;
    
    [_praiseNumLabel sizeToFit];
    _praiseNumLabel.width = _praiseView.width;
    _praiseNumLabel.centerX = _praiseView.width / 2.f;
    _praiseNumLabel.top = _praiseImageView.bottom + 5.f;
    
    [_nameLabel sizeToFit];
    _nameLabel.left = _praiseView.right + 10.f;
    _nameLabel.top = _praiseView.top;
    
    [_msgLabel sizeToFit];
    _msgLabel.width = self.width - _nameLabel.left - kMarginLeft;
    _msgLabel.left = _nameLabel.left;
    _msgLabel.bottom = _praiseView.bottom;
    
    _statusLabel.size = CGSizeMake(55.f, 20.f);
    _statusLabel.top = 0.f;
    _statusLabel.right = self.width - kMarginLeft;
}

#pragma mark - Private
- (void)setup
{
    //赞内容
    UIView *praiseView = [[UIView alloc] initWithFrame:CGRectZero];
    praiseView.backgroundColor = RGB(229.f, 229.f, 229.f);
    //圆角
    praiseView.layer.cornerRadius = 5.f;
    praiseView.layer.masksToBounds = YES;
    [self addSubview:praiseView];
    self.praiseView = praiseView;
    
    //赞图标
    UIImageView *praiseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discovery_good"]];
    praiseImageView.backgroundColor = [UIColor clearColor];
    [praiseView addSubview:praiseImageView];
    self.praiseImageView = praiseImageView;
    
    //赞数量
    UILabel *praiseNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    praiseNumLabel.backgroundColor = [UIColor clearColor];
    praiseNumLabel.textColor = RGB(0.f, 93.f, 180.f);
    praiseNumLabel.font = [UIFont systemFontOfSize:12.f];
    praiseNumLabel.minimumScaleFactor = 0.8f;
    praiseNumLabel.adjustsFontSizeToFitWidth = YES;
    praiseNumLabel.textAlignment = NSTextAlignmentCenter;
    [praiseView addSubview:praiseNumLabel];
    self.praiseNumLabel = praiseNumLabel;
    
    //项目名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont systemFontOfSize:16.f];
    nameLabel.textColor = RGB(51.f, 51.f, 51.f);
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //项目简介
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.font = [UIFont systemFontOfSize:13.f];
    msgLabel.textColor = RGB(125.f, 125.f, 125.f);
    [self addSubview:msgLabel];
    self.msgLabel = msgLabel;
    
    //项目状态
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    statusLabel.backgroundColor = RGB(245.f, 166.f, 35.f);
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.font = [UIFont systemFontOfSize:12.f];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:statusLabel];
    self.statusLabel = statusLabel;
}

@end
