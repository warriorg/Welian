//
//  WLMessageBubbleFactory.m
//  Welian
//
//  Created by weLian on 14/12/25.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLMessageBubbleFactory.h"

@implementation WLMessageBubbleFactory

+ (UIImage *)bubbleImageViewForType:(WLBubbleMessageType)type
                              style:(WLBubbleImageViewStyle)style
                          meidaType:(WLBubbleMessageMediaType)mediaType{

    NSString *messageTypeString;
    
    switch (style) {
        case WLBubbleImageViewStyleWeChat:
            // 类似微信的
            messageTypeString = @"weChatBubble";
            break;
        default:
            break;
    }
    
    switch (type) {
        case WLBubbleMessageTypeSending:
            // 发送
            messageTypeString = [messageTypeString stringByAppendingString:@"_Sending"];
            break;
        case WLBubbleMessageTypeReceiving:
            // 接收
            messageTypeString = [messageTypeString stringByAppendingString:@"_Receiving"];
            break;
        default:
            break;
    }
    
    switch (mediaType) {
        case WLBubbleMessageMediaTypePhoto:
//        case WLBubbleMessageMediaTypeVideo:
        case WLBubbleMessageMediaTypeText:
//        case WLBubbleMessageMediaTypeVoice:
            messageTypeString = [messageTypeString stringByAppendingString:@"_Solid"];
            break;
        case WLBubbleMessageMediaTypeActivity://活动
        case WLBubbleMessageMediaTypeCard://卡片
            //卡片
            messageTypeString = [messageTypeString stringByAppendingString:@"_Card"];
            break;
        default:
            messageTypeString = [messageTypeString stringByAppendingString:@"_Solid"];
            break;
    }
    
    
    UIImage *bublleImage = [UIImage imageNamed:messageTypeString];
    UIEdgeInsets bubbleImageEdgeInsets = [self bubbleImageEdgeInsetsWithStyle:style];
    return WL_STRETCH_IMAGE(bublleImage, bubbleImageEdgeInsets);
}

+ (UIEdgeInsets)bubbleImageEdgeInsetsWithStyle:(WLBubbleImageViewStyle)style {
    UIEdgeInsets edgeInsets;
    switch (style) {
        case WLBubbleImageViewStyleWeChat:
            // 类似微信的
//            edgeInsets = UIEdgeInsetsMake(30, 28, 85, 28);
            edgeInsets = UIEdgeInsetsMake(30, 10, 85, 10);
            //尖尖的
//            edgeInsets = UIEdgeInsetsMake(20, 15, 85, 15);
            break;
        default:
            break;
    }
    return edgeInsets;
}

@end
