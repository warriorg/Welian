//
//  ChatMessage.h
//  Welian
//
//  Created by weLian on 14/12/27.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MyFriendUser,WLMessage,CardStatuModel;

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
@property (nonatomic, retain) NSData * photoImage;//照片
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
@property (nonatomic, retain) NSNumber * showTimeStamp;//是否显示时间戳
@property (nonatomic, retain) NSNumber * cardId;//卡片标题
@property (nonatomic, retain) NSNumber * cardType;//卡片类型 //3 活动，10项目，11 网页
@property (nonatomic, retain) NSString * cardTitle;//卡片标题
@property (nonatomic, retain) NSString * cardIntro;//卡片详情
@property (nonatomic, retain) NSString * cardUrl;//卡片链接
@property (nonatomic, retain) NSString * cardMsg;//卡片评论消息
@property (nonatomic, retain) MyFriendUser *rsMyFriendUser;

//创建新的聊天记录
+ (ChatMessage *)createChatMessageWithWLMessage:(WLMessage *)wlMessage FriendUser:(MyFriendUser *)friendUser;

//创建新的卡片聊天记录
+ (ChatMessage *)createChatMessageWithCard:(CardStatuModel *)cardModel FriendUser:(MyFriendUser *)friendUser;

//创建添加好友成功的本地可以聊天的消息
+ (ChatMessage *)createChatMessageForAddFriend:(MyFriendUser *)friendUser;

//创建接受到的聊天消息
+ (void)createReciveMessageWithDict:(NSDictionary *)dict;

//创建特殊自定义聊天类型
+ (ChatMessage *)createSpecialMessageWithMessage:(WLMessage *)wlMessage FriendUser:(MyFriendUser *)friendUser;

//获取当前最大的消息ID
+ (NSNumber *)getMaxChatMessageId;

//更新发送状态
- (void)updateSendStatus:(NSInteger)status;
//更新读取状态
- (void)updateReadStatus:(BOOL)status;
//更新重新发送状态
- (void)updateReSendStatus;
//更新发送的消息的服务器时间
- (void)updateTimeStampFromServer:(NSString *)time;

//消息列表页面显示的消息内容
- (NSString *)displayChatListMessageInfo;

@end
