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
@property (assign,nonatomic) int buyNum;

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
    
    self.buyNum = _iActivityTicket.buyCount.intValue;
    _buyNumLabel.text = [NSString stringWithFormat:@"%d",_buyNum];
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
    _moneyLabel.bottom = self.height / 2.f - 2.f;
    
    [_ticketNumLabel sizeToFit];
    _ticketNumLabel.right = _moneyLabel.right;
    _ticketNumLabel.top = self.height / 2.f + 3.f;
    
    _nameLabel.width = _moneyLabel.left - kMarginLeft * 2.f;
    [_nameLabel sizeToFit];
    _nameLabel.left = kMarginLeft;
    _nameLabel.bottom = self.height / 2.f - 2.f;
    
    _infoLabel.width = _ticketNumLabel.left - kMarginLeft - 6.f;
    [_infoLabel sizeToFit];
    _infoLabel.left = kMarginLeft;
    _infoLabel.top = self.height / 2.f + (_infoLabel.height < 20.f ? 2.f : -1.f);
}

#pragma mark - Private
- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.buyNum = 0;
    
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
    [addBtn addTarget:self action:@selector(operateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [operateView addSubview:addBtn];
    self.addBtn = addBtn;
    
    //减少按钮
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [minusBtn setImage:[UIImage imageNamed:@"discovery_activity_detail_jian"] forState:UIControlStateNormal];
    [minusBtn addTarget:self action:@selector(operateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [operateView addSubview:minusBtn];
    self.minusBtn = minusBtn;
    
    //购买数量
    UILabel *buyNumLabel = [[UILabel alloc] init];
    buyNumLabel.textColor = kTitleNormalTextColor;
    buyNumLabel.font = [UIFont systemFontOfSize:15.f];
    buyNumLabel.textAlignment = NSTextAlignmentCenter;
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
    infoLabel.numberOfLines = 2;
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

- (void)operateBtnClicked:(UIButton *)sender
{
    if ([sender isEqual:_addBtn]) {
        //添加
        if (_buyNum < (_iActivityTicket.ticketCount.integerValue - _iActivityTicket.joined.integerValue)) {
            _buyNum++;
            _iActivityTicket.joined = @(_iActivityTicket.joined.integerValue + 1);
        }
    }else{
        if (_buyNum > 0) {
            _buyNum--;
            _iActivityTicket.joined = @(_iActivityTicket.joined.integerValue - 1);
        }
    }
    //设置cell是否选中
    [self setSelected:_buyNum > 0 ? YES : NO animated:NO];
    _iActivityTicket.buyCount = @(_buyNum);
    _buyNumLabel.text = [NSString stringWithFormat:@"%d",_buyNum];
    _ticketNumLabel.text = [NSString stringWithFormat:@"剩余%d张",_iActivityTicket.ticketCount.intValue - _iActivityTicket.joined.intValue];
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
