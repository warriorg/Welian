//
//  NewFriendViewCell.m
//  Welian
//
//  Created by weLian on 15/1/7.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "NewFriendViewCell.h"

#define kLogoWidth 40.f
#define kMarginLeft 15.f
#define kMarginTop 10.f
#define kButtonWidth 50.f
#define kButtonHeight 30.f

@interface NewFriendViewCell ()

@property (assign, nonatomic) UIImageView *logoImageView;
@property (assign, nonatomic) UILabel *nameLabel;
@property (assign, nonatomic) UILabel *messageLabel;
@property (assign, nonatomic) UIButton *operateBtn;

- (void)setup;

@end

@implementation NewFriendViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
    _logoImageView.size = CGSizeMake(kLogoWidth, kLogoWidth);
    _logoImageView.top = kMarginTop;
    _logoImageView.left = kMarginLeft;
    
    [_nameLabel sizeToFit];
    _nameLabel.top = kMarginTop;
    _nameLabel.left = _logoImageView.right + kMarginLeft;
    
    [_messageLabel sizeToFit];
    _messageLabel.top = _nameLabel.bottom + 5.f;
    _messageLabel.left = _nameLabel.left;
    
    _operateBtn.size = CGSizeMake(kButtonWidth, kButtonHeight);
    _operateBtn.right = self.width - kMarginLeft;
    _operateBtn.top = kMarginLeft;
}

#pragma mark - Private
- (void)setup
{
    //头像
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.backgroundColor = [UIColor redColor];
    logoImageView.layer.cornerRadius = 20.f;
    logoImageView.layer.masksToBounds = YES;
    [self addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:16.f];
    nameLabel.text = @"陈日莎";
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //内容
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = [UIColor lightGrayColor];
    messageLabel.font = [UIFont systemFontOfSize:14.f];
    messageLabel.text = @"我的传送门网络技术有限公司的项目经理";
    [self addSubview:messageLabel];
    self.messageLabel = messageLabel;
    
    //操作按钮
    UIButton *operateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [operateBtn setTitle:@"添加" forState:UIControlStateNormal];
    //圆角
    operateBtn.layer.cornerRadius = 5.f;
    operateBtn.layer.masksToBounds = YES;
    operateBtn.backgroundColor = [UIColor redColor];
    [self addSubview:operateBtn];
    self.operateBtn = operateBtn;
}

@end
