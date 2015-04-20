//
//  Constants.m
//  Welian
//
//  Created by weLian on 15/4/14.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#pragma mark - NSNotification Key
NSString *const kAccepteFriend = @"Accepte%@";//同意好友请求
NSString *const KupdataMyAllFriends = @"KupdataMyAllFriends";//我的好友更新通知

//----------聊天
NSString *const kChatMsgNumChanged = @"ChatMsgNumChanged";//聊天消息数量改变
NSString *const kChatUserChanged = @"ChatUserChanged";//正在聊天的用户列表改变
NSString *const kChatFromUserInfo = @"ChatFromUserInfo";//从好友详情进入聊天页面
NSString *const kCurrentChatFromUserInfo = @"CurrentChatFromUserInfo";//从消息页面 切换 进入聊天页面
NSString *const kReceiveNewChatMessage = @"ReceiveNewChatMessage%@";//接收最新的聊天信息
NSString *const kChangeTapToChatList = @"ChangeTapToChatList";//改变下方的tab到消息页面
NSString *const kUpdateMainMessageBadge = @"UpdateMainMessageBadge";//更新主页面聊天消息角标

//----- 活动
NSString *const kMyActivityInfoChanged = @"MyActivityInfoChanged";//我的活动信息改变
NSString *const kNeedReloadActivityUI = @"NeedReloadActivityUI";//重新加载活动UI
NSString *const kUpdateJoinedUI = @"UpdateJoinedUI";//更新报名的活动列表

//------ 支付宝支付通知
NSString *const kAlipayPaySuccess = @"AlipayPaySuccess";//支付成功


//------新的通知
NSString *const KNewFriendNotif = @"KNewFriendNotif";// 新好友通知
NSString *const KPublishOK = @"PublishStatusOK";// 发布动态成功
NSString *const KLogoutNotif = @"KLogoutNotif";// 退出登录通知
NSString *const KMessageHomeNotif = @"KMessageHomeNotif";// 首页消息通知
NSString *const KNewactivitNotif = @"KNewactivitNotif";// 新活动的通知
NSString *const KInvestorstateNotif = @"KInvestorstateNotif";// 投资人状态通知
NSString *const KProjectstateNotif = @"ProjectstateNotif";// 项目通知
NSString *const KRefreshMyProjectNotif = @"RefreshMyProjectNotif";//刷新个人项目列表
NSString *const KNEWStustUpdate = @"KNEWStustUpdate";// 首页动态有 更新通知


#pragma mark - NSUserDefaults Key
NSString *const kMaxChatMessageId = @"MaxChatMessageId";//最大的聊天消息Id
NSString *const kMaxNewFriendId = @"MaxNewFriendId";//最大的好友请求Id
NSString *const kLocationCity = @"LocationCity";//定位的城市
NSString *const kIsLookAtNewFriendVC = @"isLookAtNewFriendVC";//是否在新的好友通知页面
NSString *const kBPushRequestChannelIdKey = @"channel_id";// 返回结果的键
NSString *const kSessionId = @"sessionid";// sessionId
NSString *const kSidkey = @"sid";// sessionId
NSString *const kChatNowKey = @"chat:%@";//正在聊天中





