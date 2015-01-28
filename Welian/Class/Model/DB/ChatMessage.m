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
@dynamic photoImage;
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
@dynamic showTimeStamp;
@dynamic rsMyFriendUser;

//创建新的聊天记录
+ (ChatMessage *)createChatMessageWithWLMessage:(WLMessage *)wlMessage FriendUser:(MyFriendUser *)friendUser
{
    //是否显示时间戳
    ChatMessage *lastChatMsg = [friendUser getTheLastChatMessage];
    
    ChatMessage *chatMsg = [ChatMessage MR_createEntityInContext:friendUser.managedObjectContext];
    chatMsg.msgId = @([friendUser getMaxChatMessageId].integerValue + 1);
    switch (wlMessage.messageMediaType) {
        case WLBubbleMessageMediaTypePhoto:
        {
            //保存到本地  图片名称
//            chatMsg.photoImage = UIImageJPEGRepresentation(wlMessage.photo, 1);
            NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[NSString getNowTimestamp]];
            NSString *path = [ResManager saveImage:wlMessage.photo ToFolder:friendUser.uid.stringValue WithName:imageName];
            chatMsg.message = @"[图片]";
            chatMsg.thumbnailUrl = path;
            chatMsg.originPhotoUrl = wlMessage.originPhotoUrl;
        }
            break;
        default:
            chatMsg.message = wlMessage.text;
            break;
    }
    chatMsg.messageType = @(wlMessage.messageMediaType);
    chatMsg.timestamp = wlMessage.timestamp;
    chatMsg.avatorUrl = wlMessage.avatorUrl;
    chatMsg.isRead = @(wlMessage.isRead);
    chatMsg.sendStatus = @(wlMessage.sended.intValue);
    chatMsg.bubbleMessageType = @(wlMessage.bubbleMessageType);
    chatMsg.videoPath = wlMessage.videoPath;
    chatMsg.videoUrl = wlMessage.videoUrl;
//    chatMsg.videoConverPhoto = wlMessage.videoConverPhoto;
    chatMsg.voicePath = wlMessage.voicePath;
    chatMsg.voiceUrl = wlMessage.voiceUrl;
    chatMsg.geolocations = wlMessage.geolocations;
    chatMsg.latitude = @(wlMessage.location.coordinate.latitude);
    chatMsg.longitude = @(wlMessage.location.coordinate.longitude);
    chatMsg.sender = wlMessage.sender;
//    chatMsg.rsMyFriendUser = friendUser;
    [friendUser addRsChatMessagesObject:chatMsg];
    friendUser.unReadChatMsg = @(0);
    
    //是否显示时间戳
    if (lastChatMsg) {
        double min = [chatMsg.timestamp minutesLaterThan:lastChatMsg.timestamp];
        if (min > 2) {
            chatMsg.showTimeStamp = @(YES);
        }else{
            chatMsg.showTimeStamp = @(NO);
        }
    }else{
        chatMsg.showTimeStamp = @(YES);
    }
    
    //更新聊天好友
    friendUser.isChatNow = @(YES);
    //更新好友的聊天时间
    friendUser.lastChatTime = chatMsg.timestamp;
//    [MOC save];
    [friendUser.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    //更新好友的聊天时间
//    [friendUser updateLastChatTime:chatMsg.timestamp];
    //聊天状态发送改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatUserChanged" object:nil];
    
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
    NSInteger type = [dict[@"type"] integerValue];
    NSString *msg = dict[@"msg"];
    
    if(type == WLBubbleMessageMediaTypePhoto){
        //下载图片
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:msg]
                                                        options:SDWebImageRetryFailed|SDWebImageLowPriority
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                           
                                                       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                           if (finished) {
                                                               //保存到本地  图片名称
                                                               NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[NSString getNowTimestamp]];
                                                               //保存图片
                                                               NSString *path = [ResManager saveImage:image ToFolder:friendUser.uid.stringValue WithName:imageName];
                                                               [self createReciveMessageWithDict:dict ImagePath:path FriendUser:friendUser];
                                                           }else{
                                                               DLog(@"获取图片消息，下载图片失败");
                                                               return ;
                                                           }
                                                       }];
    }else{
        [self createReciveMessageWithDict:dict ImagePath:nil FriendUser:friendUser];
    }
}

