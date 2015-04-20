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
@dynamic messageid;
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
@dynamic cardId;
@dynamic cardTitle;
@dynamic cardType;
@dynamic cardIntro;
@dynamic cardUrl;
@dynamic cardMsg;
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
    [KNSNotification postNotificationName:kChatUserChanged object:nil];
    
    return chatMsg;
}

//创建新的卡片聊天记录
+ (ChatMessage *)createChatMessageWithCard:(CardStatuModel *)cardModel FriendUser:(MyFriendUser *)friendUser
{
    //是否显示时间戳
    ChatMessage *lastChatMsg = [friendUser getTheLastChatMessage];
    
    ChatMessage *chatMsg = [ChatMessage MR_createEntityInContext:friendUser.managedObjectContext];
    chatMsg.msgId = @([friendUser getMaxChatMessageId].integerValue + 1);
    
    switch (cardModel.type.integerValue) {
        case 3://活动
            chatMsg.message = @"[活动]";
            break;
        case 10://项目
            chatMsg.message = @"[项目]";
            break;
        case 11://网页
            chatMsg.message = @"[链接]";
            break;
        default:
            break;
    }
    chatMsg.messageType = @(WLBubbleMessageMediaTypeCard);
    chatMsg.timestamp = [NSDate date];
    chatMsg.cardMsg = cardModel.content;
    chatMsg.avatorUrl = friendUser.rsLogInUser.avatar;
    chatMsg.isRead = @(1);
    chatMsg.sendStatus = @(0);
    chatMsg.bubbleMessageType = @(WLBubbleMessageTypeSending);
    chatMsg.videoPath = @"";
    chatMsg.sender = friendUser.rsLogInUser.name;
    chatMsg.cardId = cardModel.cid;
    chatMsg.cardTitle = cardModel.title;
    chatMsg.cardType = cardModel.type;
    chatMsg.cardIntro = cardModel.intro;
    chatMsg.cardUrl = cardModel.url;
    chatMsg.sendStatus = @(1);//发送成功
    
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
    [KNSNotification postNotificationName:kChatUserChanged object:nil];
    //调用获取收到新消息，刷新正在聊天的列表
    [KNSNotification postNotificationName:[NSString stringWithFormat:kReceiveNewChatMessage,friendUser.uid.stringValue] object:self userInfo:@{@"msgId":chatMsg.msgId}];
    
    return chatMsg;
}

