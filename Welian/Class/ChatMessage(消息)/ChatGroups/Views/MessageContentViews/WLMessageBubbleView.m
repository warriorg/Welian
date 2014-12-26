//
//  WLMessageBubbleView.m
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLMessageBubbleView.h"
#import "WLMessageBubbleHelper.h"

#define kMarginTop 8.0f
#define kMarginBottom 2.0f
#define kPaddingTop 12.0f
#define kBubblePaddingRight 14.0f

#define kVoiceMargin 20.0f

#define kWLArrowMarginWidth 14

@interface WLMessageBubbleView ()

@property (nonatomic, weak, readwrite) SETextView *displayTextView;

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

+ (CGFloat)neededWidthForText:(NSString *)text {
    CGSize stringSize;
    stringSize = [text sizeWithFont:[[WLMessageBubbleView appearance] font]
                  constrainedToSize:CGSizeMake(MAXFLOAT, 19)];
    return roundf(stringSize.width);
}

+ (CGSize)neededSizeForText:(NSString *)text {
    CGFloat maxWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]) * (kIsiPad ? 0.8 : 0.55);
    
    CGFloat dyWidth = [WLMessageBubbleView neededWidthForText:text];
    
    CGSize textSize = [SETextView frameRectWithAttributtedString:[[WLMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:text] constraintSize:CGSizeMake(maxWidth, MAXFLOAT) lineSpacing:kWLTextLineSpacing font:[[WLMessageBubbleView appearance] font]].size;
    return CGSizeMake((dyWidth > textSize.width ? textSize.width : dyWidth) + kBubblePaddingRight * 2 + kWLArrowMarginWidth, textSize.height + kMarginTop * 2);
//    return CGSizeMake((dyWidth > textSize.width ? textSize.width : dyWidth) + kBubblePaddingRight * 2 + kWLArrowMarginWidth, textSize.height + kMarginTop);
}

+ (CGSize)neededSizeForPhoto:(UIImage *)photo {
    // 这里需要缩放后的size
    CGSize photoSize = CGSizeMake(120, 120);
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
        case WLBubbleMessageMediaTypeText: {
            bubbleSize = [WLMessageBubbleView neededSizeForText:message.text];
            break;
        }
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
    _message = message;
    
    [self configureBubbleImageView:message];
    
    [self configureMessageDisplayMediaWithMessage:message];
}

- (void)configureBubbleImageView:(id <WLMessageModel>)message {
    WLBubbleMessageMediaType currentType = message.messageMediaType;
    
    _voiceDurationLabel.hidden = YES;
    switch (currentType) {
        case WLBubbleMessageMediaTypeVoice: {
            _voiceDurationLabel.hidden = NO;
            if (message.isRead == NO) {
                _voiceUnreadDotImageView.hidden = NO;
            }
        }
        case WLBubbleMessageMediaTypeText:
        case WLBubbleMessageMediaTypeEmotion: {
            _bubbleImageView.image = [WLMessageBubbleFactory bubbleImageViewForType:message.bubbleMessageType style:WLBubbleImageViewStyleWeChat meidaType:message.messageMediaType];
            // 只要是文本、语音、第三方表情，背景的气泡都不能隐藏
            _bubbleImageView.hidden = NO;
            
            // 只要是文本、语音、第三方表情，都需要把显示尖嘴图片的控件隐藏了
            _bubblePhotoImageView.hidden = YES;
            
            
            if (currentType == WLBubbleMessageMediaTypeText) {
                // 如果是文本消息，那文本消息的控件需要显示
                _displayTextView.hidden = NO;
                // 那语言的gif动画imageView就需要隐藏了
                _animationVoiceImageView.hidden = YES;
                _emotionImageView.hidden = YES;
            } else {
                // 那如果不文本消息，必须把文本消息的控件隐藏了啊
                _displayTextView.hidden = YES;
                
                // 对语音消息的进行特殊处理，第三方表情可以直接利用背景气泡的ImageView控件
                if (currentType == WLBubbleMessageMediaTypeVoice) {
                    [_animationVoiceImageView removeFromSuperview];
                    _animationVoiceImageView = nil;
                    
                    UIImageView *animationVoiceImageView = [WLMessageVoiceFactory messageVoiceAnimationImageViewWithBubbleMessageType:message.bubbleMessageType];
                    [self addSubview:animationVoiceImageView];
                    _animationVoiceImageView = animationVoiceImageView;
                    _animationVoiceImageView.hidden = NO;
                } else {
                    _emotionImageView.hidden = NO;
                    
                    _bubbleImageView.hidden = YES;
                    _animationVoiceImageView.hidden = YES;
                }
            }
            break;
        }
        case WLBubbleMessageMediaTypePhoto:
        case WLBubbleMessageMediaTypeVideo:
        case WLBubbleMessageMediaTypeLocalPosition: {
            // 只要是图片和视频消息，必须把尖嘴显示控件显示出来
            _bubblePhotoImageView.hidden = NO;
            
            _videoPlayImageView.hidden = (currentType != WLBubbleMessageMediaTypeVideo);
            
            _geolocationsLabel.hidden = (currentType != WLBubbleMessageMediaTypeLocalPosition);
            
            // 那其他的控件都必须隐藏
            _displayTextView.hidden = YES;
            _bubbleImageView.hidden = YES;
            _animationVoiceImageView.hidden = YES;
            _emotionImageView.hidden = YES;
            break;
        }
        default:
            break;
    }
}

