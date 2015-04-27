//
//  Constants.h
//  Welian
//
//  Created by weLian on 15/4/14.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//


#pragma mark - NSNotification Key
extern NSString *const kAccepteFriend;//同意好友请求
extern NSString *const KupdataMyAllFriends;//我的好友更新通知

//----------聊天
extern NSString *const kChatMsgNumChanged;//聊天消息数量改变
extern NSString *const kChatUserChanged;//正在聊天的用户列表改变
extern NSString *const kChatFromUserInfo;//从好友详情进入聊天页面
extern NSString *const kCurrentChatFromUserInfo;//从消息页面 切换 进入聊天页面
extern NSString *const kReceiveNewChatMessage;//接收最新的聊天信息
extern NSString *const kChangeTapToChatList;//改变下方的tab到消息页面
extern NSString *const kUpdateMainMessageBadge;//更新主页面聊天消息角标

//----- 活动
extern NSString *const kMyActivityInfoChanged;//我的活动信息改变
extern NSString *const kNeedReloadActivityUI;//重新加载活动UI
extern NSString *const kUpdateJoinedUI;//更新报名的活动列表

//------ 支付宝支付通知
extern NSString *const kAlipayPaySuccess;//支付成功

//------新的通知
extern NSString *const KNewFriendNotif;// 新好友通知
extern NSString *const KPublishOK;// 发布动态成功
extern NSString *const KLogoutNotif;// 退出登录通知

extern NSString *const KMessageHomeNotif;// 首页消息通知
extern NSString *const KNewactivitNotif;// 新活动的通知
extern NSString *const KInvestorstateNotif;// 投资人状态通知
extern NSString *const KProjectstateNotif;// 项目通知
extern NSString *const KRefreshMyProjectNotif;//刷新个人项目列表
extern NSString *const KNEWStustUpdate;// 首页动态有 更新通知



#pragma mark - NSUserDefaults Key
extern NSString *const kMaxChatMessageId;//最大的聊天消息Id
extern NSString *const kMaxNewFriendId;//最大的好友请求Id
extern NSString *const kLocationCity;//定位的城市
extern NSString *const kIsLookAtNewFriendVC;//是否在新的好友通知页面
extern NSString *const kBPushRequestChannelIdKey;// 返回结果的键
extern NSString *const kSessionId;// sessionId
//extern NSString *const kSidkey;// sessionId
extern NSString *const kChatNowKey;//正在聊天中




