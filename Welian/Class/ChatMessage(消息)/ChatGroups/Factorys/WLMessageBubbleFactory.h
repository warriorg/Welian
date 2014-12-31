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
    WLBubbleMessageTypeReceiving
};

typedef NS_ENUM(NSUInteger, WLBubbleImageViewStyle) {
    WLBubbleImageViewStyleWeChat = 0
};

typedef NS_ENUM(NSInteger, WLBubbleMessageMediaType) {
    WLBubbleMessageMediaTypeText = 0,
    WLBubbleMessageMediaTypePhoto = 1,
    WLBubbleMessageMediaTypeVoice = 2,
    WLBubbleMessageMediaTypeVideo = 3,
    WLBubbleMessageMediaTypeEmotion = 4,
    WLBubbleMessageMediaTypeLocalPosition = 5,
    
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
