//
//  WLMessageCardView.m
//  Welian
//
//  Created by weLian on 15/3/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WLMessageCardView.h"

#define InfoMaxWidth CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.69)
// (CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.55 : 0.7))
#define kCardViewHeight 56.f
#define kPaddingTop 8.0f
#define kMarginLeft 8.f

@interface WLMessageCardView ()

@property (assign,nonatomic) MLEmojiLabel *titleLabel;
@property (assign,nonatomic) UIImageView *lineView;

@end

@implementation WLMessageCardView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setCardInfo:(CardStatuModel *)cardInfo
{
    [super willChangeValueForKey:@"cardInfo"];
    _cardInfo = cardInfo;
    [super didChangeValueForKey:@"cardInfo"];
    _titleLabel.text = _cardInfo.content;
    _cardView.cardM = _cardInfo;
    //是否隐藏分割线
    _lineView.hidden = _cardInfo.content.length > 0 ? NO : YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.width = self.width - kMarginLeft * 2.f;
//    [_titleLabel sizeToFit];
    CGSize titleSize = [_titleLabel preferredSizeWithMaxWidth:(InfoMaxWidth - kMarginLeft * 2)];
    _titleLabel.size = CGSizeMake(titleSize.width, titleSize.height);
//    CGFloat leftWith = (self.width - titleSize.width) / 2.f ;
//    _titleLabel.left = leftWith > 12.f ? kMarginLeft : leftWith;
//    if (titleSize.width < self.width - kMarginLeft * 2) {
        _titleLabel.left = kMarginLeft;
//    }else{
//        _titleLabel.centerX = self.width / 2.f;
//    }
    _titleLabel.top = kPaddingTop;
    
    _cardView.size = CGSizeMake(self.width, kCardViewHeight);
    _cardView.centerX = self.width / 2.f;
    if (_cardInfo.content.length > 0) {
        _cardView.bottom = self.height;
    }else{
        _cardView.centerY = self.height / 2.f;
    }
    
    _lineView.size = CGSizeMake(self.width - kMarginLeft * 2.f, 1.5f);
    _lineView.centerX = self.width / 2.f;
    _lineView.bottom = _cardView.top;
}

#pragma mark - Private
- (void)setup
{
//    [self setDebug:YES];
    MLEmojiLabel *titleLabel = [[MLEmojiLabel alloc]init];
    titleLabel.numberOfLines = 0;
    //            displayLabel.emojiDelegate = self;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor  = kTitleNormalTextColor;
//    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
//    [titleLabel setDebug:YES];
    
    //分割线
    UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"circle_chat_line"]];
    lineView.backgroundColor = [UIColor clearColor];
    [self addSubview:lineView];
    self.lineView = lineView;
    
    //初始化现实卡片的view
    WLCellCardView *cardView = [[WLCellCardView alloc] init];
    cardView.backgroundColor = [UIColor clearColor];
    cardView.isHidLine = YES;//隐藏边线
    cardView.tapBut.hidden = YES;
    [self addSubview:cardView];
    self.cardView = cardView;
//    [cardView setDebug:YES];
}



/**
 *  根据消息Model对象计算消息内容的高度
 *
 *  @param message 目标消息Model对象
 *
 *  @return 返回所需高度
 */
+ (CGFloat)calculateCellHeightWithMessage:(id <WLMessageModel>)message
{
    CGFloat textHeight = 0.f;
    if (message.cardMsg.length > 0) {
        MLEmojiLabel *displayLabel = [[MLEmojiLabel alloc]init];
        displayLabel.numberOfLines = 0;
        //    displayLabel.emojiDelegate = self;
        displayLabel.lineBreakMode = NSLineBreakByCharWrapping;
        displayLabel.font = [UIFont systemFontOfSize:16.f];
        displayLabel.text = message.cardMsg;
        
        textHeight = [displayLabel preferredSizeWithMaxWidth:(InfoMaxWidth - kMarginLeft * 2)].height + 5.f;
    }else{
        textHeight = -kPaddingTop;
    }
    return textHeight + kCardViewHeight;
}

+ (CGSize)calculateCellSizeWithMessage:(id <WLMessageModel>)message
{
    CGFloat textHeight = 0.f;
    CGFloat textWidth = 0.f;
    if (message.cardMsg.length > 0) {
        MLEmojiLabel *displayLabel = [[MLEmojiLabel alloc]init];
        displayLabel.numberOfLines = 0;
        //    displayLabel.emojiDelegate = self;
        displayLabel.lineBreakMode = NSLineBreakByCharWrapping;
        displayLabel.font = [UIFont systemFontOfSize:16.f];
        displayLabel.text = message.cardMsg;
        
        CGSize textSize = [displayLabel preferredSizeWithMaxWidth:(InfoMaxWidth - kMarginLeft * 2)];
        textHeight = textSize.height + 5.f;
        textWidth = textSize.width;
    }else{
        textHeight = -kPaddingTop;
    }
    return CGSizeMake(InfoMaxWidth , textHeight + kCardViewHeight);
//    return CGSizeMake(textWidth == 0 ? (InfoMaxWidth - kMarginLeft * 2) : textWidth, textHeight + kCardViewHeight);
}

@end
