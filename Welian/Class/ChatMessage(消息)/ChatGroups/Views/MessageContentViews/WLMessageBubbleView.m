//
//  WLMessageBubbleView.m
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLMessageBubbleView.h"
#import "WLMessageBubbleHelper.h"
#import "CardStatuModel.h"
//#import "SEConstants.h"

#define kMarginTop 8.0f
#define kMarginBottom 2.0f
#define kPaddingTop 8.0f
#define kBubblePaddingRight 14.0f

#define kVoiceMargin 20.0f

#define kWLArrowMarginWidth 14

#define PHOTO_MAX_SIZE_WIDTH ([[UIScreen mainScreen] bounds].size.width / 3)
#define PHOTO_MAX_SIZE_HEIGHT ([[UIScreen mainScreen] bounds].size.height / 3.5)

#define InfoMaxWidth (CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.55 : 0.7))

@interface WLMessageBubbleView ()

//@property (nonatomic, weak, readwrite) SETextView *displayTextView;
@property (nonatomic, weak, readwrite) MLEmojiLabel *displayLabel;

//用于显示卡片类型的控件
@property (nonatomic, weak, readwrite) WLCellCardView *displayCardView;

@property (nonatomic, weak, readwrite) UIImageView *bubbleImageView;

@property (nonatomic, weak, readwrite) FLAnimatedImageView *emotionImageView;

@property (nonatomic, weak, readwrite) UIImageView *animationVoiceImageView;

@property (nonatomic, weak, readwrite) UIImageView *voiceUnreadDotImageView;

@property (nonatomic, weak, readwrite) WLBubblePhotoImageView *bubblePhotoImageView;

@property (nonatomic, weak, readwrite) UIImageView *videoPlayImageView;

@property (nonatomic, weak, readwrite) UILabel *geolocationsLabel;

@property (nonatomic, strong, readwrite) id <WLMessageModel> message;

@end

@implementation WLMessageBubbleView


#pragma mark - Bubble view
+ (CGSize)fitsize:(CGSize)thisSize
{
    if(thisSize.width == 0 && thisSize.height ==0)
        return CGSizeMake(0, 0);
    CGFloat wscale = thisSize.width/PHOTO_MAX_SIZE_WIDTH;
    CGFloat hscale = thisSize.height/PHOTO_MAX_SIZE_HEIGHT;
    CGFloat scale = (wscale > hscale) ? wscale:hscale;
    if ((thisSize.height / wscale) > PHOTO_MAX_SIZE_HEIGHT) {
        //长图
        return CGSizeMake(PHOTO_MAX_SIZE_WIDTH, PHOTO_MAX_SIZE_HEIGHT);
    }else{
        CGSize newSize = CGSizeMake(thisSize.width/scale, thisSize.height/scale);
        return newSize;
    }
}

+ (CGFloat)neededWidthForText:(NSString *)text {
    CGSize stringSize;
    stringSize = [text sizeWithFont:[[WLMessageBubbleView appearance] font]
                  constrainedToSize:CGSizeMake(MAXFLOAT, 19)];
    return roundf(stringSize.width);
}

+ (CGSize)neededSizeForText:(NSString *)text {
    CGFloat maxWidth = InfoMaxWidth;
    
    CGFloat dyWidth = [WLMessageBubbleView neededWidthForText:text];
    
//    CGSize textSize = [SETextView frameRectWithAttributtedString:[[WLMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:text] constraintSize:CGSizeMake(maxWidth, MAXFLOAT) lineSpacing:kWLTextLineSpacing font:[[WLMessageBubbleView appearance] font]].size;
    
    MLEmojiLabel *displayLabel = [[MLEmojiLabel alloc]init];
    displayLabel.numberOfLines = 0;
//    displayLabel.emojiDelegate = self;
    displayLabel.lineBreakMode = NSLineBreakByCharWrapping;
    displayLabel.font = [[WLMessageBubbleView appearance] font];
    displayLabel.text = text;
//    displayLabel.textColor = WLRGB(51, 51, 51);
//    displayLabel.backgroundColor = [UIColor clearColor];
//    [self addSubview:displayLabel];
    
    CGSize textSize = [displayLabel preferredSizeWithMaxWidth:maxWidth];
    
    return CGSizeMake((dyWidth > textSize.width ? textSize.width : dyWidth) + kBubblePaddingRight * 2 + kWLArrowMarginWidth, textSize.height + kMarginTop * 2);
//    return CGSizeMake((dyWidth > textSize.width ? textSize.width : dyWidth) + kBubblePaddingRight * 2 + kWLArrowMarginWidth, textSize.height + kMarginTop);
}

