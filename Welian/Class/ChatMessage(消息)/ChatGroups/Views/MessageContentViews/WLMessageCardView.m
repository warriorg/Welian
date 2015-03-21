//
//  WLMessageCardView.m
//  Welian
//
//  Created by weLian on 15/3/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WLMessageCardView.h"

#define InfoMaxWidth (CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.55 : 0.7))
#define kCardViewHeight 56.f
#define kPaddingTop 8.0f
#define kMarginLeft 8.f

@interface WLMessageCardView ()

@property (assign,nonatomic) MLEmojiLabel *titleLabel;

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
    _titleLabel.text = cardInfo.content;
    _cardView.cardM = cardInfo;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_titleLabel sizeToFit];
    _titleLabel.left = kMarginLeft;
    _titleLabel.top = kPaddingTop;
    
    _cardView.size = CGSizeMake(self.width, kCardViewHeight);
    _cardView.centerX = self.width / 2.f;
    _cardView.bottom = self.height;
}

#pragma mark - Private
- (void)setup
{
    MLEmojiLabel *titleLabel = [[MLEmojiLabel alloc]init];
    titleLabel.numberOfLines = 0;
    //            displayLabel.emojiDelegate = self;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor  = kTitleNormalTextColor;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
//    [titleLabel setDebug:YES];
    
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
    if (message.text.length > 0) {
        MLEmojiLabel *displayLabel = [[MLEmojiLabel alloc]init];
        displayLabel.numberOfLines = 0;
        //    displayLabel.emojiDelegate = self;
        displayLabel.lineBreakMode = NSLineBreakByCharWrapping;
        displayLabel.font = [UIFont systemFontOfSize:16.f];
        displayLabel.text = message.text;
        
        textHeight = [displayLabel preferredSizeWithMaxWidth:InfoMaxWidth - kMarginLeft].height + 5.f;
    }
    return textHeight + kCardViewHeight;
}

@end
