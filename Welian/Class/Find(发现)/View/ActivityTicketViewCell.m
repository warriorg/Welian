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

#define kMarginTop 10.f
#define kMarginInEdge 5.f

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
@property (assign,nonatomic) UIButton *addImageBtn;
@property (assign,nonatomic) UIButton *minusImageBtn;
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
    
    _addImageBtn.size = CGSizeMake(kOperateViewWidth / 3.f, _operateView.height);
    _addImageBtn.right = _operateView.width;
    _addImageBtn.centerY = _operateView.height / 2.f;
    
    _addBtn.size = CGSizeMake(kOperateViewWidth / 3.f + kMarginLeft, self.height);
    _addBtn.right = self.width;
    _addBtn.centerY = self.height / 2.f;
    
    _minusImageBtn.size = CGSizeMake(kOperateViewWidth / 3.f, _operateView.height);
    _minusImageBtn.left = 0.f;
    _minusImageBtn.centerY = _operateView.height / 2.f;
    
    _minusBtn.size = CGSizeMake(_addBtn.width, self.height);
    _minusBtn.right = _addBtn.left - kOperateViewWidth / 3.f;
    _minusBtn.centerY = self.height / 2.f;
    
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
    _ticketNumLabel.top = self.height / 2.f + kMarginInEdge;
    
    _infoLabel.width = _ticketNumLabel.left - kMarginLeft - 6.f;
    [_infoLabel sizeToFit];
    _infoLabel.left = kMarginLeft;
    if (_iActivityTicket.name.length > 0) {
        _infoLabel.bottom = self.height - kMarginTop;
    }else{
        _infoLabel.centerY = self.height / 2.f;
    }
    
    _nameLabel.width = _moneyLabel.left - kMarginLeft * 2.f;
    [_nameLabel sizeToFit];
    _nameLabel.left = kMarginLeft;
    if (_iActivityTicket.intro.length > 0) {
        _nameLabel.bottom = _infoLabel.top - kMarginInEdge;
    }else{
        _nameLabel.centerY = self.height / 2.f;
    }
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
    UIButton *addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addImageBtn.backgroundColor = [UIColor clearColor];
    [addImageBtn setImage:[UIImage imageNamed:@"discovery_activity_detail_jia"] forState:UIControlStateNormal];
    [operateView addSubview:addImageBtn];
    self.addImageBtn = addImageBtn;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.backgroundColor = [UIColor clearColor];
    [addBtn addTarget:self action:@selector(operateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:addBtn];
    self.addBtn = addBtn;
//    [addBtn setDebug:YES];
    
    //减少按钮
    UIButton *minusImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minusImageBtn.backgroundColor = [UIColor clearColor];
    [minusImageBtn setImage:[UIImage imageNamed:@"discovery_activity_detail_jian"] forState:UIControlStateNormal];
    [operateView addSubview:minusImageBtn];
    self.minusImageBtn = minusImageBtn;
    
    UIButton *minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    minusBtn.backgroundColor = [UIColor clearColor];
    [minusBtn addTarget:self action:@selector(operateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:minusBtn];
    self.minusBtn = minusBtn;
//    [minusBtn setDebug:YES];
    
    //购买数量
    UILabel *buyNumLabel = [[UILabel alloc] init];
    buyNumLabel.textColor = kTitleNormalTextColor;
    buyNumLabel.font = kNormal15Font;
    buyNumLabel.textAlignment = NSTextAlignmentCenter;
    [operateView addSubview:buyNumLabel];
    self.buyNumLabel = buyNumLabel;
    
    //金额
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.textColor = KBlueTextColor;
    moneyLabel.font = kNormalBlod19Font;
    moneyLabel.text = @"500元";
    [moneyLabel setAttributedText:[self getAttributedInfoString:moneyLabel.text searchStr:@"元"]];
    [self.contentView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    //票数量
    UILabel *ticketNumLabel = [[UILabel alloc] init];
    ticketNumLabel.backgroundColor = [UIColor clearColor];
    ticketNumLabel.textColor = kNormalTextColor;
    ticketNumLabel.font = kNormal12Font;
    ticketNumLabel.text = @"剩余32张";
    [self.contentView addSubview:ticketNumLabel];
    self.ticketNumLabel = ticketNumLabel;
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = kTitleNormalTextColor;
    nameLabel.font = kNormalBlod14Font;
    nameLabel.numberOfLines = 0;
    nameLabel.text = @"VIP门票";
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //说明
    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = kNormalTextColor;
    infoLabel.font = kNormal12Font;
    infoLabel.text = @"参加贵宾晚宴";
    infoLabel.numberOfLines = 0;
    [self.contentView addSubview:infoLabel];
    self.infoLabel = infoLabel;
    
    //状态
    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textColor = kNormalTextColor;
    statusLabel.font = kNormal14Font;
    statusLabel.text = @"已售罄";
    [self.contentView addSubview:statusLabel];
    self.statusLabel = statusLabel;
}

- (void)operateBtnClicked:(UIButton *)sender
{
    if ([sender isEqual:_addBtn]) {
        //添加
        if (_iActivityTicket.ticketCount.integerValue - _iActivityTicket.joined.integerValue > 0) {
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

//返回cell的高度
+ (CGFloat)configureWithName:(NSString *)name DetailInfo:(NSString *)detailInfo
{
    float maxWidth = [[UIScreen mainScreen] bounds].size.width / 2.f - kMarginLeft * 2.f;
    //计算第一个label的高度
    CGSize size1 = [name calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:kNormal14Font];
    CGSize size2 = [detailInfo calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:kNormal12Font];
    
    float height = (name.length > 0 ? size1.height : 0) + (detailInfo.length > 0 ? size2.height + kMarginInEdge : 0) + kMarginTop * 2.f;
    if (height > 60.f) {
        return height;
    }else{
        return 60.f;
    }
}


@end