+ (CGSize)neededSizeForPhoto:(UIImage *)photo {
    // 这里需要缩放后的size[self fitsize:photo.size];//
    CGSize photoSize = [self fitsize:photo.size];// CGSizeMake(120, 120);
    return photoSize;
}

+ (CGSize)neededSizeForVoicePath:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration {
    // 这里的100只是暂时固定，到时候会根据一个函数来计算
    float gapDuration = (!voiceDuration || voiceDuration.length == 0 ? -1 : [voiceDuration floatValue] - 1.0f);
    CGSize voiceSize = CGSizeMake(100 + (gapDuration > 0 ? (120.0 / (60 - 1) * gapDuration) : 0), 30);
    return voiceSize;
}

+ (CGFloat)calculateCellHeightWithMessage:(id <WLMessageModel>)message {
    CGSize size = [WLMessageBubbleView getBubbleFrameWithMessage:message];
    return size.height + kMarginTop + kMarginBottom;
//    return size.height;
}

+ (CGSize)getBubbleFrameWithMessage:(id <WLMessageModel>)message {
    CGSize bubbleSize;
    switch (message.messageMediaType) {
        case WLBubbleMessageMediaTypeActivity://活动
        case WLBubbleMessageMediaTypeText: {
            bubbleSize = [WLMessageBubbleView neededSizeForText:message.text];
            break;
        }
        case WLBubbleMessageMediaTypeCard:
        {
            DLog(@"cardType-----%@",message.cardType);
            switch (message.cardType.integerValue) {
                case WLBubbleMessageCardTypeActivity:
                case WLBubbleMessageCardTypeProject:
                case WLBubbleMessageCardTypeWeb:
                    bubbleSize = CGSizeMake(InfoMaxWidth, 56.f);
                    break;
                default:
                    //其他展示文本类型
                    bubbleSize = [WLMessageBubbleView neededSizeForText:message.text];
                    break;
            }
        }
            break;
        case WLBubbleMessageMediaTypePhoto: {
            bubbleSize = [WLMessageBubbleView neededSizeForPhoto:message.photo];
            break;
        }
        case WLBubbleMessageMediaTypeVideo: {
            bubbleSize = [WLMessageBubbleView neededSizeForPhoto:message.videoConverPhoto];
            break;
        }
        case WLBubbleMessageMediaTypeVoice: {
            // 这里的宽度是不定的，高度是固定的，根据需要根据语音长短来定制啦
            bubbleSize = [WLMessageBubbleView neededSizeForVoicePath:message.voicePath voiceDuration:message.voiceDuration];
            break;
        }
        case WLBubbleMessageMediaTypeEmotion:
            // 是否固定大小呢？
            bubbleSize = CGSizeMake(100, 100);
            break;
        case WLBubbleMessageMediaTypeLocalPosition:
            // 固定大小，必须的
            bubbleSize = CGSizeMake(119, 119);
            break;
        default:
        {
            //其他展示文本类型
            bubbleSize = [WLMessageBubbleView neededSizeForText:message.text];
        }
            break;
    }
    return bubbleSize;
}

#pragma mark - UIAppearance Getters

- (UIFont *)font {
    if (_font == nil) {
        _font = [[[self class] appearance] font];
    }
    
    if (_font != nil) {
        return _font;
    }
    
    return [UIFont systemFontOfSize:16.0f];
}

#pragma mark - Getters


- (CGRect)bubbleFrame {
    CGSize bubbleSize = [WLMessageBubbleView getBubbleFrameWithMessage:self.message];
    
    return CGRectIntegral(CGRectMake((self.message.bubbleMessageType == WLBubbleMessageTypeSending ? CGRectGetWidth(self.bounds) - bubbleSize.width : 0.0f),
                                     kMarginTop,
                                     bubbleSize.width,
                                     bubbleSize.height + kMarginTop + kMarginBottom));
}

