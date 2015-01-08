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

#define BtnTianJiaColor RGB(247.f, 247.f, 247.f)
#define BtnJieShouColor RGB(79.f, 191.f, 232.f)
#define LayerBorderColor RGB(231.f, 231.f, 231.f)

@interface NewFriendViewCell ()

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
    
    _operateBtn.size = CGSizeMake(kButtonWidth, kButtonHeight);
    _operateBtn.right = self.width - kMarginLeft;
    _operateBtn.top = kMarginLeft;
    
    [_nameLabel sizeToFit];
    _nameLabel.left = _logoImageView.right + kMarginLeft;
    if (_messageLabel.text.length == 0) {
        _nameLabel.centerY = self.height / 2.f;
    }else{
       _nameLabel.top = kMarginTop;
    }
    
    _messageLabel.width = _operateBtn.left - _nameLabel.left - kMarginLeft;
    [_messageLabel sizeToFit];
    _messageLabel.top = _nameLabel.bottom + 5.f;
    _messageLabel.left = _nameLabel.left;
}

#pragma mark - Private
- (void)setup
{
    //头像
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.backgroundColor = [UIColor clearColor];
    logoImageView.layer.cornerRadius = 20.f;
    logoImageView.layer.masksToBounds = YES;
    [self addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    //名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:16.f];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //内容
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = [UIColor lightGrayColor];
    messageLabel.font = [UIFont systemFontOfSize:14.f];
    messageLabel.numberOfLines = 0.f;
    [self addSubview:messageLabel];
    self.messageLabel = messageLabel;
    
    //操作按钮
    UIButton *operateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [operateBtn setTitle:@"添加" forState:UIControlStateNormal];
    [operateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    operateBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    //圆角
    operateBtn.layer.cornerRadius = 5.f;
    operateBtn.layer.masksToBounds = YES;
    operateBtn.layer.borderWidth = 0.5;
    operateBtn.layer.borderColor = LayerBorderColor.CGColor;
    operateBtn.backgroundColor = BtnTianJiaColor;
    [self addSubview:operateBtn];
    self.operateBtn = operateBtn;
}

//返回cell的高度
+ (CGFloat)configureWith
{
    float maxWidth = [[UIScreen mainScreen] bounds].size.width - kLogoWidth - kButtonWidth - kMarginLeft * 4.f;
    //计算第一个label的高度
    CGSize size1 = [@"陈日莎" calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:[UIFont systemFontOfSize:16.f]];
    //计算第二个label的高度
    CGSize size2 = [@"我的传送门网络技术有限公司的项目经理" calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:[UIFont systemFontOfSize:14.f]];
    
    float height = size1.height + size2.height + kMarginTop * 2.f;
    if (height > 60) {
        return height;
    }else{
        return 60;
    }
}

@end
