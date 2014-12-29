//
//  ChatMessage.m
//  Welian
//
//  Created by weLian on 14/12/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ChatMessage.h"
#import "MyFriendUser.h"
#import "WLMessage.h"


@implementation ChatMessage

@dynamic msgId;
@dynamic message;
@dynamic messageType;
@dynamic timestamp;
@dynamic avatorUrl;
@dynamic isRead;
@dynamic sendStatus;
@dynamic bubbleMessageType;
@dynamic thumbnailUrl;
@dynamic originPhotoUrl;
@dynamic videoPath;
@dynamic videoUrl;
@dynamic videoConverPhoto;
@dynamic voicePath;
@dynamic voiceUrl;
@dynamic localPositionPhoto;
@dynamic geolocations;
@dynamic latitude;
@dynamic longitude;
@dynamic sender;
@dynamic rsMyFriendUser;

//创建新的聊天记录
+ (void)createChatMessageWithWLMessage:(WLMessage *)wlMessage FriendUser:(MyFriendUser *)friedUser
{
    ChatMessage *chatMsg = [ChatMessage create];
    chatMsg.msgId = [NSString stringWithFormat:@"%d",[friedUser getMaxChatMessageId].integerValue + 1];
    chatMsg.message = wlMessage.text;
    chatMsg.messageType = @(wlMessage.messageMediaType);
    chatMsg.timestamp = wlMessage.timestamp;
    chatMsg.avatorUrl = wlMessage.avatorUrl;
    chatMsg.isRead = @(wlMessage.isRead);
    chatMsg.sendStatus = @(wlMessage.sended);
    chatMsg.bubbleMessageType = @(wlMessage.bubbleMessageType);
    chatMsg.thumbnailUrl = wlMessage.thumbnailUrl;
    chatMsg.originPhotoUrl = wlMessage.originPhotoUrl;
    chatMsg.videoPath = wlMessage.videoPath;
    chatMsg.videoUrl = wlMessage.videoUrl;
//    chatMsg.videoConverPhoto = wlMessage.videoConverPhoto;
    chatMsg.voicePath = wlMessage.voicePath;
    chatMsg.voiceUrl = wlMessage.voiceUrl;
    chatMsg.geolocations = wlMessage.geolocations;
    chatMsg.latitude = @(wlMessage.location.coordinate.latitude);
    chatMsg.longitude = @(wlMessage.location.coordinate.longitude);
    chatMsg.sender = wlMessage.sender;
    chatMsg.rsMyFriendUser = friedUser;
    [MOC save];
}

@end