#pragma mark - Life cycle

- (void)configureCellWithMessage:(id <WLMessageModel>)message {
    self.message = message;
    
    [self configureBubbleImageView:message];
    
    [self configureMessageDisplayMediaWithMessage:message];
}

- (void)configureBubbleImageView:(id <WLMessageModel>)message {
    WLBubbleMessageMediaType currentType = message.messageMediaType;
    
    _voiceDurationLabel.hidden = YES;
    //是否发送失败
    if (message.sended.intValue == 2 && message.bubbleMessageType == WLBubbleMessageTypeSending) {
        //发送失败，需要手动点击重发
        [_sendFailedBtn setHidden:NO];
    }else{
        [_sendFailedBtn setHidden:YES];
    }
    
    //停止加载
    if ((message.bubbleMessageType == WLBubbleMessageTypeSending && message.sended.intValue != 0) || (message.bubbleMessageType == WLBubbleMessageTypeReceiving)){
        [_activityIndicatorView stopAnimating];
    }else{
        [_activityIndicatorView startAnimating];
    }
    
    switch (currentType) {
//        case WLBubbleMessageMediaTypeVoice: {
//            _voiceDurationLabel.hidden = NO;
//            if (message.isRead == NO) {
//                _voiceUnreadDotImageView.hidden = NO;
//            }
//        }
        case WLBubbleMessageMediaTypeActivity://活动
        case WLBubbleMessageMediaTypeCard://卡片
        case WLBubbleMessageMediaTypeText:
//        case WLBubbleMessageMediaTypeEmotion:
        {
            _bubbleImageView.image = [WLMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:WLBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
            _bubbleImageView.hidden = NO;
            
            // 只要是文本、语音、第三方表情，都需要把显示尖嘴图片的控件隐藏了
            _bubblePhotoImageView.hidden = YES;
            
            //卡片
            _displayCardView.hidden = YES;
            
            if (currentType == WLBubbleMessageMediaTypeText) {
                // 如果是文本消息，那文本消息的控件需要显示
//                _displayTextView.hidden = NO;
                _displayLabel.hidden = NO;
                
                // 那语言的gif动画imageView就需要隐藏了
                _animationVoiceImageView.hidden = YES;
                _emotionImageView.hidden = YES;
            } else {
                // 那如果不文本消息，必须把文本消息的控件隐藏了啊
//                _displayTextView.hidden = YES;
                _displayLabel.hidden = YES;
                
                // 对语音消息的进行特殊处理，第三方表情可以直接利用背景气泡的ImageView控件
                if (currentType == WLBubbleMessageMediaTypeVoice) {
                    [_animationVoiceImageView removeFromSuperview];
                    _animationVoiceImageView = nil;
                    
                    UIImageView *animationVoiceImageView = [WLMessageVoiceFactory messageVoiceAnimationImageViewWithBubbleMessageType:message.bubbleMessageType];
                    [self addSubview:animationVoiceImageView];
                    _animationVoiceImageView = animationVoiceImageView;
                    _animationVoiceImageView.hidden = NO;
                }else if (currentType == WLBubbleMessageMediaTypeCard) {
                    switch (message.cardType.integerValue) {
                        case WLBubbleMessageCardTypeActivity:
                        case WLBubbleMessageCardTypeProject:
                        case WLBubbleMessageCardTypeWeb:
                        {
                            //卡片
                            _displayCardView.hidden = NO;
                            
                            // 那语言的gif动画imageView就需要隐藏了
                            _animationVoiceImageView.hidden = YES;
                            _emotionImageView.hidden = YES;
                        }
                            break;
                        default:
                            //其他展示文本类型
                        {
                            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
                            _bubbleImageView.hidden = NO;
                            
                            // 只要是文本、语音、第三方表情，都需要把显示尖嘴图片的控件隐藏了
                            _bubblePhotoImageView.hidden = YES;
                            
                            // 如果是文本消息，那文本消息的控件需要显示
                            //                _displayTextView.hidden = NO;
                            _displayLabel.hidden = NO;
                            // 那语言的gif动画imageView就需要隐藏了
                            _animationVoiceImageView.hidden = YES;
                            _emotionImageView.hidden = YES;
                        }
                            break;
                    }
                }else{
                    _emotionImageView.hidden = NO;
                    
                    _bubbleImageView.hidden = YES;
                    _animationVoiceImageView.hidden = YES;
                }
            }
            break;
        }
        case WLBubbleMessageMediaTypePhoto:
//        case WLBubbleMessageMediaTypeVideo:
//        case WLBubbleMessageMediaTypeLocalPosition:
        {
            // 只要是图片和视频消息，必须把尖嘴显示控件显示出来
            _bubblePhotoImageView.hidden = NO;
            
            _videoPlayImageView.hidden = (currentType != WLBubbleMessageMediaTypeVideo);
            
            _geolocationsLabel.hidden = (currentType != WLBubbleMessageMediaTypeLocalPosition);
            
            // 那其他的控件都必须隐藏
//            _displayTextView.hidden = YES;
            _displayLabel.hidden = YES;
            _bubbleImageView.hidden = YES;
            _animationVoiceImageView.hidden = YES;
            _emotionImageView.hidden = YES;
            //卡片
            _displayCardView.hidden = YES;
            break;
        }
        default:
        {
            _bubbleImageView.image = [WLMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:WLBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
            _bubbleImageView.hidden = NO;
            
            // 只要是文本、语音、第三方表情，都需要把显示尖嘴图片的控件隐藏了
            _bubblePhotoImageView.hidden = YES;
            
            // 如果是文本消息，那文本消息的控件需要显示
            //                _displayTextView.hidden = NO;
            _displayLabel.hidden = NO;
            _displayCardView.hidden = YES;
            // 那语言的gif动画imageView就需要隐藏了
            _animationVoiceImageView.hidden = YES;
            _emotionImageView.hidden = YES;
        }
            break;
    }
}

- (void)configureMessageDisplayMediaWithMessage:(id <WLMessageModel>)message {
    switch (message.messageMediaType) {
        case WLBubbleMessageMediaTypeActivity://活动
        case WLBubbleMessageMediaTypeText:
            // 设置表情
//            _displayLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
//            _displayLabel.customEmojiPlistName = @"expressionImage_custom";
//            _displayLabel.frame = textFrame;
            //设置文字
            _displayLabel.textColor = [message bubbleMessageType] == WLBubbleMessageTypeReceiving ? [UIColor blackColor] : [UIColor whiteColor];
            _displayLabel.text = message.text;
            
//            _displayTextView.attributedText = [[WLMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:[message text] withTextColor:[UIColor blackColor]];
//            //设置字体颜色
//            _displayTextView.textColor = [message bubbleMessageType] == WLBubbleMessageTypeReceiving ? [UIColor blackColor] : [UIColor whiteColor];
//            _displayTextView.attributedText = [[NSAttributedString alloc] initWithString:@"发送好友请求"];
            //链接颜色
//            _displayTextView.linkHighlightColor = [UIColor blueColor];
//            _displayTextView.linkRolloverEffectColor = [UIColor blueColor];
//            _displayTextView.selectedTextBackgroundColor = [UIColor blueColor];
//            _displayTextView.highlightedTextColor = [UIColor redColor];
//            _displayTextView.textColor = [UIColor redColor];
            break;
        case WLBubbleMessageMediaTypePhoto:
            [_bubblePhotoImageView configureMessagePhoto:message.photo thumbnailUrl:nil originPhotoUrl:message.originPhotoUrl onBubbleMessageType:self.message.bubbleMessageType];
            break;
//        case WLBubbleMessageMediaTypeVideo:
//            [_bubblePhotoImageView configureMessagePhoto:message.videoConverPhoto thumbnailUrl:nil originPhotoUrl:message.originPhotoUrl onBubbleMessageType:self.message.bubbleMessageType];
//            break;
//        case WLBubbleMessageMediaTypeVoice:
//            break;
//        case WLBubbleMessageMediaTypeEmotion:
//            // 直接设置GIF
//            if (message.emotionPath) {
//                NSData *animatedData = [NSData dataWithContentsOfFile:message.emotionPath];
//                FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedData];
//                _emotionImageView.animatedImage = animatedImage;
//            }
//            break;
//        case WLBubbleMessageMediaTypeLocalPosition:
//            [_bubblePhotoImageView configureMessagePhoto:message.localPositionPhoto thumbnailUrl:nil originPhotoUrl:nil onBubbleMessageType:self.message.bubbleMessageType];
//            
//            _geolocationsLabel.text = message.geolocations;
//            break;
        case WLBubbleMessageMediaTypeCard://卡片
        {
            switch (message.cardType.integerValue) {
                case WLBubbleMessageCardTypeActivity:
                case WLBubbleMessageCardTypeProject:
                case WLBubbleMessageCardTypeWeb:
                {
                     //卡片
                    CardStatuModel *model = [[CardStatuModel alloc] init];
                    model.cid = message.cardId;
                    model.type = message.cardType;
                    model.title = message.cardTitle;
                    model.intro = message.cardIntro;
                    model.url = message.cardUrl;
                    _displayCardView.cardM = model;
                    _displayCardView.isHidLine = YES;//隐藏边线
//                    _displayCardView.iconImage.image = [UIImage imageNamed:@"home_repost_huodong"];
//                    _displayCardView.titLabel.text = @"杭州投资牛皮盛宴";
//                    _displayCardView.detailLabel.text = @"4月10日，杭州";
                    _displayCardView.tapBut.hidden = YES;
                    //            [_displayCardView setDebug:YES];
                }
                    break;
                default:
                {
                    //设置文字
                    _displayLabel.textColor = kTitleNormalTextColor;
                    _displayLabel.text = message.text;

                }
                    break;
            }
        }
            break;
        default:
        {
            //设置文字
            _displayLabel.textColor = [message bubbleMessageType] == WLBubbleMessageTypeReceiving ? kTitleNormalTextColor : [UIColor whiteColor];
            _displayLabel.text = message.text;
        }
            break;
    }
    
    [self setNeedsLayout];
}

- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <WLMessageModel>)message {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _message = message;
        
        // 1、初始化气泡的背景
        if (!_bubbleImageView) {
            //bubble image
            FLAnimatedImageView *bubbleImageView = [[FLAnimatedImageView alloc] init];
            bubbleImageView.frame = self.bounds;
            bubbleImageView.userInteractionEnabled = YES;
            [self addSubview:bubbleImageView];
            self.bubbleImageView = bubbleImageView;
//            [bubbleImageView setDebug:YES];
        }
        
        //初始化现实卡片的view
        if(!_displayCardView){
            WLCellCardView *cardView = [[WLCellCardView alloc] init];
            cardView.backgroundColor = [UIColor clearColor];
            [self addSubview:cardView];
            self.displayCardView = cardView;
        }
        
        // 2、初始化显示文本消息的TextView
//        if (!_displayTextView) {
//            SETextView *displayTextView = [[SETextView alloc] initWithFrame:CGRectZero];
//            displayTextView.backgroundColor = [UIColor clearColor];
//            displayTextView.selectable = NO;
//            displayTextView.lineSpacing = kWLTextLineSpacing;
//            displayTextView.font = [[WLMessageBubbleView appearance] font];
//            displayTextView.showsEditingMenuAutomatically = NO;
//            displayTextView.highlighted = NO;
//            //设置字体颜色
////            displayTextView.textColor = [message bubbleMessageType] == WLBubbleMessageTypeReceiving ? [UIColor blackColor] : [UIColor whiteColor];
//            //设置字体颜色
////            displayTextView.textColor = [message bubbleMessageType] == WLBubbleMessageTypeReceiving ? displayTextView.textColor : [SEConstants sendTextColor];
//            //链接颜色
////            displayTextView.linkHighlightColor = [UIColor blueColor];
////            displayTextView.linkRolloverEffectColor = [UIColor blueColor];
////            displayTextView.delegate = self;
//            [self addSubview:displayTextView];
//            _displayTextView = displayTextView;
////            [displayTextView setDebug:YES];
//        }
        
        if (!_displayLabel) {
            // 5.内容
            MLEmojiLabel *displayLabel = [[MLEmojiLabel alloc]init];
            displayLabel.numberOfLines = 0;
//            displayLabel.emojiDelegate = self;
            displayLabel.lineBreakMode = NSLineBreakByCharWrapping;
            displayLabel.font = [[WLMessageBubbleView appearance] font];
            displayLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:displayLabel];
            self.displayLabel = displayLabel;
//            [displayLabel setDebug:YES];
        }
        
        // 3、初始化显示图片的控件
        if (!_bubblePhotoImageView) {
            WLBubblePhotoImageView *bubblePhotoImageView = [[WLBubblePhotoImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:bubblePhotoImageView];
            _bubblePhotoImageView = bubblePhotoImageView;
//            [bubblePhotoImageView setDebug:YES];
            if (!_videoPlayImageView) {
                UIImageView *videoPlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MessageVideoPlay"]];
                [bubblePhotoImageView addSubview:videoPlayImageView];
                _videoPlayImageView = videoPlayImageView;
            }
            
            if (!_geolocationsLabel) {
                UILabel *geolocationsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                geolocationsLabel.numberOfLines = 0;
                geolocationsLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                geolocationsLabel.textColor = [UIColor whiteColor];
                geolocationsLabel.backgroundColor = [UIColor clearColor];
                geolocationsLabel.font = [UIFont systemFontOfSize:12];
                [bubblePhotoImageView addSubview:geolocationsLabel];
                _geolocationsLabel = geolocationsLabel;
            }
        }
        
        // 4、初始化显示语音时长的label
        if (!_voiceDurationLabel) {
            UILabel *voiceDurationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 30, 30)];
            voiceDurationLabel.textColor = [UIColor lightGrayColor];
            voiceDurationLabel.backgroundColor = [UIColor clearColor];
            voiceDurationLabel.font = [UIFont systemFontOfSize:13.f];
            voiceDurationLabel.textAlignment = NSTextAlignmentRight;
            voiceDurationLabel.hidden = YES;
            [self addSubview:voiceDurationLabel];
            _voiceDurationLabel = voiceDurationLabel;
        }
        
        // 5、初始化显示gif表情的控件
        if (!_emotionImageView) {
            FLAnimatedImageView *emotionImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:emotionImageView];
            _emotionImageView = emotionImageView;
        }
        
        // 6. 初始化显示语音未读标记的imageview
        if (!_voiceUnreadDotImageView) {
            UIImageView *voiceUnreadDotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
            voiceUnreadDotImageView.image = [UIImage imageNamed:@"msg_chat_voice_unread"];
            voiceUnreadDotImageView.hidden = YES;
            [self addSubview:voiceUnreadDotImageView];
            _voiceUnreadDotImageView = voiceUnreadDotImageView;
        }
        
        //7.发送失败按钮
        if(!_sendFailedBtn){
            UIButton *sendFailedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            sendFailedBtn.backgroundColor = [UIColor clearColor];
            [sendFailedBtn setImage:[UIImage imageNamed:@"circle_chat_sendfailed"] forState:UIControlStateNormal];
            sendFailedBtn.hidden = YES;
            [sendFailedBtn sizeToFit];
            [self addSubview:sendFailedBtn];
            _sendFailedBtn = sendFailedBtn;
//            [sendFailedBtn setDebug:YES];
        }
        
        //8.发送的时候的加载控件
        if (!_activityIndicatorView) {
            UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicatorView.hidesWhenStopped = YES;
//            activityIndicatorView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 2.0);
            [self addSubview:activityIndicatorView];
            _activityIndicatorView = activityIndicatorView;
//            [_activityIndicatorView startAnimating];
        }
    }
    return self;
}

