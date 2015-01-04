//
//  ChatMessage.h
//  Welian
//
//  Created by weLian on 14/12/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyFriendUser,WLMessage;

@interface ChatMessage : NSManagedObject

@property (nonatomic, retain) NSNumber * msgId;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSNumber * messageType;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * avatorUrl;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSNumber * sendStatus;
@property (nonatomic, retain) NSNumber * bubbleMessageType;
@property (nonatomic, retain) NSString * thumbnailUrl;
@property (nonatomic, retain) NSString * originPhotoUrl;
@property (nonatomic, retain) NSString * videoPath;
@property (nonatomic, retain) NSString * videoUrl;
@property (nonatomic, retain) NSString * videoConverPhoto;
@property (nonatomic, retain) NSString * voicePath;
@property (nonatomic, retain) NSString * voiceUrl;
@property (nonatomic, retain) NSString * localPositionPhoto;
@property (nonatomic, retain) NSString * geolocations;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) MyFriendUser *rsMyFriendUser;

//创建新的聊天记录
+ (ChatMessage *)createChatMessageWithWLMessage:(WLMessage *)wlMessage FriendUser:(MyFriendUser *)friedUser;

//创建接受到的聊天消息
+ (void)createReciveMessageWithDict:(NSDictionary *)dict;

//创建特殊自定义聊天类型
+ (ChatMessage *)createSpecialMessageWithMessage:(WLMessage *)wlMessage FriendUser:(MyFriendUser *)friedUser;

//更新发送状态
- (void)updateSendStatus:(NSInteger)status;
//更新读取状态
- (void)updateReadStatus:(BOOL)status;
//更新重新发送状态
- (void)updateReSendStatus;

@end
