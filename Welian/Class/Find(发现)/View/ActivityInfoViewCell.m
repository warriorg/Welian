//
//  ActivityInfoViewCell.m
//  Welian
//
//  Created by weLian on 15/2/12.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "ActivityInfoViewCell.h"

#define kMarginLeft 15.f
#define kMarginEdge 5.f
#define kButtonHeight 20.f

@interface ActivityInfoViewCell ()

@property (assign,nonatomic) UIButton *detailBtn;

@end

@implementation ActivityInfoViewCell

- (void)dealloc
{
    _block = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.width = self.width - kMarginLeft * 2.f;
    [self.textLabel sizeToFit];
    self.textLabel.left = kMarginLeft;
    self.textLabel.top = kMarginLeft;
    
    self.detailTextLabel.width = self.width - kMarginLeft * 2.f;
    [self.detailTextLabel sizeToFit];
    self.detailTextLabel.left = kMarginLeft;
    self.detailTextLabel.top = self.textLabel.text.length > 0 ? self.textLabel.bottom + kMarginEdge : kMarginLeft;
    
//    [_detailTextView sizeToFit];
//    _detailTextView.left = kMarginLeft;
//    _detailTextView.top = self.textLabel.text.length > 0 ? self.textLabel.bottom + kMarginEdge : kMarginLeft;
    
    _detailBtn.size = CGSizeMake(self.width, self.height - self.detailTextLabel.bottom);
    _detailBtn.top = self.detailTextLabel.bottom;
    _detailBtn.centerX = self.width / 2.f;
}

#pragma mark - Private
- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //标题
    self.textLabel.textColor = RGB(125.f, 125.f, 125.f);
    self.textLabel.font = kNormal14Font;
    self.textLabel.numberOfLines = 0.f;
    
    //详情
    self.detailTextLabel.textColor = kTitleNormalTextColor;
    self.detailTextLabel.font = kNormal14Font;
    self.detailTextLabel.numberOfLines = 0;
    
    //详情
    UITextView *detailTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    detailTextView.font = kNormal14Font;
    detailTextView.textColor = kTitleNormalTextColor;
    [self.contentView addSubview:detailTextView];
    self.detailTextView = detailTextView;
    
    //查看活动详情按钮
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.backgroundColor = [UIColor clearColor];
    detailBtn.titleLabel.font = kNormal14Font;
    [detailBtn setTitle:@"上拉查看图文详情" forState:UIControlStateNormal];
    [detailBtn setTitleColor:kNormalTextColor forState:UIControlStateNormal];
//    [detailBtn setImage:[UIImage imageNamed:@"discovery_activity_detail_more"] forState:UIControlStateNormal];
//    detailBtn.imageEdgeInsets = UIEdgeInsetsMake(0,180,0,0);
//    detailBtn.titleEdgeInsets = UIEdgeInsetsMake(0,-50, 0, 0);
    [detailBtn addTarget:self action:@selector(detailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:detailBtn];
    self.detailBtn = detailBtn;
//    [detailBtn setDebug:YES];
}

- (void)detailBtnClicked:(UIButton *)sender
{
    if (_block) {
        _block();
    }
}

//返回cell的高度
+ (CGFloat)configureWithTitle:(NSString *)title Msg:(NSString *)msg
{
    float maxWidth = [[UIScreen mainScreen] bounds].size.width - kMarginLeft * 2.f;
    //计算第一个label的高度
    CGSize size1 = [title calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:kNormal14Font];
    CGSize size2 = [msg calculateSize:CGSizeMake(maxWidth, FLT_MAX) font:kNormal14Font];
    
    float height = (title.length > 0 ? size1.height : 0) + size2.height + kMarginEdge * 2.f + kButtonHeight * 2.f + kMarginLeft * 2.f;
    if (height > 60.f) {
        return height;
    }else{
        return 60.f;
    }
}

@end