//创建添加好友成功的本地可以聊天的消息
+ (ChatMessage *)createChatMessageForAddFriend:(MyFriendUser *)friendUser
{
    //接受后，本地创建一条消息
    WLMessage *textMessage = [[WLMessage alloc] initWithSpecialText:[NSString stringWithFormat:@"你已添加我为好友,现在可以聊聊创业那些事了"] sender:friendUser.name timestamp:[NSDate date]];
    textMessage.avatorUrl = friendUser.avatar;
    textMessage.sender = nil;
    //是否读取
    textMessage.isRead = YES;
    textMessage.sended = @"1";
    textMessage.bubbleMessageType = WLBubbleMessageTypeReceiving;
    textMessage.messageMediaType = WLBubbleMessageMediaTypeText;

    //    //本地聊天数据库添加
    ChatMessage *chatMessage = [ChatMessage createChatMessageWithWLMessage:textMessage FriendUser:friendUser];
    textMessage.msgId = chatMessage.msgId.stringValue;
    
    return chatMessage;
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
    NSNumber *toUser = dict[@"uid"];
    LogInUser *loginUser = [LogInUser getLogInUserWithUid:toUser];
    //如果本地数据库没有当前登陆用户，不处理
    if (loginUser == nil) {
        return;
    }
    
    NSNumber *fromUid = [[dict objectForKey:@"fromuser"] objectForKey:@"uid"];
    MyFriendUser *friendUser = [loginUser getMyfriendUserWithUid:fromUid];
    if(friendUser){
    }else{
        if (fromUid.integerValue <= 100) {
            //系统定义的好友，推来消息，自动设置好友关系
            friendUser = [MyFriendUser createMyFriendFromReceive:dict];
        }else{
            //其他的不设置聊天信息
            return;
        }
    }
    
//    MyFriendUser *friendUser = [MyFriendUser createMyFriendFromReceive:dict];
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
    NSString *messageid = dict[@"messageid"];
    
    //是否显示时间戳
    ChatMessage *lastChatMsg = [friendUser getTheLastChatMessage];
    
    ChatMessage *chatMsg = nil;
    //非系统推送消息
    chatMsg = [self getChatMsgWithMessageId:messageid];
    //如果存在对应messageId的聊天消息，则不提醒
    if (chatMsg) {
        return;
    }else{
        chatMsg = [ChatMessage MR_createEntityInContext:friendUser.managedObjectContext];
    }
//    if (friendUser.uid.integerValue > 100) {
//        
//    }else{
//        //系统推送消息
//        chatMsg = [ChatMessage MR_createEntityInContext:friendUser.managedObjectContext];
//    }
    
    NSNumber *maxMsgId = [friendUser getMaxChatMessageId];
    chatMsg.msgId = @(maxMsgId.integerValue + 1);
    chatMsg.messageType = @(type);
    switch (type) {
        case WLBubbleMessageMediaTypeText:
            //文本
            chatMsg.message = msg;
            break;
        case WLBubbleMessageMediaTypePhoto://照片
            chatMsg.message = @"[图片]";
            chatMsg.messageType = @(type);
            chatMsg.messageType = @(WLBubbleMessageMediaTypePhoto);
            chatMsg.thumbnailUrl = imagePath;
            chatMsg.originPhotoUrl = msg;
            chatMsg.photoImage = nil;
            break;
//        case WLBubbleMessageMediaTypeVoice:
//            chatMsg.message = @"[语音]";
//            chatMsg.messageType = @(WLBubbleMessageMediaTypeText);
//            break;
//        case WLBubbleMessageMediaTypeVideo:
//            chatMsg.message = @"[视频]";
//            chatMsg.messageType = @(WLBubbleMessageMediaTypeText);
//            break;
//        case WLBubbleMessageMediaTypeEmotion:
//            chatMsg.message = @"[动态表情]";
//            chatMsg.messageType = @(WLBubbleMessageMediaTypeText);
//            break;
//        case WLBubbleMessageMediaTypeLocalPosition:
//            chatMsg.message = @"[视频]";
//            chatMsg.messageType = @(WLBubbleMessageMediaTypeText);
//            break;
        case WLBubbleMessageMediaTypeActivity://活动
        case WLBubbleMessageMediaTypeCard:
            //卡片 //3 活动，10项目，11 网页
        {
            NSDictionary *card = dict[@"card"];
            NSNumber *cid = card[@"cid"];
            NSString *title = card[@"title"];
            NSString *intro = card[@"intro"];
            NSString *url = card[@"url"];
            NSInteger cardType = [card[@"type"] integerValue];
            
            chatMsg.cardId = cid;
            chatMsg.cardType = @(cardType);
            chatMsg.cardTitle = title;
            chatMsg.cardIntro = intro;
            chatMsg.cardUrl = url;
            chatMsg.cardMsg = msg;
            
            switch (cardType) {
                case WLBubbleMessageCardTypeActivity://活动
                    chatMsg.message = @"[活动]";
                    break;
                case WLBubbleMessageCardTypeProject://项目
                    chatMsg.message = @"[项目]";
                    break;
                case WLBubbleMessageCardTypeWeb://网页
                    chatMsg.message = @"[链接]";
                    break;
                default:
                    chatMsg.message = @"对方刚给你发了一条消息，您当前版本无法查看，快去升级吧.";
                    break;
            }
        }
            break;
        default:
        {
            //其他未知类型
            chatMsg.message = msg.length > 0 ? msg : @"对方刚给你发了一条消息，您当前版本无法查看，快去升级吧.";
        }
            break;
    }
    chatMsg.messageid = messageid;//消息编号
    chatMsg.timestamp = created.length > 0 ? [created dateFromNormalString] : [NSDate date];
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
    friendUser.unReadChatMsg = friendUser.isMyFriend.boolValue ? @(friendUser.unReadChatMsg.integerValue + 1) : @(0);
    friendUser.lastChatTime = chatMsg.timestamp;//更新好友的聊天时间
    friendUser.isChatNow = @(YES);
    
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
//    [friendUser updateLastChatTime:chatMsg.timestamp];
    
    //更新总的聊天消息数量
    [KNSNotification postNotificationName:kChatMsgNumChanged object:nil];
    //调用获取收到新消息，刷新正在聊天的列表
    [KNSNotification postNotificationName:[NSString stringWithFormat:kReceiveNewChatMessage,friendUser.uid.stringValue] object:self userInfo:@{@"msgId":chatMsg.msgId}];
    //聊天状态发送改变
    [KNSNotification postNotificationName:kChatUserChanged object:nil];
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
    friendUser.lastChatTime = chatMsg.timestamp;//更新好友的聊天时间
    
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
//    [friendUser updateLastChatTime:chatMsg.timestamp];
    
    return chatMsg;
}

