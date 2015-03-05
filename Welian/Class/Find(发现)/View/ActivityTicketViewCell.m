//
//  ActivityTicketViewCell.m
//  Welian
//
//  Created by weLian on 15/2/12.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityTicketViewCell.h"

#define kOperateViewWidth 92.f
#define kOperateViewHeight 30.f

#define kMarginLeft 15.f
#define kMarginEdge 20.f

@interface ActivityTicketViewCell ()

@property (assign,nonatomic) UIView *operateView;
@property (assign,nonatomic) UIButton *addBtn;
@property (assign,nonatomic) UIButton *minusBtn;
@property (assign,nonatomic) UILabel *buyNumLabel;
@property (assign,nonatomic) UILabel *nameLabel;
@property (assign,nonatomic) UILabel *infoLabel;
@property (assign,nonatomic) UILabel *moneyLabel;
@property (assign,nonatomic) UILabel *ticketNumLabel;
@property (assign,nonatomic) UILabel *statusLabel;

@end

@implementation ActivityTicketViewCell

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
    _ticketNumLabel.text = [NSString stringWithFormat:@"剩余%d张",_iActivityTicket.ticketCount.intValue - _iActivityTicket.joined.intValue];
    _moneyLabel.text = [NSString stringWithFormat:@"%@元",_iActivityTicket.price];
    [_moneyLabel setAttributedText:[self getAttributedInfoString:_moneyLabel.text searchStr:@"元"]];
    _statusLabel.hidden = _iActivityTicket.ticketCount.integerValue > _iActivityTicket.joined.integerValue ? YES : NO;
    _operateView.hidden = _iActivityTicket.ticketCount.integerValue > _iActivityTicket.joined.integerValue ? NO : YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_statusLabel sizeToFit];
    _statusLabel.right = self.width - kMarginLeft;
    _statusLabel.centerY = self.height / 2.f;
    
    _operateView.size = CGSizeMake(kOperateViewWidth, kOperateViewHeight);
    _operateView.centerY = self.height / 2.f;
    _operateView.right = self.width - kMarginLeft;
    
    _addBtn.size = CGSizeMake(kOperateViewWidth / 3.f, _operateView.height);
    _addBtn.right = _operateView.width;
    _addBtn.centerY = _operateView.height / 2.f;
    
    _minusBtn.size = CGSizeMake(kOperateViewWidth / 3.f, _operateView.height);
    _minusBtn.left = 0.f;
    _minusBtn.centerY = _operateView.height / 2.f;
    
    _buyNumLabel.size = CGSizeMake(kOperateViewWidth / 3.f, _operateView.height);
    _buyNumLabel.centerX = _operateView.width / 2.f;
    _buyNumLabel.centerY = _operateView.height / 2.f;
    _buyNumLabel.layer.borderColorFromUIColor = [UIColor lightGrayColor];
    _buyNumLabel.layer.borderWidths = @"{0,0.5,0,0.5}";
    
    [_moneyLabel sizeToFit];
    _moneyLabel.right = self.width - kMarginLeft - kOperateViewWidth - kMarginEdge;
    _moneyLabel.bottom = self.height / 2.f;
    
    [_ticketNumLabel sizeToFit];
    _ticketNumLabel.right = _moneyLabel.right;
    _ticketNumLabel.top = self.height / 2.f + 3.f;
    
    _nameLabel.width = _moneyLabel.left - kMarginLeft * 2.f;
    [_nameLabel sizeToFit];
    _nameLabel.left = kMarginLeft;
    _nameLabel.bottom = self.height / 2.f;
    
    _infoLabel.width = _ticketNumLabel.left - kMarginLeft * 2.f;
    [_infoLabel sizeToFit];
    _infoLabel.left = kMarginLeft;
    _infoLabel.top = self.height / 2.f + 3.f;
}

#pragma mark - Private
- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //操作栏目
    UIView *operateView = [[UIView alloc] init];
    operateView.layer.cornerRadius = 5.f;
    operateView.layer.masksToBounds = YES;
    operateView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    operateView.layer.borderWidth = 0.8f;
    [self.contentView addSubview:operateView];
    self.operateView = operateView;
    
    //添加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"discovery_activity_detail_jia"] forState:UIControlStateNormal];
    [operateView addSubview:addBtn];
    self.addBtn = addBtn;
    
    //减少按钮
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusBtn setImage:[UIImage imageNamed:@"discovery_activity_detail_jian"] forState:UIControlStateNormal];
    [operateView addSubview:minusBtn];
    self.minusBtn = minusBtn;
    
    //购买数量
    UILabel *buyNumLabel = [[UILabel alloc] init];
    buyNumLabel.textColor = kTitleNormalTextColor;
    buyNumLabel.font = [UIFont systemFontOfSize:15.f];
    buyNumLabel.textAlignment = NSTextAlignmentCenter;
    buyNumLabel.text = @"1";
    [operateView addSubview:buyNumLabel];
    self.buyNumLabel = buyNumLabel;
    
    //金额
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.textColor = KBlueTextColor;
    moneyLabel.font = [UIFont boldSystemFontOfSize:19.f];
    moneyLabel.text = @"500元";
    [moneyLabel setAttributedText:[self getAttributedInfoString:moneyLabel.text searchStr:@"元"]];
    [self.contentView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    //票数量
    UILabel *ticketNumLabel = [[UILabel alloc] init];
    ticketNumLabel.backgroundColor = [UIColor clearColor];
    ticketNumLabel.textColor = kNormalTextColor;
    ticketNumLabel.font = [UIFont systemFontOfSize:12.f];
    ticketNumLabel.text = @"剩余32张";
    [self.contentView addSubview:ticketNumLabel];
    self.ticketNumLabel = ticketNumLabel;
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = kTitleNormalTextColor;
    nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
    nameLabel.text = @"VIP门票";
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //说明
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = kNormalTextColor;
    infoLabel.font = [UIFont systemFontOfSize:12.f];
    infoLabel.text = @"参加贵宾晚宴";
    [self.contentView addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    //状态
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textColor = kNormalTextColor;
    statusLabel.font = [UIFont systemFontOfSize:14.f];
    statusLabel.text = @"已售罄";
    [self.contentView addSubview:statusLabel];
    self.statusLabel = statusLabel;
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


@end
