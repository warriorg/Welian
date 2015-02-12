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

@interface ActivityTicketViewCell ()

@property (assign,nonatomic) UIView *operateView;
@property (assign,nonatomic) UIButton *addBtn;
@property (assign,nonatomic) UIButton *minusBtn;
@property (assign,nonatomic) UILabel *ticketNumLabel;
@property (assign,nonatomic) UILabel *nameLabel;
@property (assign,nonatomic) UILabel *infoLabel;

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    _operateView.size = CGSizeMake(kOperateViewWidth, kOperateViewHeight);
    _operateView.centerY = self.height / 2.f;
    _operateView.right = self.width - kMarginLeft;
    
    _addBtn.size = CGSizeMake(kOperateViewWidth / 3.f, _operateView.height);
    _addBtn.right = _operateView.width;
    _addBtn.centerY = _operateView.height / 2.f;
    
    _minusBtn.size = CGSizeMake(kOperateViewWidth / 3.f, _operateView.height);
    _minusBtn.left = 0.f;
    _minusBtn.centerY = _operateView.height / 2.f;
    
    _ticketNumLabel.size = CGSizeMake(kOperateViewWidth / 3.f, _operateView.height);
    _ticketNumLabel.centerX = _operateView.width / 2.f;
    _ticketNumLabel.centerY = _operateView.height / 2.f;
    _ticketNumLabel.layer.borderColorFromUIColor = [UIColor lightGrayColor];
    _ticketNumLabel.layer.borderWidths = @"{0,0.5,0,0.5}";
    
    [_nameLabel sizeToFit];
    _nameLabel.left = kMarginLeft;
    _nameLabel.bottom = self.height / 2.f;
    
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
    
    //数量
    UILabel *ticketNumLabel = [[UILabel alloc] init];
    ticketNumLabel.textColor = kTitleNormalTextColor;
    ticketNumLabel.font = [UIFont systemFontOfSize:15.f];
    ticketNumLabel.textAlignment = NSTextAlignmentCenter;
    ticketNumLabel.text = @"1";
    [operateView addSubview:ticketNumLabel];
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
}

@end
