//
//  ProjectDetailInfoView.m
//  Welian
//
//  Created by weLian on 15/2/2.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ProjectDetailInfoView.h"

#define kOutMarginLeft 20.f
#define kOutMarginTop 40.f
#define kMarginTop 20.f
#define kMarinLeft 30.f
#define kMarginEdge 10.f

@interface ProjectDetailInfoView ()

@property (assign,nonatomic) UIView *contentView;
@property (assign,nonatomic) UILabel *titleLabel;
@property (assign,nonatomic) UILabel *stempTitleLabel;
@property (assign,nonatomic) UILabel *stempLabel;
@property (assign,nonatomic) UILabel *moneyTitleLabel;
@property (assign,nonatomic) UILabel *moneyLabel;
@property (assign,nonatomic) UILabel *stockTitleLabel;
@property (assign,nonatomic) UILabel *stockLabel;
@property (assign,nonatomic) UILabel *valuationsTitleLabel;
@property (assign,nonatomic) UILabel *valuationsLabel;
@property (assign,nonatomic) UILabel *aboutTitleLabel;
@property (assign,nonatomic) UITextView *aboutTextView;
@property (assign,nonatomic) UIButton *closeBtn;

@end

@implementation ProjectDetailInfoView

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
    _stempLabel.text = [_projectInfo displayStage];
    _moneyLabel.text = [NSString stringWithFormat:@"%d万RMB",_projectInfo.amount.intValue];
    [_moneyLabel setAttributedText:[self getAttributedInfoString:_moneyLabel.text searchStr:_projectInfo.amount.stringValue]];
    _stockLabel.text = [NSString stringWithFormat:@"%@%%",_projectInfo.share];
    float valuationInfo = _projectInfo.amount.floatValue/_projectInfo.share.floatValue * 100;
    _valuationsLabel.text = [NSString stringWithFormat:@"%.0f万RMB",valuationInfo];
    [_valuationsLabel setAttributedText:[self getAttributedInfoString:_valuationsLabel.text searchStr:[NSString stringWithFormat:@"%.0f",valuationInfo]]];
    _aboutTextView.text = _projectInfo.financing.length > 0 ? _projectInfo.financing : @"暂无说明";
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _contentView.frame = CGRectMake(kOutMarginLeft, kOutMarginTop, self.width - kOutMarginLeft * 2.f, self.height - kOutMarginTop * 2.f);
    
    [_titleLabel sizeToFit];
    _titleLabel.centerX = _contentView.width / 2.f;
    _titleLabel.top = kMarginTop;
    
    [_stempTitleLabel sizeToFit];
    _stempTitleLabel.left = kMarinLeft;
    _stempTitleLabel.top = _titleLabel.bottom + kMarginTop;
    
    [_stempLabel sizeToFit];
    _stempLabel.centerY = _stempTitleLabel.centerY;
    _stempLabel.left = _stempTitleLabel.right + kMarginTop;
    
    [_moneyTitleLabel sizeToFit];
    _moneyTitleLabel.left = kMarinLeft;
    _moneyTitleLabel.top = _stempTitleLabel.bottom + kMarginEdge;
    
    [_moneyLabel sizeToFit];
    _moneyLabel.centerY = _moneyTitleLabel.centerY;
    _moneyLabel.left = _moneyTitleLabel.right + kMarginTop;
    
    [_stockTitleLabel sizeToFit];
    _stockTitleLabel.left = kMarinLeft;
    _stockTitleLabel.top = _moneyTitleLabel.bottom + kMarginEdge;
    
    [_stockLabel sizeToFit];
    _stockLabel.centerY = _stockTitleLabel.centerY;
    _stockLabel.left = _stockTitleLabel.right + kMarginTop;
    
    [_valuationsTitleLabel sizeToFit];
    _valuationsTitleLabel.left = kMarinLeft;
    _valuationsTitleLabel.top = _stockTitleLabel.bottom + kMarginEdge;
    
    [_valuationsLabel sizeToFit];
    _valuationsLabel.centerY = _valuationsTitleLabel.centerY;
    _valuationsLabel.left = _valuationsTitleLabel.right + kMarginTop;
    
    [_aboutTitleLabel sizeToFit];
    _aboutTitleLabel.left = kMarinLeft;
    _aboutTitleLabel.top = _valuationsTitleLabel.bottom + kMarginEdge;
    
    _aboutTextView.size = CGSizeMake(_contentView.width - kMarinLeft * 2.f, _contentView.height - _aboutTitleLabel.bottom - kMarginTop - kMarginEdge);
    _aboutTextView.top = _aboutTitleLabel.bottom + kMarginEdge;
    _aboutTextView.centerX = _contentView.width / 2.f;
    
    [_closeBtn sizeToFit];
    _closeBtn.centerX = _contentView.right;
    _closeBtn.centerY = _contentView.top;
}

