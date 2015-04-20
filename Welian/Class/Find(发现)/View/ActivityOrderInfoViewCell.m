//
//  ActivityOrderInfoViewCell.m
//  Welian
//
//  Created by weLian on 15/2/28.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityOrderInfoViewCell.h"

#define kMarginLeft 15.f

@interface ActivityOrderInfoViewCell ()

@property (assign,nonatomic) UILabel *nameLabel;
@property (assign,nonatomic) UILabel *numLabel;
@property (assign,nonatomic) UILabel *priceLabel;

@end

@implementation ActivityOrderInfoViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self setup];
}

- (void)setIActivityTicket:(IActivityTicket *)iActivityTicket
{
    [super willChangeValueForKey:@"iActivityTicket"];
    _iActivityTicket = iActivityTicket;
    [super didChangeValueForKey:@"iActivityTicket"];
    _nameLabel.text = _iActivityTicket.name;
    _priceLabel.text = [NSString stringWithFormat:@"￥%@元",_iActivityTicket.price];
    [_priceLabel setAttributedText:[NSObject getAttributedInfoString:_priceLabel.text searchStr:[NSString stringWithFormat:@"￥%@",_iActivityTicket.price] color:KBlueTextColor font:kNormalBlod14Font]];
    _numLabel.text = [NSString stringWithFormat:@"x %@",_iActivityTicket.buyCount];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_numLabel sizeToFit];
    _numLabel.left = self.contentView.width / 2.f;
    _numLabel.centerY = self.contentView.height / 2.f;
    
    [_nameLabel sizeToFit];
    _nameLabel.left = kMarginLeft;
    _nameLabel.centerY = self.contentView.height / 2.f;
    
    [_priceLabel sizeToFit];
    _priceLabel.right = self.contentView.width - kMarginLeft;
    _priceLabel.centerY = self.contentView.height / 2.f;
}

#pragma mark - Private
- (void)setup
{
    //取消选中效果
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //门票名称
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.font = kNormal14Font;
    nameLabel.textColor = kTitleNormalTextColor;
    nameLabel.text = @"VIP门票";
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //门票数量
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.font = kNormal14Font;
    numLabel.textColor = kTitleNormalTextColor;
    numLabel.text = @"x 2";
    [self.contentView addSubview:numLabel];
    self.numLabel = numLabel;
    
    //门票价格
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = kNormal14Font;
    priceLabel.textColor = kTitleNormalTextColor;
    priceLabel.text = @"￥200元";
    [priceLabel setAttributedText:[NSObject getAttributedInfoString:priceLabel.text searchStr:@"￥200" color:KBlueTextColor font:kNormalBlod14Font]];
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;
}

@end