+ (void)createReciveMessageWithDict:(NSDictionary *)dict ImagePath:(NSString *)imagePath FriendUser:(MyFriendUser *)friendUser
{
    NSString *created = dict[@"created"];
    NSInteger type = [dict[@"type"] integerValue];
    NSString *msg = dict[@"msg"];
    
    //是否显示时间戳
    ChatMessage *lastChatMsg = [friendUser getTheLastChatMessage];
    
    ChatMessage *chatMsg = [ChatMessage MR_createEntityInContext:friendUser.managedObjectContext];
    NSNumber *maxMsgId = [friendUser getMaxChatMessageId];
    chatMsg.msgId = @(maxMsgId.integerValue + 1);
    chatMsg.messageType = @(type);
    switch (type) {
        case WLBubbleMessageMediaTypeActivity:
        case WLBubbleMessageMediaTypeText:
            //文本
            chatMsg.message = msg;
            break;
        case WLBubbleMessageMediaTypePhoto://照片
            chatMsg.message = @"[图片]";
            chatMsg.messageType = @(type);
            chatMsg.messageType = @(WLBubbleMessageMediaTypePhoto);
            chatMsg.originPhotoUrl = msg;
            chatMsg.photoImage = nil;
            break;
        case WLBubbleMessageMediaTypeVoice:
            chatMsg.message = @"[语音]";
            chatMsg.messageType = @(WLBubbleMessageMediaTypeText);
            break;
        case WLBubbleMessageMediaTypeVideo:
            chatMsg.message = @"[视频]";
            chatMsg.messageType = @(WLBubbleMessageMediaTypeText);
            break;
        case WLBubbleMessageMediaTypeEmotion:
            chatMsg.message = @"[动态表情]";
            chatMsg.messageType = @(WLBubbleMessageMediaTypeText);
            break;
        case WLBubbleMessageMediaTypeLocalPosition:
            chatMsg.message = @"[视频]";
            chatMsg.messageType = @(WLBubbleMessageMediaTypeText);
            break;
        default:
            break;
    }
    chatMsg.timestamp = [created dateFromShortString];
    chatMsg.avatorUrl = friendUser.avatar;
    chatMsg.isRead = @(NO);
    chatMsg.sendStatus = @(1);
    chatMsg.bubbleMessageType = @(WLBubbleMessageTypeReceiving);//接受的数据
    //    chatMsg.videoPath = wlMessage.videoPath;
    //    chatMsg.videoUrl = wlMessage.videoUrl;
    //    chatMsg.videoConverPhoto = wlMessage.videoConverPhoto;
    //    chatMsg.voicePath = wlMessage.voicePath;
    //    chatMsg.voiceUrl = wlMessage.voiceUrl;
    //    chatMsg.geolocations = wlMessage.geolocations;
    //    chatMsg.latitude = @(wlMessage.location.coordinate.latitude);
    //    chatMsg.longitude = @(wlMessage.location.coordinate.longitude);
    chatMsg.sender = friendUser.name;
    //    chatMsg.rsMyFriendUser = friendUser;
    [friendUser addRsChatMessagesObject:chatMsg];
    //更新未读消息数量
    friendUser.unReadChatMsg = @(friendUser.unReadChatMsg.integerValue + 1);
    
    //是否显示时间戳
    if (lastChatMsg) {
        double min = [chatMsg.timestamp minutesLaterThan:lastChatMsg.timestamp];
        if (min > 1) {
            chatMsg.showTimeStamp = @(YES);
        }else{
            chatMsg.showTimeStamp = @(NO);
        }
    }else{
        chatMsg.showTimeStamp = @(YES);
    }
    
    [friendUser.managedObjectContext MR_saveToPersistentStoreAndWait];
    
    //更新好友的聊天时间
    [friendUser updateLastChatTime:chatMsg.timestamp];
    
    //更新总的聊天消息数量
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatMsgNumChanged" object:nil];
    //调用获取收到新消息，刷新正在聊天的列表
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"ReceiveNewChatMessage%@",friendUser.uid.stringValue] object:self userInfo:@{@"msgId":chatMsg.msgId}];
}

//创建特殊自定义聊天类型
+ (ChatMessage *)createSpecialMessageWithMessage:(WLMessage *)wlMessage FriendUser:(MyFriendUser *)friendUser
{
    //是否显示时间戳
    ChatMessage *lastChatMsg = [friendUser getTheLastChatMessage];
    
    ChatMessage *chatMsg = [ChatMessage MR_createEntityInContext:friendUser.managedObjectContext];
    chatMsg.msgId = @([friendUser getMaxChatMessageId].integerValue + 1);
    chatMsg.message = wlMessage.text;
    chatMsg.messageType = @(WLBubbleMessageSpecialTypeText);
    chatMsg.timestamp = [NSDate date];
    chatMsg.avatorUrl = wlMessage.avatorUrl;
    chatMsg.isRead = @(1);
    chatMsg.sendStatus = @(1);
    chatMsg.bubbleMessageType = @(WLBubbleMessageTypeSpecial);
    chatMsg.thumbnailUrl = nil;
    chatMsg.originPhotoUrl = nil;
    chatMsg.videoPath = nil;
    chatMsg.videoUrl = nil;
    //    chatMsg.videoConverPhoto = wlMessage.videoConverPhoto;
    chatMsg.voicePath = nil;
    chatMsg.voiceUrl = nil;
    chatMsg.geolocations = @"";
    chatMsg.latitude = 0;
    chatMsg.longitude = 0;
    chatMsg.sender = wlMessage.sender;
//    chatMsg.rsMyFriendUser = friendUser;
    [friendUser addRsChatMessagesObject:chatMsg];
    friendUser.unReadChatMsg = @(0);
    
    //是否显示时间戳
    if (lastChatMsg) {
        double min = [chatMsg.timestamp minutesLaterThan:lastChatMsg.timestamp];
        if (min > 1) {
            chatMsg.showTimeStamp = @(YES);
        }else{
            chatMsg.showTimeStamp = @(NO);
        }
    }else{
        chatMsg.showTimeStamp = @(YES);
    }
    
    [friendUser.managedObjectContext MR_saveToPersistentStoreAndWait];
//    [MOC save];
    
    //更新好友的聊天时间
    [friendUser updateLastChatTime:chatMsg.timestamp];
    
    return chatMsg;
}

//更新发送状态
- (void)updateSendStatus:(NSInteger)status
{
    self.sendStatus = @(status);
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
//    [MOC save];
    
    DLog(@"changed: ---- %d",self.sendStatus.intValue);
    
    //聊天状态发送改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatUserChanged" object:nil];
}

//更新读取状态
- (void)updateReadStatus:(BOOL)status
{
    self.isRead = @(status);
//    [MOC save];
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
}

//更新重新发送状态
- (void)updateReSendStatus
{
    self.sendStatus = @(0);
    self.timestamp = [NSDate date];
//    [MOC save];
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
}

//更新发送的消息的服务器时间
- (void)updateTimeStampFromServer:(NSString *)time
{
    self.timestamp = [time dateFromShortString];
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
//    [MOC save];
}

@end