//获取对应messageId的消息
+ (ChatMessage *)getChatMsgWithMessageId:(NSString *)messageId
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@ && %K == %@", @"rsMyFriendUser.rsLogInUser",loginUser,@"messageid",messageId];
    ChatMessage *chatMessage = [ChatMessage MR_findFirstWithPredicate:pre inContext:loginUser.managedObjectContext];
    return chatMessage;
}

//获取当前最大的消息ID
+ (NSString *)getMaxChatMessageId
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"%K == %@", @"rsMyFriendUser.rsLogInUser",loginUser];
    NSArray *chatMsgs = [ChatMessage MR_findAllWithPredicate:pre inContext:loginUser.managedObjectContext];
    ChatMessage *chatMessage = nil;
    if (chatMsgs.count > 0) {
        NSArray *sortMessages = [chatMsgs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 messageid] integerValue] > [[obj2 messageid] integerValue];
        }];
        chatMessage = [sortMessages lastObject];
    }
//    ChatMessage *chatMessage = [ChatMessage MR_findFirstWithPredicate:pre sortedBy:@"messageid" ascending:NO inContext:loginUser.managedObjectContext];
    if (chatMessage.messageid.length > 0) {
        return chatMessage.messageid;
    }else{
        return @"0";
    }
}

//更新发送状态
- (void)updateSendStatus:(NSInteger)status
{
    self.sendStatus = @(status);
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
//    [MOC save];
    
    DLog(@"changed: ---- %d",self.sendStatus.intValue);
    
    //聊天状态发送改变
    [KNSNotification postNotificationName:kChatUserChanged object:nil];
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
    self.timestamp = [time dateFromNormalString];
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
//    [MOC save];
}

//消息列表页面显示的消息内容
- (NSString *)displayChatListMessageInfo
{
    NSString *msg = @"";
    switch (self.messageType.integerValue) {
        case WLBubbleMessageMediaTypeText:
            //文本
            msg = self.message;
            break;
        case WLBubbleMessageMediaTypePhoto://照片
            msg = @"[图片]";
            break;
        case WLBubbleMessageMediaTypeActivity://活动
        case WLBubbleMessageMediaTypeCard:
        {
            //卡片 //3 活动，10项目，11 网页
            switch (self.cardType.integerValue) {
                case WLBubbleMessageCardTypeActivity://活动
                case WLBubbleMessageCardTypeProject://项目
                case WLBubbleMessageCardTypeWeb://网页
                    msg = self.cardMsg.length > 0 ? self.cardMsg : self.message;
                    break;
                default:
                    //未知类型
                    msg = self.message;
                    break;
            }
        }
            break;
        default:
        {
            //其他未知类型
            msg = self.message;
        }
            break;
    }
    return msg;
}

@end
