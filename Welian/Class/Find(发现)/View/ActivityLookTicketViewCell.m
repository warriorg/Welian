//
//  ActivityLookTicketViewCell.m
//  Welian
//
//  Created by weLian on 15/2/13.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityLookTicketViewCell.h"

#define kMarginLeft 20.f
#define kBottomHeight 5.f
#define kTicketNumWidth 30.f

#define kMarginTop 10.f
#define kMarginInEdge 5.f

@interface ActivityLookTicketViewCell ()

@property (assign,nonatomic) UIImageView *bgImageView;
@property (assign,nonatomic) UILabel *ticketNumLabel;
@property (assign,nonatomic) UILabel *nameLabel;
@property (assign,nonatomic) UILabel *infoLabel;
@property (assign,nonatomic) UILabel *moneyLabel;

@end

@implementation ActivityLookTicketViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setIActivityTicket:(IActivityTicket *)iActivityTicket
{
    [super willChangeValueForKey:@"iActivityTicket"];
    _iActivityTicket = iActivityTicket;
    [super didChangeValueForKey:@"iActivityTicket"];
    _nameLabel.text = _iActivityTicket.name;
    _infoLabel.text = _iActivityTicket.intro;
    if (_iActivityTicket.price.floatValue > 0) {
        _moneyLabel.text = [NSString stringWithFormat:@"%@元",_iActivityTicket.price];
        [_moneyLabel setAttributedText:[self getAttributedInfoString:_moneyLabel.text searchStr:@"元"]];
    }else{
        _moneyLabel.text = @"免费";
    }
    _ticketNumLabel.text = [NSString stringWithFormat:@"x %@",_iActivityTicket.ticketCount];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgImageView.size = CGSizeMake(self.contentView.width - kMarginLeft * 3 - kTicketNumWidth,self.contentView.height - kBottomHeight);
    _bgImageView.top = 0.;
    _bgImageView.left = kMarginLeft;
    
    _ticketNumLabel.size = CGSizeMake(kTicketNumWidth + kMarginLeft, _bgImageView.height);
    _ticketNumLabel.right = self.contentView.width - kMarginLeft;
    _ticketNumLabel.centerY = self.contentView.height / 2.f;
    
    _moneyLabel.size = CGSizeMake(72.f, _bgImageView.height - 20.f);
    _moneyLabel.right = _bgImageView.width;
    _moneyLabel.centerY = _bgImageView.height / 2.f;
    //设置左侧边框线
    _moneyLabel.layer.borderColorFromUIColor = RGB(229.f, 229.f, 229.f);
    _moneyLabel.layer.borderWidths = @"{0,0,0,0.8}";
    
    _infoLabel.width = _bgImageView.width - _moneyLabel.width - kMarginLeft;
    [_infoLabel sizeToFit];
    _infoLabel.left = kMarginLeft;
    if (_iActivityTicket.name.length > 0) {
        _infoLabel.bottom = self.height - kMarginTop;
    }else{
        _infoLabel.centerY = _bgImageView.height / 2.f;
    }
    
    _nameLabel.width = _bgImageView.width - _moneyLabel.width - kMarginLeft;
    [_nameLabel sizeToFit];
    _nameLabel.left = kMarginLeft;
    if (_iActivityTicket.intro.length > 0) {
        _nameLabel.bottom = _infoLabel.top - kMarginInEdge;
    }else{
        _nameLabel.centerY = _bgImageView.height / 2.f;
    }
}

#pragma mark - Private
- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //背景图
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"discovery_activity_ticket_bg"] stretchableImageWithLeftCapWidth:9.75 topCapHeight:0]];
    [self.contentView addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = kTitleNormalTextColor;
    nameLabel.font = [UIFont boldSystemFontOfSize:14.f];
    nameLabel.text = @"VIP门票";
    nameLabel.numberOfLines = 0;
    [bgImageView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //说明
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = kNormalTextColor;
    infoLabel.font = [UIFont systemFontOfSize:13.f];
    infoLabel.text = @"参加贵宾晚宴";
    infoLabel.numberOfLines = 0;
    [bgImageView addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    //金额
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.textColor = KBlueTextColor;
    moneyLabel.font = [UIFont boldSystemFontOfSize:19.f];
    moneyLabel.text = @"500元";
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [moneyLabel setAttributedText:[self getAttributedInfoString:moneyLabel.text searchStr:@"元"]];
    [bgImageView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    //票数量
    UILabel *ticketNumLabel = [[UILabel alloc] init];
    ticketNumLabel.backgroundColor = [UIColor clearColor];
    ticketNumLabel.textColor = kTitleNormalTextColor;
    ticketNumLabel.font = [UIFont systemFontOfSize:16.f];
    ticketNumLabel.text = @"x 1";
    [self.contentView addSubview:ticketNumLabel];
    self.ticketNumLabel = ticketNumLabel;
}

//设置特殊颜色
- (NSMutableAttributedString *)getAttributedInfoString:(NSString *)str searchStr:(NSString *)searchStr
{
    NSDictionary *attrsDic = @{NSForegroundColorAttributeName: WLRGB(52, 116, 186),NSFontAttributeName:WLFONTBLOD(12)};
    NSMutableAttributedString *attrstr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange searchRange = [str rangeOfString:searchStr options:NSCaseInsensitiveSearch];
    [attrstr addAttributes:attrsDic range:searchRange];
    return attrstr;
}

//返回cell的高度
+ (CGFloat)configureWithName:(NSString *)name DetailInfo:(NSString *)detailInfo
{
    float maxWidth = [[UIScreen mainScreen] bounds].size.width - kMarginLeft * 3 - kTicketNumWidth;
    //计算第一个label的高度
    CGSize size1 = [name calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:[UIFont systemFontOfSize:14.f]];
    CGSize size2 = [detailInfo calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:[UIFont systemFontOfSize:13.f]];
    
    float height = (name.length > 0 ? size1.height : 0) + (detailInfo.length > 0 ? size2.height + kMarginInEdge : 0) + kMarginTop * 2.f + kBottomHeight;
    if (height > 69.f) {
        return height;
    }else{
        return 69.f;
    }
}

@end
