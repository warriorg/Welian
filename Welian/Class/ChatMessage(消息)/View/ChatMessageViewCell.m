//
//  ChatMessageViewCell.m
//  Welian
//
//  Created by weLian on 14/12/24.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ChatMessageViewCell.h"

#define kLogoImageWidth 40.f
#define kMarginLeft 15.f

@interface ChatMessageViewCell ()

@property (assign,nonatomic) UIImageView *logoImageView;
@property (assign,nonatomic) UIButton *numBtn;

- (void)setup;

@end

@implementation ChatMessageViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置下边边线
    self.layer.borderColor = RGB(230, 230, 230).CGColor;
    self.layer.borderWidths = @"{0,0,0.5,0}";
    
    //设置头像
    _logoImageView.size = CGSizeMake(kLogoImageWidth, kLogoImageWidth);
    _logoImageView.left = kMarginLeft;
    _logoImageView.centerY = self.height / 2.f;
    
    
}

#pragma mark - Private
- (void)setup
{
    //头像
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.backgroundColor = [UIColor clearColor];
    logoImageView.layer.cornerRadius = 20;
    logoImageView.layer.masksToBounds = YES;
    [self addSubview:logoImageView];
    self.logoImageView = logoImageView;
    [logoImageView setDebug:YES];
    
    [_logoImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"user_small"] options:SDWebImageRetryFailed|SDWebImageLowPriority];
    
    //消息数量
    UIButton *numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    numBtn.backgroundColor = [UIColor clearColor];
    [numBtn setTitle:@"1" forState:UIControlStateNormal];
    [self addSubview:numBtn];
    self.numBtn = numBtn;
    
}

@end