- (void)dealloc {
    _message = nil;
//    _displayTextView = nil;
    _displayCardView = nil;
    _displayLabel = nil;
    _bubbleImageView = nil;
    _bubblePhotoImageView = nil;
    _animationVoiceImageView = nil;
    _voiceUnreadDotImageView = nil;
    _sendFailedBtn = nil;
    _activityIndicatorView = nil;
    _voiceDurationLabel = nil;
    _emotionImageView = nil;
    _videoPlayImageView = nil;
    _geolocationsLabel = nil;
    _font = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WLBubbleMessageMediaType currentType = self.message.messageMediaType;
    CGRect bubbleFrame = [self bubbleFrame];
    //重新设置发送失败按钮的位置
    [self resetSendFailedBtnFrameWithBubbleFrame:bubbleFrame];
    [self resetActivityIndicatorViewWithBubbleFrame:bubbleFrame];
    
    switch (currentType) {
        case WLBubbleMessageMediaTypeCard://卡片
        case WLBubbleMessageMediaTypeActivity://活动
        case WLBubbleMessageMediaTypeText:
//        case WLBubbleMessageMediaTypeVoice:
//        case WLBubbleMessageMediaTypeEmotion:
        {
            self.bubbleImageView.frame = bubbleFrame;
            
            CGFloat textX = CGRectGetMinX(bubbleFrame) + kBubblePaddingRight;
            
            if (self.message.bubbleMessageType == WLBubbleMessageTypeReceiving) {
                textX += kWLArrowMarginWidth / 2.0;
            }
            
            CGRect textFrame = CGRectMake(textX,
                                          CGRectGetMinY(bubbleFrame) + kPaddingTop,
                                          CGRectGetWidth(bubbleFrame) - kBubblePaddingRight * 2,
                                          bubbleFrame.size.height - kMarginTop - kMarginBottom);
            
//            self.displayTextView.frame = CGRectIntegral(textFrame);
            self.displayLabel.frame = CGRectIntegral(textFrame);
            
            CGRect animationVoiceImageViewFrame = self.animationVoiceImageView.frame;
            animationVoiceImageViewFrame.origin = CGPointMake((self.message.bubbleMessageType == WLBubbleMessageTypeReceiving ? (bubbleFrame.origin.x + kVoiceMargin) : (bubbleFrame.origin.x + CGRectGetWidth(bubbleFrame) - kVoiceMargin - CGRectGetWidth(animationVoiceImageViewFrame))), 17);
            self.animationVoiceImageView.frame = animationVoiceImageViewFrame;
            
            [self resetVoiceDurationLabelFrameWithBubbleFrame:bubbleFrame];
            [self resetVoiceUnreadDotImageViewFrameWithBubbleFrame:bubbleFrame];
            [self resetDisplayCardViewFrameWithBubbleFrame:bubbleFrame];
            self.emotionImageView.frame = bubbleFrame;
            
            break;
        }
        case WLBubbleMessageMediaTypePhoto:
//        case WLBubbleMessageMediaTypeVideo:
//        case WLBubbleMessageMediaTypeLocalPosition:
        {
            CGRect photoImageViewFrame = CGRectMake(bubbleFrame.origin.x - 2, 0, bubbleFrame.size.width, bubbleFrame.size.height);
            self.bubblePhotoImageView.frame = photoImageViewFrame;
            
            self.videoPlayImageView.center = CGPointMake(CGRectGetWidth(photoImageViewFrame) / 2.0, CGRectGetHeight(photoImageViewFrame) / 2.0);
            
            CGRect geolocationsLabelFrame = CGRectMake(11, CGRectGetHeight(photoImageViewFrame) - 47, CGRectGetWidth(photoImageViewFrame) - 20, 40);
            self.geolocationsLabel.frame = geolocationsLabelFrame;
            
            break;
        }
        default:
        {
            self.bubbleImageView.frame = bubbleFrame;
            
            CGFloat textX = CGRectGetMinX(bubbleFrame) + kBubblePaddingRight;
            
            if (self.message.bubbleMessageType == WLBubbleMessageTypeReceiving) {
                textX += kWLArrowMarginWidth / 2.0;
            }
            
            CGRect textFrame = CGRectMake(textX,
                                          CGRectGetMinY(bubbleFrame) + kPaddingTop,
                                          CGRectGetWidth(bubbleFrame) - kBubblePaddingRight * 2,
                                          bubbleFrame.size.height - kMarginTop - kMarginBottom);
            
            //            self.displayTextView.frame = CGRectIntegral(textFrame);
            self.displayLabel.frame = CGRectIntegral(textFrame);
            
            CGRect animationVoiceImageViewFrame = self.animationVoiceImageView.frame;
            animationVoiceImageViewFrame.origin = CGPointMake((self.message.bubbleMessageType == WLBubbleMessageTypeReceiving ? (bubbleFrame.origin.x + kVoiceMargin) : (bubbleFrame.origin.x + CGRectGetWidth(bubbleFrame) - kVoiceMargin - CGRectGetWidth(animationVoiceImageViewFrame))), 17);
            self.animationVoiceImageView.frame = animationVoiceImageViewFrame;
            
            [self resetVoiceDurationLabelFrameWithBubbleFrame:bubbleFrame];
            [self resetVoiceUnreadDotImageViewFrameWithBubbleFrame:bubbleFrame];
            [self resetDisplayCardViewFrameWithBubbleFrame:bubbleFrame];
            self.emotionImageView.frame = bubbleFrame;
        }
            break;
    }
}