#pragma mark - Private
- (void)setup
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    UIColor *titleColor = RGB(125.f, 125.f, 125.f);
    UIColor *infoColor = RGB(51.f, 51.f, 51.f);
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 10.f;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    titleLabel.textColor = infoColor;
    titleLabel.text = @"融资信息";
    [contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //融资阶段
    UILabel *stempTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stempTitleLabel.backgroundColor = [UIColor clearColor];
    stempTitleLabel.font = [UIFont systemFontOfSize:16.f];
    stempTitleLabel.textColor = titleColor;
    stempTitleLabel.text = @"融资阶段";
    [contentView addSubview:stempTitleLabel];
    self.stempTitleLabel = stempTitleLabel;
    
    UILabel *stempLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stempLabel.backgroundColor = [UIColor clearColor];
    stempLabel.font = stempTitleLabel.font;
    stempLabel.textColor = infoColor;
    stempLabel.text = @"天使轮";
    [contentView addSubview:stempLabel];
    self.stempLabel = stempLabel;
    
    //融资金额
    UILabel *moneyTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    moneyTitleLabel.backgroundColor = [UIColor clearColor];
    moneyTitleLabel.font = [UIFont systemFontOfSize:16.f];
    moneyTitleLabel.textColor = titleColor;
    moneyTitleLabel.text = @"融资金额";
    [contentView addSubview:moneyTitleLabel];
    self.moneyTitleLabel = moneyTitleLabel;
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.font = stempTitleLabel.font;
    moneyLabel.textColor = infoColor;
    moneyLabel.text = @"50万RMB";
    [moneyLabel setAttributedText:[self getAttributedInfoString:moneyLabel.text searchStr:@"50"]];
    [contentView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    //出让股份
    UILabel *stockTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stockTitleLabel.backgroundColor = [UIColor clearColor];
    stockTitleLabel.font = [UIFont systemFontOfSize:16.f];
    stockTitleLabel.textColor = titleColor;
    stockTitleLabel.text = @"出让股份";
    [contentView addSubview:stockTitleLabel];
    self.stockTitleLabel = stockTitleLabel;
    
    UILabel *stockLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stockLabel.backgroundColor = [UIColor clearColor];
    stockLabel.font = stempTitleLabel.font;
    stockLabel.textColor = infoColor;
    stockLabel.text = @"3333333%";
    [contentView addSubview:stockLabel];
    self.stockLabel = stockLabel;
    
    //投后估值
    UILabel *valuationsTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    valuationsTitleLabel.backgroundColor = [UIColor clearColor];
    valuationsTitleLabel.font = [UIFont systemFontOfSize:16.f];
    valuationsTitleLabel.textColor = titleColor;
    valuationsTitleLabel.text = @"投后估值";
    [contentView addSubview:valuationsTitleLabel];
    self.valuationsTitleLabel = valuationsTitleLabel;
    
    UILabel *valuationsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    valuationsLabel.backgroundColor = [UIColor clearColor];
    valuationsLabel.font = stempTitleLabel.font;
    valuationsLabel.textColor = infoColor;
    valuationsLabel.text = @"1000万RMB";
    [valuationsLabel setAttributedText:[self getAttributedInfoString:valuationsLabel.text searchStr:@"1000"]];
    [contentView addSubview:valuationsLabel];
    self.valuationsLabel = valuationsLabel;
    
    //融资说明
    UILabel *aboutTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    aboutTitleLabel.backgroundColor = [UIColor clearColor];
    aboutTitleLabel.font = [UIFont systemFontOfSize:16.f];
    aboutTitleLabel.textColor = titleColor;
    aboutTitleLabel.text = @"融资说明";
    [contentView addSubview:aboutTitleLabel];
    self.aboutTitleLabel = aboutTitleLabel;
    
    UITextView *aboutTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    aboutTextView.backgroundColor = [UIColor clearColor];
    aboutTextView.textColor = infoColor;
    aboutTextView.font = [UIFont systemFontOfSize:14.f];
    aboutTextView.text = @"杭州传送门网络科技有限公司成立于2014年8月，旗下产品“微链”专注于为互联网创业提供社交服务，并基于社交关系衍生出系统性的创业服务解决方案。公司的主要创始人均具有丰富的创业、投资及媒体从业经验。公司扎根于中国互联网重镇杭州，深刻意识到互联网对中国未来的巨大影响，并全力投身其中。这是创业最好的年代，抓住机遇吧，创业者们！微链是一款专注于互联网创业的社交产品，致力于通过人与人的连接让创业变得更加简单有趣，与互联网创业有关的伙伴们可以在微链上享受自由且专注的交流。微链的团队在互联网创业和投资领域有很深的积累，团队聚集了一批心怀梦想、坚信创业必将改变中国的年轻人。在创立一个月之内，微链已经获得了投资界的青睐并顺利拿到了风险投资。这是一个属于创业者的时代，在我们的理解中，创业是一种态度，创始人、投资人、已经和正要加入创业企业的人才，都是创业者。对你而言，最重要的，是找到他们，并且连接他们。我们认为，移动互联网的时代里，单打独斗那不叫创业，圈子将产生巨大的力量。微链正是这样一款产品，帮助你连接他人，与圈子一起创业。";
    aboutTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [contentView addSubview:aboutTextView];
    self.aboutTextView = aboutTextView;
    
    //关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.backgroundColor = [UIColor clearColor];
    [closeBtn setImage:[UIImage imageNamed:@"discovery_rongzi_chacha"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    self.closeBtn = closeBtn;
}

//关闭当前View
- (void)closeBtnClicked:(UIButton *)sender
{
    _closeBtn.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:.3f animations:^{
        _closeBtn.transform = CGAffineTransformMakeRotation(360.f/M_PI_2);
    } completion:^(BOOL finished) {
        if (_closeBlock) {
            _closeBlock();
        }
    }];
}

//设置特殊颜色
- (NSMutableAttributedString *)getAttributedInfoString:(NSString *)str searchStr:(NSString *)searchStr
{
    NSDictionary *attrsDic = @{NSForegroundColorAttributeName: WLRGB(52, 116, 186),NSFontAttributeName:WLFONTBLOD(17)};
    NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange searchRange = [str rangeOfString:searchStr options:NSCaseInsensitiveSearch];
    [attrstr addAttributes:attrsDic range:searchRange];
    return attrstr;
}

@end
