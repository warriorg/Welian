//
//  WLMessageSpecialView.m
//  Welian
//
//  Created by weLian on 14/12/31.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLMessageSpecialView.h"
#import "WLMessageBubbleHelper.h"

#define kMarginLeft 10
#define kOutMarginLeft 19
#define kTextLineSpacing 3

#define kMarginTop 10

@interface WLMessageSpecialView ()

@end

@implementation WLMessageSpecialView


/**
 *  初始化消息内容显示控件的方法
 *
 *  @param frame   目标Frame
 *  @param message 目标消息Model对象
 *
 *  @return 返回XHMessageBubbleView类型的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <WLMessageModel>)message{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _message = message;
        
        self.backgroundColor = RGB(213.f, 214.f, 216.f);
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        
        // 2、初始化显示文本消息的TextView
        if (!_specialTextView) {
            SETextView *specialTextView = [[SETextView alloc] initWithFrame:CGRectZero];
            specialTextView.backgroundColor = [UIColor clearColor];
            specialTextView.selectable = NO;
            specialTextView.lineSpacing = kTextLineSpacing;
            specialTextView.font = [UIFont systemFontOfSize:16.f];
            specialTextView.showsEditingMenuAutomatically = NO;
            //设置字体颜色
            specialTextView.textColor = [UIColor whiteColor];
            specialTextView.highlighted = NO;
//            specialTextView.delegate = self;
            [self addSubview:specialTextView];
            _specialTextView = specialTextView;
            //            [displayTextView setDebug:YES];
        }
        //        _specialTextView.attributedText = [[WLMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:[message text]];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _specialTextView.frame = [self bubbleFrame];
}

/**
 *  根据消息Model对象配置消息显示内容
 *
 *  @param message 目标消息Model对象
 */
- (void)configureCellWithMessage:(id <WLMessageModel>)message
{
    _specialTextView.text = message.text;
    
    [self setNeedsLayout];
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
    CGSize size = [WLMessageSpecialView neededSizeForText:message.text];
    return size.height + kMarginTop * 2.f; //+ kMarginTop + kMarginBottom;
}

+ (CGFloat)neededWidthForText:(NSString *)text {
    CGSize stringSize;
    stringSize = [text sizeWithFont:[UIFont systemFontOfSize:16]
                  constrainedToSize:CGSizeMake(MAXFLOAT, 19)];
    return roundf(stringSize.width);
}

+ (CGSize)neededSizeForText:(NSString *)text {
    CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) - kMarginLeft * 2.f - kOutMarginLeft * 2.f;
    
//    CGFloat dyWidth = [WLMessageSpecialView neededWidthForText:text];
    
    CGSize textSize = [SETextView frameRectWithAttributtedString:[[WLMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:text] constraintSize:CGSizeMake(maxWidth, MAXFLOAT) lineSpacing:kTextLineSpacing font:[UIFont systemFontOfSize:16]].size;
    return CGSizeMake(maxWidth, textSize.height);
    //    return CGSizeMake((dyWidth > textSize.width ? textSize.width : dyWidth) + kBubblePaddingRight * 2 + kWLArrowMarginWidth, textSize.height + kMarginTop);
}

- (CGRect)bubbleFrame {
    CGSize bubbleSize = [WLMessageSpecialView neededSizeForText:self.message.text];
    
    return CGRectMake(kMarginLeft, kMarginTop, self.width - kMarginLeft * 2.f, bubbleSize.height + kMarginTop * 2);
//    return CGRectIntegral(CGRectMake((self.message.bubbleMessageType == WLBubbleMessageTypeSending ? CGRectGetWidth(self.bounds) - bubbleSize.width : 0.0f),
//                                     kMarginTop,
//                                     bubbleSize.width,
//                                     bubbleSize.height + kMarginTop + kMarginBottom));
}


@end
