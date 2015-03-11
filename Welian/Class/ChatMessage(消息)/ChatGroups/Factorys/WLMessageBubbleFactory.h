//
//  WLMessageBubbleFactory.h
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WLBubbleMessageType) {
    WLBubbleMessageTypeSending = 0,
    WLBubbleMessageTypeReceiving,
    WLBubbleMessageTypeSpecial
};

typedef NS_ENUM(NSUInteger, WLBubbleImageViewStyle) {
    WLBubbleImageViewStyleWeChat = 0,
    WLBubbleImageViewStyleWeChatPre
};

typedef NS_ENUM(NSUInteger, WLBubbleMessageCardType) {////3 活动，10项目，11 网页
    WLBubbleMessageCardTypeActivity = 3,
    WLBubbleMessageCardTypeProject = 10,
    WLBubbleMessageCardTypeWeb = 11,
};

typedef NS_ENUM(NSInteger, WLBubbleMessageMediaType) {
    WLBubbleMessageMediaTypeText = 0,
    WLBubbleMessageMediaTypePhoto = 1,
    WLBubbleMessageMediaTypeVoice = 2,
    WLBubbleMessageMediaTypeVideo = 3,
    WLBubbleMessageMediaTypeEmotion = 4,
    WLBubbleMessageMediaTypeLocalPosition = 5,
    
    WLBubbleMessageMediaTypeActivity = 50,//系统发送的活动通知消息，展示方式和普通问题展示一样
    WLBubbleMessageMediaTypeCard = 51,//卡片类型  //3 活动，10项目，11 网页
    WLBubbleMessageSpecialTypeText = 100,   //特殊消息提醒类型
};

typedef NS_ENUM(NSInteger, WLBubbleMessageMenuSelecteType) {
    WLBubbleMessageMenuSelecteTypeTextCopy = 0,
    WLBubbleMessageMenuSelecteTypeTextTranspond = 1,
    WLBubbleMessageMenuSelecteTypeTextFavorites = 2,
    WLBubbleMessageMenuSelecteTypeTextMore = 3,
    
    WLBubbleMessageMenuSelecteTypePhotoCopy = 4,
    WLBubbleMessageMenuSelecteTypePhotoTranspond = 5,
    WLBubbleMessageMenuSelecteTypePhotoFavorites = 6,
    WLBubbleMessageMenuSelecteTypePhotoMore = 7,
    
    WLBubbleMessageMenuSelecteTypeVideoTranspond = 8,
    WLBubbleMessageMenuSelecteTypeVideoFavorites = 9,
    WLBubbleMessageMenuSelecteTypeVideoMore = 10,
    
    WLBubbleMessageMenuSelecteTypeVoicePlay = 11,
    WLBubbleMessageMenuSelecteTypeVoiceFavorites = 12,
    WLBubbleMessageMenuSelecteTypeVoiceTurnToText = 13,
    WLBubbleMessageMenuSelecteTypeVoiceMore = 14,
};

@interface WLMessageBubbleFactory : NSObject

+ (UIImage *)bubbleImageViewForType:(WLBubbleMessageType)type
                              style:(WLBubbleImageViewStyle)style
                          meidaType:(WLBubbleMessageMediaType)mediaType;

@end
