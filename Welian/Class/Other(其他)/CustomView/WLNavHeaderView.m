//
//  WLNavHeaderView.m
//  Welian
//
//  Created by weLian on 15/3/31.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WLNavHeaderView.h"

#define kButtonMaxWidth 80.f
#define kButtomMinWith 50.f
#define kMarginLeft 10.f

@interface WLNavHeaderView ()

@property (assign,nonatomic) UIView *contentView;
@property (assign,nonatomic) UIButton *leftBtn;
@property (assign,nonatomic) UIButton *rightBtn;
@property (assign,nonatomic) UILabel *titleLabel;

@property (strong,nonatomic) NSString *leftBtnTitle;
@property (strong,nonatomic) UIImage *leftBtnImage;
@property (strong,nonatomic) NSString *rightBtnTitle;
@property (strong,nonatomic) UIImage *rightBtnImage;

@end

@implementation WLNavHeaderView

- (void)dealloc
{
    _leftClickecBlock = nil;
    _leftBtnImage = nil;
    _leftBtnTitle = nil;
    _rightClickecBlock = nil;
    _rightBtnTitle = nil;
    _rightBtnImage = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setTitleInfo:(NSString *)titleInfo
{
    [super willChangeValueForKey:@"titleInfo"];
    _titleInfo = titleInfo;
    [super didChangeValueForKey:@"titleInfo"];
    
    _titleLabel.text = _titleInfo;
    [self setNeedsLayout];
}

- (void)setLeftBtnTitle:(NSString *)leftBtnTitle LeftBtnImage:(UIImage *)leftBtnImage
{
    self.leftBtnTitle = leftBtnTitle;
    self.leftBtnImage = leftBtnImage;
    
    [_leftBtn setTitle:_leftBtnTitle forState:UIControlStateNormal];
    [_leftBtn setImage:_leftBtnImage forState:UIControlStateNormal];
    if (_leftBtnImage && _leftBtnTitle) {
        _leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }else{
        _leftBtn.titleEdgeInsets = UIEdgeInsetsZero;
    }
    [self setNeedsLayout];
}

- (void)setRightBtnTitle:(NSString *)rightBtnTitle RightBtnImage:(UIImage *)rightBtnImage
{
    self.rightBtnTitle = rightBtnTitle;
    self.rightBtnImage = rightBtnImage;
    
    [_rightBtn setTitle:_rightBtnTitle forState:UIControlStateNormal];
    [_rightBtn setImage:_rightBtnImage forState:UIControlStateNormal];
    if (_rightBtnImage && _rightBtnTitle) {
        _rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }else{
        _rightBtn.titleEdgeInsets = UIEdgeInsetsZero;
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _contentView.size = CGSizeMake(self.width, self.height - StatusBarHeight);
    _contentView.top = StatusBarHeight;
    _contentView.centerX = self.width / 2.f;
    
    [_leftBtn sizeToFit];
    if(_leftBtnTitle && _leftBtnImage)
    {
        _leftBtn.width = _leftBtn.width + 15.f;
    }
    if (_leftBtn.width < kButtomMinWith) {
        _leftBtn.width = kButtomMinWith;
    }
    if (_leftBtn.width > kButtonMaxWidth) {
        _leftBtn.width = kButtonMaxWidth;
    }
    _leftBtn.height = _contentView.height;
    _leftBtn.left = 0.f;
    _leftBtn.centerY = _contentView.height / 2.f;
    
    [_rightBtn sizeToFit];
    if(_rightBtnTitle && _rightBtnImage)
    {
        _rightBtn.width = _leftBtn.width + 15.f;
    }
    if (_rightBtn.width < kButtomMinWith) {
        _rightBtn.width = kButtomMinWith;
    }
    if (_rightBtn.width > kButtonMaxWidth) {
        _rightBtn.width = kButtonMaxWidth;
    }
    _rightBtn.height = _contentView.height;
    _rightBtn.right = _contentView.width;
    _rightBtn.centerY = _contentView.height / 2.f;
    
    _titleLabel.size = CGSizeMake(_rightBtn.left - _leftBtn.right - kMarginLeft * 2.f, _contentView.height);
    _titleLabel.centerX = _contentView.width / 2.f;
    _titleLabel.centerY = _contentView.height / 2.f;
}

#pragma mark - Private
- (void)setup
{
    self.backgroundColor = kNavBgColor;
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.backgroundColor = [UIColor clearColor];
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:leftBtn];
    self.leftBtn = leftBtn;
//    [leftBtn setDebug:YES];
    //设置默认返回按钮
    [self setLeftBtnTitle:@"返回" LeftBtnImage:[UIImage imageNamed:@"navbar_left"]];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.backgroundColor = [UIColor clearColor];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
//    rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    [rightBtn setTitle:@"操作" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:rightBtn];
    self.rightBtn = rightBtn;
//    [rightBtn setDebug:YES];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"标题";
    [contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)leftBtnClicked:(UIButton *)sender
{
    DLog(@"%@ ------  leftBtnClicked",[self class]);
    if (_leftClickecBlock) {
        _leftClickecBlock();
    }
}

- (void)rightBtnClicked:(UIButton *)sender
{
    DLog(@"%@ ------  rightBtnClicked",[self class]);
    if (_rightClickecBlock) {
        _rightClickecBlock();
    }
}

@end
