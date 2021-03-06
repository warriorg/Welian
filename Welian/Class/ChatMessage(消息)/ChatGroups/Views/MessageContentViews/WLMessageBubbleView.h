//
//  WLMessageBubbleView.h
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "WLMessageTextView.h"
#import "WLMessageInputView.h"
//#import "WLMessageDisplayTextView.h"
#import "WLBubblePhotoImageView.h"
//#import "SETextView.h"
#import "MLEmojiLabel.h"

#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

#import "WLCellCardView.h"
#import "WLMessageCardView.h"

// Model
#import "WLMessage.h"

// Factorys
#import "WLMessageAvatorFactory.h"
#import "WLMessageVoiceFactory.h"

// Categorys
#import "UIImage+XHAnimatedFaceGif.h"

#define kWLMessageBubbleDisplayMaxLine 200

#define kWLTextLineSpacing 3.0

@interface WLMessageBubbleView : UIView

//目标消息Model对象
@property (nonatomic, strong, readonly)  id <WLMessageModel> message;

//自定义显示文本消息控件，子类化的原因有两个，第一个是屏蔽Menu的显示。第二是传递手势到下一层，因为文本需要双击的手势
//@property (nonatomic, weak, readonly) SETextView *displayTextView;
@property (nonatomic, weak, readonly) MLEmojiLabel *displayLabel;

//用于显示卡片类型的控件
//@property (nonatomic, weak, readonly) WLCellCardView *displayCardView;
@property (nonatomic, weak, readonly) WLMessageCardView *displayCardView;

//用于显示气泡的ImageView控件
@property (nonatomic, weak, readonly) UIImageView *bubbleImageView;

//专门用于gif表情显示控件
@property (nonatomic, weak, readonly) FLAnimatedImageView *emotionImageView;

//用于显示消息未发送成功的按钮
@property (nonatomic, weak, readonly) UIButton *sendFailedBtn;

///发送的时候，需要用到转圈的控件
@property (nonatomic, weak, readonly) UIActivityIndicatorView *activityIndicatorView;

//用于显示语音的控件，并且支持播放动画
@property (nonatomic, weak, readonly) UIImageView *animationVoiceImageView;

//用于显示语音未读的控件，小圆点
@property (nonatomic, weak, readonly) UIImageView *voiceUnreadDotImageView;

//用于显示语音时长的label
@property (nonatomic, weak) UILabel *voiceDurationLabel;

// 用于显示仿微信发送图片的控件
@property (nonatomic, weak, readonly) WLBubblePhotoImageView *bubblePhotoImageView;

//显示语音播放的图片控件
@property (nonatomic, weak, readonly) UIImageView *videoPlayImageView;

//显示地理位置的文本控件
@property (nonatomic, weak, readonly) UILabel *geolocationsLabel;

//设置文本消息的字体
@property (nonatomic, strong) UIFont *font UI_APPEARANCE_SELECTOR;


/**
 *  初始化消息内容显示控件的方法
 *
 *  @param frame   目标Frame
 *  @param message 目标消息Model对象
 *
 *  @return 返回XHMessageBubbleView类型的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                      message:(id <WLMessageModel>)message;

/**
 *  获取气泡相对于父试图的位置
 *
 *  @return 返回气泡的位置
 */
- (CGRect)bubbleFrame;

/**
 *  根据消息Model对象配置消息显示内容
 *
 *  @param message 目标消息Model对象
 */
- (void)configureCellWithMessage:(id <WLMessageModel>)message;

/**
 *  根据消息Model对象计算消息内容的高度
 *
 *  @param message 目标消息Model对象
 *
 *  @return 返回所需高度
 */
+ (CGFloat)calculateCellHeightWithMessage:(id <WLMessageModel>)message;

@end