- (void)configureMessageDisplayMediaWithMessage:(id <WLMessageModel>)message {
    switch (message.messageMediaType) {
        case WLBubbleMessageMediaTypeText:
            //设置字体颜色
            _displayTextView.textColor = [message bubbleMessageType] == WLBubbleMessageTypeReceiving ? [UIColor blackColor] : [UIColor whiteColor];
            _displayTextView.attributedText = [[WLMessageBubbleHelper sharedMessageBubbleHelper] bubbleAttributtedStringWithText:[message text]];
            break;
        case WLBubbleMessageMediaTypePhoto:
            [_bubblePhotoImageView configureMessagePhoto:message.photo thumbnailUrl:message.thumbnailUrl originPhotoUrl:message.originPhotoUrl onBubbleMessageType:self.message.bubbleMessageType];
            break;
        case WLBubbleMessageMediaTypeVideo:
            [_bubblePhotoImageView configureMessagePhoto:message.videoConverPhoto thumbnailUrl:message.thumbnailUrl originPhotoUrl:message.originPhotoUrl onBubbleMessageType:self.message.bubbleMessageType];
            break;
        case WLBubbleMessageMediaTypeVoice:
            break;
        case WLBubbleMessageMediaTypeEmotion:
            // 直接设置GIF
            if (message.emotionPath) {
                NSData *animatedData = [NSData dataWithContentsOfFile:message.emotionPath];
                FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:animatedData];
                _emotionImageView.animatedImage = animatedImage;
            }
            break;
        case WLBubbleMessageMediaTypeLocalPosition:
            [_bubblePhotoImageView configureMessagePhoto:message.localPositionPhoto thumbnailUrl:nil originPhotoUrl:nil onBubbleMessageType:self.message.bubbleMessageType];
            
            _geolocationsLabel.text = message.geolocations;
            break;
        default:
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
            _bubbleImageView = bubbleImageView;
//            [bubbleImageView setDebug:YES];
        }
        
        // 2、初始化显示文本消息的TextView
        if (!_displayTextView) {
            SETextView *displayTextView = [[SETextView alloc] initWithFrame:CGRectZero];
            displayTextView.backgroundColor = [UIColor clearColor];
            displayTextView.selectable = NO;
            displayTextView.lineSpacing = kWLTextLineSpacing;
            displayTextView.font = [[WLMessageBubbleView appearance] font];
            displayTextView.showsEditingMenuAutomatically = NO;
            displayTextView.highlighted = NO;
            [self addSubview:displayTextView];
            _displayTextView = displayTextView;
//            [displayTextView setDebug:YES];
        }
        
        // 3、初始化显示图片的控件
        if (!_bubblePhotoImageView) {
            WLBubblePhotoImageView *bubblePhotoImageView = [[WLBubblePhotoImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:bubblePhotoImageView];
            _bubblePhotoImageView = bubblePhotoImageView;
            [bubblePhotoImageView setDebug:YES];
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
    }
    return self;
}

- (void)dealloc {
    _message = nil;
    _displayTextView = nil;
    _bubbleImageView = nil;
    _bubblePhotoImageView = nil;
    _animationVoiceImageView = nil;
    _voiceUnreadDotImageView = nil;
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
    
    switch (currentType) {
        case WLBubbleMessageMediaTypeText:
        case WLBubbleMessageMediaTypeVoice:
        case WLBubbleMessageMediaTypeEmotion: {
            self.bubbleImageView.frame = bubbleFrame;
            
            CGFloat textX = CGRectGetMinX(bubbleFrame) + kBubblePaddingRight;
            
            if (self.message.bubbleMessageType == WLBubbleMessageTypeReceiving) {
                textX += kWLArrowMarginWidth / 2.0;
            }
            
            CGRect textFrame = CGRectMake(textX,
                                          CGRectGetMinY(bubbleFrame) + kPaddingTop,
                                          CGRectGetWidth(bubbleFrame) - kBubblePaddingRight * 2,
                                          bubbleFrame.size.height - kMarginTop - kMarginBottom);
            
            self.displayTextView.frame = CGRectIntegral(textFrame);
            
            CGRect animationVoiceImageViewFrame = self.animationVoiceImageView.frame;
            animationVoiceImageViewFrame.origin = CGPointMake((self.message.bubbleMessageType == WLBubbleMessageTypeReceiving ? (bubbleFrame.origin.x + kVoiceMargin) : (bubbleFrame.origin.x + CGRectGetWidth(bubbleFrame) - kVoiceMargin - CGRectGetWidth(animationVoiceImageViewFrame))), 17);
            self.animationVoiceImageView.frame = animationVoiceImageViewFrame;
            
            [self resetVoiceDurationLabelFrameWithBubbleFrame:bubbleFrame];
            [self resetVoiceUnreadDotImageViewFrameWithBubbleFrame:bubbleFrame];
            
            self.emotionImageView.frame = bubbleFrame;
            
            break;
        }
        case WLBubbleMessageMediaTypePhoto:
        case WLBubbleMessageMediaTypeVideo:
        case WLBubbleMessageMediaTypeLocalPosition: {
            CGRect photoImageViewFrame = CGRectMake(bubbleFrame.origin.x - 2, 0, bubbleFrame.size.width, bubbleFrame.size.height);
            self.bubblePhotoImageView.frame = photoImageViewFrame;
            
            self.videoPlayImageView.center = CGPointMake(CGRectGetWidth(photoImageViewFrame) / 2.0, CGRectGetHeight(photoImageViewFrame) / 2.0);
            
            CGRect geolocationsLabelFrame = CGRectMake(11, CGRectGetHeight(photoImageViewFrame) - 47, CGRectGetWidth(photoImageViewFrame) - 20, 40);
            self.geolocationsLabel.frame = geolocationsLabelFrame;
            
            break;
        }
        default:
            break;
    }
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


@end
