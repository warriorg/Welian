//
//  ChatMessage.m
//  Welian
//
//  Created by weLian on 14/12/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ChatMessage.h"
#import "WLMessage.h"
#import "MyFriendUser.h"


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
+ (ChatMessage *)createChatMessageWithWLMessage:(WLMessage *)wlMessage FriendUser:(MyFriendUser *)friedUser
{
    ChatMessage *chatMsg = [ChatMessage create];
    chatMsg.msgId = [NSString stringWithFormat:@"%d",[friedUser getMaxChatMessageId].intValue + 1];
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
    
    return chatMsg;
}

//创建接受到的聊天消息
+ (void)createReciveMessageWithDict:(NSDictionary *)dict
{
    /*
     {
     data =     {
     created = "2014-12-29 15:06:08";
     fromuser =         {
     avatar = "http://img.welian.com/1417496795301_x.png";
     name = "\U5f20\U8273\U4e1c";
     uid = 10019;
     };
     msg = lol;
     type = 0;
     uid = 11078;
     };
     type = IM;
     }
     */
    
    MyFriendUser *friendUser = [MyFriendUser createMyFriendFromReceive:dict];
    NSString *created = dict[@"created"];
    NSInteger type = [dict[@"type"] integerValue];
    
    ChatMessage *chatMsg = [ChatMessage create];
    chatMsg.msgId = [NSString stringWithFormat:@"%d",[friendUser getMaxChatMessageId].intValue + 1];
    chatMsg.messageType = @(type);
    switch (type) {
        case WLBubbleMessageMediaTypeText:
            //文本
            chatMsg.message = dict[@"msg"];
            break;
            
        default:
            break;
    }
    chatMsg.timestamp = [created dateFromShortString];
    chatMsg.avatorUrl = friendUser.avatar;
    chatMsg.isRead = @(NO);
    chatMsg.sendStatus = @(1);
    chatMsg.bubbleMessageType = @(WLBubbleMessageTypeReceiving);//接受的数据
//    chatMsg.thumbnailUrl = wlMessage.thumbnailUrl;
//    chatMsg.originPhotoUrl = wlMessage.originPhotoUrl;
//    chatMsg.videoPath = wlMessage.videoPath;
//    chatMsg.videoUrl = wlMessage.videoUrl;
    //    chatMsg.videoConverPhoto = wlMessage.videoConverPhoto;
//    chatMsg.voicePath = wlMessage.voicePath;
//    chatMsg.voiceUrl = wlMessage.voiceUrl;
//    chatMsg.geolocations = wlMessage.geolocations;
//    chatMsg.latitude = @(wlMessage.location.coordinate.latitude);
//    chatMsg.longitude = @(wlMessage.location.coordinate.longitude);
    chatMsg.sender = friendUser.name;
    chatMsg.rsMyFriendUser = friendUser;
    [MOC save];
    
    //更新总的聊天消息数量
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatMsgNumChanged" object:nil];
}

//更新发送状态
- (void)updateSendStatus:(NSInteger)status
{
    self.sendStatus = @(status);
    [MOC save];
}

//更新读取状态
- (void)updateReadStatus:(BOOL)status
{
    self.isRead = @(status);
    [MOC save];
}

//更新重新发送状态
- (void)updateReSendStatus
{
    self.sendStatus = @(0);
    self.timestamp = [NSDate date];
    [MOC save];
}

@end