//重新设置卡片的位置
- (void)resetDisplayCardViewFrameWithBubbleFrame:(CGRect)bubbleFrame
{
    CGRect cardFrame = bubbleFrame;
    cardFrame.origin.x = (self.message.bubbleMessageType == WLBubbleMessageTypeSending ? bubbleFrame.origin.x : 7.f);
    cardFrame.size = CGSizeMake(bubbleFrame.size.width - kPaddingTop,56.f);
    _displayCardView.frame = cardFrame;
    _displayCardView.centerY = _bubbleImageView.centerY;
}

- (void)resetVoiceDurationLabelFrameWithBubbleFrame:(CGRect)bubbleFrame {
    CGRect voiceFrame = _voiceDurationLabel.frame;
    voiceFrame.origin.x = (self.message.bubbleMessageType == WLBubbleMessageTypeSending ? bubbleFrame.origin.x - _voiceDurationLabel.frame.size.width : bubbleFrame.origin.x + bubbleFrame.size.width);
    _voiceDurationLabel.frame = voiceFrame;
    
    _voiceDurationLabel.textAlignment = (self.message.bubbleMessageType == WLBubbleMessageTypeSending ? NSTextAlignmentRight : NSTextAlignmentLeft);
}

- (void)resetVoiceUnreadDotImageViewFrameWithBubbleFrame:(CGRect)bubbleFrame {
    CGRect voiceUnreadDotFrame = _voiceUnreadDotImageView.frame;
    voiceUnreadDotFrame.origin.x = (self.message.bubbleMessageType == WLBubbleMessageTypeSending ? bubbleFrame.origin.x + _voiceUnreadDotImageView.frame.size.width : bubbleFrame.origin.x + bubbleFrame.size.width - _voiceUnreadDotImageView.frame.size.width * 2);
    voiceUnreadDotFrame.origin.y = bubbleFrame.size.height/2 + _voiceUnreadDotImageView.frame.size.height/2 - 2;
    _voiceUnreadDotImageView.frame = voiceUnreadDotFrame;
}

//重新设置发送失败按钮的位置
- (void)resetSendFailedBtnFrameWithBubbleFrame:(CGRect)bubbleFrame{
    CGRect sendFailedFrame = _sendFailedBtn.frame;
    sendFailedFrame.origin.x = (self.message.bubbleMessageType == WLBubbleMessageTypeSending ? bubbleFrame.origin.x - _sendFailedBtn.frame.size.width - 5 : bubbleFrame.origin.x + bubbleFrame.size.width + 5);
    sendFailedFrame.origin.y = bubbleFrame.size.height/2 - 2;
    _sendFailedBtn.frame = sendFailedFrame;
}

//重新设置加载网络控件位置
- (void)resetActivityIndicatorViewWithBubbleFrame:(CGRect)bubbleFrame{
    CGRect sendFailedFrame = _activityIndicatorView.frame;
    sendFailedFrame.origin.x = (self.message.bubbleMessageType == WLBubbleMessageTypeSending ? bubbleFrame.origin.x - _activityIndicatorView.frame.size.width - 5 : bubbleFrame.origin.x + bubbleFrame.size.width + 5);
    sendFailedFrame.origin.y = bubbleFrame.size.height/2 - 2;
    _activityIndicatorView.frame = sendFailedFrame;
}


@end
