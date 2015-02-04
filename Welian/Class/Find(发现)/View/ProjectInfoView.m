//
//  ProjectInfoView.m
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectInfoView.h"
#import "WLMessageAvatorFactory.h"

#define kMarginLeft 15.f
#define kMarginTop 15.f
#define kMarginEdge 10.f

#define kLogoWidth 33.f

@interface ProjectInfoView ()

//赞
@property (assign,nonatomic) UIView *praiseView;
@property (assign,nonatomic) UIImageView *praiseImageView;
@property (assign,nonatomic) UILabel *praiseNumLabel;
//内容
@property (assign,nonatomic) UILabel *nameLabel;
@property (assign,nonatomic) UILabel *msgLabel;
@property (assign,nonatomic) UILabel *typeLabel;
@property (assign,nonatomic) UIButton *logoBtn;
@property (assign,nonatomic) UIButton *statusBtn;

@end

@implementation ProjectInfoView

- (void)dealloc
{
    _infoBlock = nil;
    _projectInfo = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setProjectInfo:(IProjectDetailInfo *)projectInfo
{
    [super willChangeValueForKey:@"projectInfo"];
    _projectInfo = projectInfo;
    [super didChangeValueForKey:@"projectInfo"];
    _praiseNumLabel.text = _projectInfo.zancount.stringValue;
    _nameLabel.text = _projectInfo.name;
    _msgLabel.text = _projectInfo.intro;
    //类型
    NSMutableString *types = [NSMutableString string];
    if (_projectInfo.industrys.count > 0) {
        [types appendString:[_projectInfo.industrys[0] industryname]];
        if(_projectInfo.industrys.count > 1){
            for (int i = 1; i < _projectInfo.industrys.count;i++) {
                IInvestIndustryModel *industry = _projectInfo.industrys[i];
                [types appendString:@" | "];
                [types appendString:industry.industryname];
            }
        }
    }else{
       [types appendString:@"暂无"];
    }
    _typeLabel.text = types;
    
    //status 1 正在融资，0不融资
    if (_projectInfo.status.integerValue == 0) {
        _statusBtn.hidden = YES;
    }else{
        _statusBtn.hidden = NO;
    }
    
    if (_projectInfo.user.avatar.length > 0) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_projectInfo.user.avatar]
                                                        options:SDWebImageRetryFailed|SDWebImageLowPriority
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                           
                                                       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                           [_logoBtn setImage:[WLMessageAvatorFactory avatarImageNamed:image messageAvatorType:WLMessageAvatorTypeCircle] forState:UIControlStateNormal];
//                                                           [_logoBtn setImage:image forState:UIControlStateNormal];
                                                       }];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _praiseView.size = CGSizeMake(31.f, 46.f);
    _praiseView.top = kMarginTop;
    _praiseView.left = kMarginLeft;
    
    [_praiseImageView sizeToFit];
    _praiseImageView.centerX = _praiseView.width / 2.f;
    _praiseImageView.top = 5.f;
    
    [_praiseNumLabel sizeToFit];
    _praiseNumLabel.width = _praiseView.width;
    _praiseNumLabel.centerX = _praiseView.width / 2.f;
    _praiseNumLabel.top = _praiseImageView.bottom + 5.f;
    
    _logoBtn.size = CGSizeMake(kLogoWidth, kLogoWidth);
    _logoBtn.top = _praiseView.top + 5.f;
    _logoBtn.right = self.width - kMarginLeft;
    
    [_nameLabel sizeToFit];
    _nameLabel.width = _logoBtn.left - _praiseView.right - kMarginEdge;
    _nameLabel.left = _praiseView.right + kMarginEdge;
    _nameLabel.top = _praiseView.top + 5.f;
    
    [_msgLabel sizeToFit];
    _msgLabel.width = _logoBtn.left - _praiseView.right - kMarginEdge;
    _msgLabel.left = _nameLabel.left;
    _msgLabel.bottom = _praiseView.bottom;
    
    [_typeLabel sizeToFit];
    _typeLabel.top = _msgLabel.bottom + kMarginEdge;
    _typeLabel.left = _msgLabel.left;
    
    _statusBtn.size = CGSizeMake(88.5f, 25.f);
    _statusBtn.top = _typeLabel.bottom + kMarginEdge;
    _statusBtn.left = _nameLabel.left;
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
    praiseNumLabel.text = @"0";
    [praiseView addSubview:praiseNumLabel];
    self.praiseNumLabel = praiseNumLabel;
    
    //项目名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
    nameLabel.textColor = RGB(51.f, 51.f, 51.f);
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //项目简介
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.font = [UIFont systemFontOfSize:14.f];
    msgLabel.textColor = RGB(125.f, 125.f, 125.f);
    [self addSubview:msgLabel];
    self.msgLabel = msgLabel;
    
    //项目领域
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.textColor = RGB(173.f, 173.f, 173.f);
    typeLabel.font = [UIFont systemFontOfSize:12.f];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    //用户头像
    UIButton *logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoBtn.backgroundColor = [UIColor clearColor];
    [logoBtn sd_setImageWithURL:nil forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_small"]];
    [logoBtn addTarget:self action:@selector(logoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:logoBtn];
    self.logoBtn = logoBtn;
    
    //项目状态
    UIButton *statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    statusBtn.backgroundColor = RGB(254.f, 247.f, 231.f);
    statusBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [statusBtn setTitleColor:RGB(251.f, 178.f, 23.f) forState:UIControlStateNormal];
    [statusBtn setTitle:@"正在融资" forState:UIControlStateNormal];
    [statusBtn setImage:[UIImage imageNamed:@"discovery_rongzi_right"] forState:UIControlStateNormal];
    statusBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    statusBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
    statusBtn.layer.cornerRadius = 13.f;
    statusBtn.layer.masksToBounds = YES;
    statusBtn.layer.borderWidth = 0.5f;
    statusBtn.layer.borderColor = RGB(251.f, 178.f, 23.f).CGColor;
    [statusBtn addTarget:self action:@selector(statusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:statusBtn];
    self.statusBtn = statusBtn;
}

//查看融资信息
- (void)statusBtnClicked:(UIButton *)sender
{
    if (_infoBlock) {
        _infoBlock();
    }
}

- (void)logoBtnClicked:(UIButton *)sender
{
    if (_userShowBlock) {
        _userShowBlock();
    }
}

@end
