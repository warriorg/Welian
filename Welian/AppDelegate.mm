//
//  AppDelegate.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "AppDelegate.h"
#import "BMapKit.h"
#import "MainViewController.h"
#import "NavViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ShareEngine.h"
#import "WLTool.h"
#import "LoginViewController.h"
#import "NewFriendModel.h"
#import "MJExtension.h"
#import "MobClick.h"
#import "MessageHomeModel.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "NewFriendUser.h"
#import "HomeMessage.h"
#import "ChatMessage.h"
#import "WLMessage.h"
#import "MyFriendUser.h"
#import "NeedAddUser.h"
#import <ShareSDK/ShareSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import "LoginGuideController.h"
#import "MsgPlaySound.h"

#define kStoreName @"weLianAppDis.sqlite"

@interface AppDelegate() <BMKGeneralDelegate,UITabBarControllerDelegate>
{
    MainViewController *mainVC;
    NSInteger _update; //0不提示更新 1不强制更新，2强制更新
     NSString *_upURL; // 更新地址
    NSString *_msg;  // 更新提示语
    UIAlertView *_updataalert;
//    UIAlertView *_logoutAlert;
}
@end

@implementation AppDelegate
single_implementation(AppDelegate)
BMKMapManager* _mapManager;



- (void)registerRemoteNotification
{
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    } else {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

//设置数据库转移
- (void)copyDefaultStoreIfNecessary
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:kStoreName];
    
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]])
    {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:[kStoreName stringByDeletingPathExtension] ofType:[kStoreName pathExtension]];
        if (defaultStorePath)
        {
            NSError *error;
            BOOL success = [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:&error];
            if (!success)
            {
                NSLog(@"Failed to install default recipe store");
            }
        }
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //数据库操作
    [self copyDefaultStoreIfNecessary];
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:kStoreName];
    
    // 版本更新
    [self detectionUpdataVersionDic];
    
    // 友盟统计
    [self umengTrack];
    
    // 要使用百度地图，请先启动BaiduMapManager
	_mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [_mapManager start:KBMK_Key generalDelegate:self];
	if (!ret) {
        
	}
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    // 添加微信分享
    [[ShareEngine sharedShareEngine] registerApp];
    [ShareSDK registerApp:KShareSDKAppKey];
    [ShareSDK connectWeChatWithAppId:kWeChatAppId
                           appSecret:KWeChatAppSecret
                           wechatCls:[WXApi class]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /**
     *  设置状态栏颜色
     */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    LogInUser *mode = [LogInUser getCurrentLoginUser];
    DLog(@"%@",mode.description);
    if (mode.sessionid&&mode.mobile&&[UserDefaults objectForKey:@"sessionid"]) {
        /** 已登陆 */
        mainVC = [[MainViewController alloc] init];
        [mainVC setDelegate:self];
//        [LogInUser setUserNewstustcount:@(0)];
        [mainVC loadNewStustupdata];
        [self.window setRootViewController:mainVC];
    }else{
        /** 未登陆 */
        LoginGuideController *loginGuideVC = [[LoginGuideController alloc] init];
        [self.window setRootViewController:loginGuideVC];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DLog(@"====沙盒路径=======%@",paths);
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:KGTAppId appKey:KGTAppKey appSecret:kGTAppSecret];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
    
    return YES;
}

#pragma mark - 检测版本更新
- (void)detectionUpdataVersionDic
{
    [WLTool updateVersions:^(NSDictionary *versionDic) {
        if ([[versionDic objectForKey:@"flag"] integerValue]==1) {
            NSString *msg = [versionDic objectForKey:@"msg"];
            _upURL = [versionDic objectForKey:@"url"];
            _update = [[versionDic objectForKey:@"update"] integerValue];
            _msg = msg;
            if (_update==0) { //自己检测
                
                
            }else if(_update == 1){  // 弹出提示
                
                _updataalert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:msg  delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"立即更新", nil];
                [_updataalert show];
            }else if (_update == 2){  // 强制更新
               _updataalert = [[UIAlertView alloc] initWithTitle:@"更新提示" message:msg  delegate:self cancelButtonTitle:nil otherButtonTitles:@"立即更新", nil];
                [_updataalert show];
            }
            
        }else{
        }
    }];
}

#pragma mark - 版本更新跳转- 退出登录
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _updataalert) {
        if (_update==1) {
            if (buttonIndex==1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_upURL]];
            }
        }else if (_update==2){
            if (buttonIndex==0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_upURL]];
            }
        }
    }
}


- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!_gexinPusher) {
        _sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        _clientId = nil;
        
        NSError *err = nil;
        _gexinPusher = [GexinSdk createSdkWithAppId:_appID
                                             appKey:_appKey
                                          appSecret:_appSecret
                                         appVersion:XcodeAppVersion
                                           delegate:self
                                              error:&err];
        if (!_gexinPusher) {
            
        } else {
            _sdkStatus = SdkStatusStarting;
        }
    }
}

- (void)stopSdk
{
    if (_gexinPusher) {
        [_gexinPusher destroy];
        _gexinPusher = nil;
        
        _sdkStatus = SdkStatusStoped;
        
        _clientId = nil;
    }
}


- (BOOL)checkSdkInstance
{
    if (!_gexinPusher) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK未启动" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (void)setDeviceToken:(NSString *)aToken
{
    if (![self checkSdkInstance]) {
        return;
    }
    
    [_gexinPusher registerDeviceToken:aToken];
}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    if (![self checkSdkInstance]) {
        return NO;
    }
    
    return [_gexinPusher setTags:aTags];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    if (![self checkSdkInstance]) {
        return nil;
    }
    
    return [_gexinPusher sendMessage:body error:error];
}

#pragma mark - 友盟统计
- (void)umengTrack {
    
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:UMENG_ChannelId];
}

#if __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // [3]:向个推服务器注册deviceToken
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:_deviceToken];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    if (_gexinPusher) {
        [_gexinPusher registerDeviceToken:@""];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

#pragma mark - 接收推送收取一条
- (void)inceptMessage:(NSDictionary*)userInfo
{
    NSString *type = [userInfo objectForKey:@"type"];
    if (!type) return;
    
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[userInfo objectForKey:@"data"]];
    [dataDic setObject:type forKey:@"type"];
    
    if ([type isEqualToString:@"feedZan"]||[type isEqualToString:@"feedComment"]||[type isEqualToString:@"feedForward"]) {     // 动态消息推送

        [HomeMessage createHomeMessageModel:[MessageHomeModel objectWithKeyValues:dataDic]];
        NSInteger badge = [[LogInUser getCurrentLoginUser].homemessagebadge integerValue];
        badge++;
        [LogInUser setUserHomemessagebadge:@(badge)];
//        [UserDefaults setObject:[NSString stringWithFormat:@"%d",badge] forKey:KMessagebadge];
        [KNSNotification postNotificationName:KMessageHomeNotif object:self];
        
    }else if([type isEqualToString:@"friendRequest"]||[type isEqualToString:@"friendAdd"]||[type isEqualToString:@"friendCommand"]){
        /*
         data =     {
         avatar = "http://img.welian.com/1418619525311-200-200_x.jpg";
         company = "\U676d\U5dde\U4f20\U9001\U95e8\U7f51\U7edc\U6280\U672f\U6709\U9650\U516c\U53f8";
         created = "2015-03-31 15:25:03";
         msg = "\U6211\U662f\U676d\U5dde\U4f20\U9001\U95e8\U7f51\U7edc\U6280\U672f\U6709\U9650\U516c\U53f8\U7684iOS\U9ad8\U7ea7\U5f00\U53d1\U5de5\U7a0b\U5e08";
         name = "\U6d4b\U8bd511078";
         position = "iOS\U9ad8\U7ea7\U5f00\U53d1\U5de5\U7a0b\U5e08";
         uid = 11078;
         };
         type = friendRequest;
         */
        // 好友消息推送
        [self getNewFriendMessage:dataDic LoginUserId:nil];
        // 振动和声音提示
//        [[MsgPlaySound sharedMsgPlaySound] playSystemShakeAndSoundWithName:@"1"];
    }else if([type isEqualToString:@"IM"]){
        //接收的聊天消息
        [self getIMGTMessage:userInfo[@"data"]];
        // 振动和声音提示
//        [[MsgPlaySound sharedMsgPlaySound] playSystemShakeAndSoundWithName:@"1"];
    } else if ([type isEqualToString:@"logout"]){
        // 退出登录
        [self logout];
    }else if ([type isEqualToString:@"activeCommand"]){  // 活动推荐
        
        [LogInUser setUserIsactivebadge:YES];
        [KNSNotification postNotificationName:KNewactivitNotif object:self];
    }else if ([type isEqualToString:@"investorResult"]){  // 后台认证投资人
        
        [LogInUser setUserinvestorauth:[dataDic objectForKey:@"state"]];
        [LogInUser setUserIsinvestorbadge:YES];
        [KNSNotification postNotificationName:KInvestorstateNotif object:self];
    }else if ([type isEqualToString:@"projectComment"]){  // 项目评论
        NSDictionary *infoDic = [userInfo objectForKey:@"data"];
        [HomeMessage createHomeMessageProjectModel:infoDic];
        //发现
        NSInteger badge = [[LogInUser getCurrentLoginUser].homemessagebadge integerValue];
        badge++;
        //设置首页
        [LogInUser setUserHomemessagebadge:@(badge)];
        [KNSNotification postNotificationName:KMessageHomeNotif object:self];
    }else if ([type isEqualToString:@"projectCommand"]){  // 新项目推荐
        //设置有新的项目未查看
        [LogInUser setUserIsProjectBadge:YES];
        [KNSNotification postNotificationName:KProjectstateNotif object:self];
    }
}

// 接受新的好友请求消息
- (void)getNewFriendMessage:(NSDictionary *)dataDic LoginUserId:(NSNumber *)userId
{
    NSString *type = [dataDic objectForKey:@"type"];
    NewFriendModel *newfrendM = [NewFriendModel objectWithKeyValues:dataDic];
    LogInUser *loginUser = nil;
    if (userId) {
        //接口获取
        loginUser = [LogInUser getLogInUserWithUid:userId];
    }else{
        loginUser = [LogInUser getCurrentLoginUser];;
    }
    //判断当前是否已经是好友
    NewFriendUser *newFriendUser = [loginUser getNewFriendUserWithUid:newfrendM.uid];
    if ([type isEqualToString:@"friendAdd"]) {
        // 别人同意添加我为好友，直接加入好友列表，并改变新的好友里状态为已添加
        [newfrendM setIsAgree:@(1)];
        //操作类型0：添加 1：接受  2:已添加 3：待验证
        [newfrendM setOperateType:@(2)];
        
        //创建本地数据库好友
        MyFriendUser *friendUser = [MyFriendUser createMyFriendNewFriendModel:newfrendM LogInUser:loginUser];
        
        //修改需要添加的用户的状态
        NeedAddUser *needAddUser = [loginUser getNeedAddUserWithUid:friendUser.uid];
        [needAddUser updateFriendShip:1];
        
        //接受后，本地创建一条消息
        WLMessage *textMessage = [[WLMessage alloc] initWithText:[NSString stringWithFormat:@"我已经通过你的好友请求，现在我们可以开始聊聊创业那些事了"] sender:newfrendM.name timestamp:[NSDate date]];
        textMessage.avatorUrl = newfrendM.avatar;
        //是否读取
        textMessage.isRead = NO;
        textMessage.sended = @"1";
        textMessage.bubbleMessageType = WLBubbleMessageTypeReceiving;
        
        //更新聊天好友
        [friendUser updateIsChatStatus:YES];
        
        //本地聊天数据库添加
        ChatMessage *chatMessage = [ChatMessage createChatMessageWithWLMessage:textMessage FriendUser:friendUser];
        textMessage.msgId = chatMessage.msgId.stringValue;
        
        //更新聊天消息数量
        [friendUser updateUnReadMessageNumber:@(friendUser.unReadChatMsg.integerValue + 1)];
        
        //更新好友列表
        [[NSNotificationCenter defaultCenter] postNotificationName:KupdataMyAllFriends object:self];
    }else{
        [newfrendM setIsAgree:@(0)];
        //别人请求加我为好友
        //操作类型0：添加 1：接受  2:已添加 3：待验证
        MyFriendUser *myFriendUser = [loginUser getMyfriendUserWithUid:newfrendM.uid];
        if (myFriendUser) {
            if(myFriendUser.isMyFriend.boolValue){
                [newfrendM setOperateType:@(2)];
            }else{
                //设置不是我的好友
                [myFriendUser updateIsNotMyFriend];
                
                if ([type isEqualToString:@"friendRequest"]) {
                    //如果是好友，设置为已添加
                    [newfrendM setOperateType:@(1)];
                }
                //推荐的
                if([type isEqualToString:@"friendCommand"]){
                    [newfrendM setOperateType:@(0)];
                }
            }
        }else{
            //不是我的好友
            if ([type isEqualToString:@"friendRequest"]) {
                //如果是好友，设置为已添加
                [newfrendM setOperateType:@(1)];
            }
            //推荐的
            if([type isEqualToString:@"friendCommand"]){
                [newfrendM setOperateType:@(0)];
            }
        }
        
        if (!([newFriendUser.operateType integerValue]==2)) {
            //不是好友，添加角标
            NSInteger badge = [loginUser.newfriendbadge integerValue];
            if (!badge) {
                //设置是否在新的好友通知页面
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isLookAtNewFriendVC"]) {
                    [LogInUser setUserNewfriendbadge:@(1)];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:KNewFriendNotif object:self];
            }
        }
    }
    
    //创建的时间
    newfrendM.created = newfrendM.created.length > 0 ? newfrendM.created : [[NSDate date] formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [NewFriendUser createNewFriendUserModel:newfrendM];
}

// 接收聊天消息
- (void)getIMGTMessage:(NSDictionary *)dataDic
{
    //添加数据
    [ChatMessage createReciveMessageWithDict:dataDic];
}

// 退出登录
- (void)logout
{
    if ([self.window.rootViewController isKindOfClass:[LoginGuideController class]])
        return;
    [self.window setRootViewController:[[LoginGuideController alloc] init]];
    [UserDefaults removeObjectForKey:@"sessionid"];
    [LogInUser setUserisNow:NO];
    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"您的微链账号已经在其他设备上登录"  delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
    if ([LogInUser getCurrentLoginUser]) {
        [WLHttpTool logoutParameterDic:@{} success:^(id JSON) {
            
        } fail:^(NSError *error) {
            
        }];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    DLog(@"应用程序将要进入非活动状态，即将进入后台");
    LogInUser *user = [LogInUser getCurrentLoginUser];
    if (user) {
    [UIApplication sharedApplication].applicationIconBadgeNumber = user.newfriendbadge.integerValue+user.homemessagebadge.integerValue+[user allUnReadChatMessageNum];
    }

    //隐藏活动中的键盘,防止重新进入程序 uitextfiled 偏移问题
    [[[application keyWindow].rootViewController.view findFirstResponder] resignFirstResponder];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLog(@"如果应用程序支持后台运行，则应用程序已经进入后台运行");
    // [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
    [self stopSdk];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNEWStustUpdate object:self];
    DLog(@"应用程序将要进入活动状态，即将进入前台运行");

}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLog(@"应用程序已进入前台，处于活动状态");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // [EXT] 重新上线
    [self startSdkWith:_appID appKey:_appKey appSecret:_appSecret];
    if (_update == 2){  // 强制更新
        _updataalert =  [[UIAlertView alloc] initWithTitle:@"更新提示" message:_msg  delegate:self cancelButtonTitle:nil otherButtonTitles:@"立即更新", nil];
        [_updataalert show];
    }
    
    //获取聊天消息记录 和好友请求消息
    [self getServiceChatMsgInfo];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //数据库操作
    [MagicalRecord cleanUp];
    
    LogInUser *user = [LogInUser getCurrentLoginUser];
    if (user) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = user.newfriendbadge.integerValue+user.homemessagebadge.integerValue+[user allUnReadChatMessageNum];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//    return [[ShareEngine sharedShareEngine] handleOpenURL:url];
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
//    return [[ShareEngine sharedShareEngine] handleOpenURL:url];
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
             if (resultStatus == 9000) {
                 //支付成功
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipayPaySuccess" object:nil];
             }else{
                 if ([resultDic[@"memo"] length] > 0) {
                     [UIAlertView showWithTitle:@"系统提示" message:resultDic[@"memo"]];
                 }
             }
             DLog(@"支付结果 result = %@", resultDic);
         }];
        return YES;
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
            if (resultStatus == 9000) {
                //支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipayPaySuccess" object:nil];
            }else{
                if ([resultDic[@"memo"] length] > 0) {
                    [UIAlertView showWithTitle:@"系统提示" message:resultDic[@"memo"]];
                }
            }
            DLog(@"支付结果 result = %@", resultDic);
        }];
        return YES;
    }
    
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;
    _clientId = clientId;
    [UserDefaults setObject:clientId forKey:BPushRequestChannelIdKey];
    [WLHttpTool updateClientSuccess:^(id JSON) {
        
    } fail:^(NSError *error) {
        
    }];
    //    [self stopSdk];
}

- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息
    _payloadId = payloadId;
    
    NSData *payload = [_gexinPusher retrivePayloadById:payloadId];
    NSDictionary *payloadDic = [NSJSONSerialization JSONObjectWithData:payload options:0 error:nil];
    [self inceptMessage:payloadDic];
    DLog(@"-----------个推消息--------%@    \n%d",payloadDic,++_lastPayloadIndex);
}

- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
//    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
}

- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    DLog(@"%@",[NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]);

}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 清除内存中的图片缓存
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
}

//获取聊天消息记录 和好友请求消息
- (void)getServiceChatMsgInfo
{
    LogInUser *loginUser = [LogInUser getCurrentLoginUser];
    if (loginUser) {
        NSString *localMaxChatNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"MaxChatMessageId"];
        NSString *maxChatNum = localMaxChatNum.length > 0 ? localMaxChatNum : @"0";
        [WLHttpTool getServiceMessagesParameterDic:@{@"type":@(0),@"topid":maxChatNum}//0 聊天消息，1 好友请求
                                           success:^(id JSON) {
                                               if ([JSON count] > 0) {
                                                   for(NSDictionary *chatDic in JSON){
                                                       NSNumber *toUser = chatDic[@"uid"];
                                                       LogInUser *loginUser = [LogInUser getLogInUserWithUid:toUser];
                                                       //如果本地数据库没有当前登陆用户，不处理
                                                       if (loginUser == nil) {
                                                           return;
                                                       }
                                                       
                                                       [self getIMGTMessage:chatDic];
                                                   }
                                               }
                                               
                                               NSString *maxChatNum = [ChatMessage getMaxChatMessageId];
                                               [[NSUserDefaults standardUserDefaults] setObject:maxChatNum forKey:@"MaxChatMessageId"];
                                           } fail:^(NSError *error) {
                                               DLog(@"service chatMsg error:%@",error.description);
                                           }];
        
        //好友请求消息
        /*
         created = "2015-03-19 00:09:41";
         fromuser =     {
             avatar = "http://img.welian.com/1426666616205-200-200_x.jpg";
             name = "\U6d4b\U8bd517912";
             uid = 17912;
         };
         messageid = 95395;
         msg = "\U6211\U662f\U667a\U534e\U56fd\U9645\U63a7\U80a1\U96c6\U56e2\U6709\U9650\U516c\U53f8\U7684\U521b\U59cb\U5408\U4f19\U4eba\Uff0c\U60a8\U597d";
         type = friendRequest;
         uid = 10019;
         */
        NSString *localMaxNewFriendId = [[NSUserDefaults standardUserDefaults] objectForKey:@"MaxNewFriendId"];
        NSString *maxNewFriendId = localMaxNewFriendId.length > 0 ? localMaxNewFriendId : @"0";
        [WLHttpTool getServiceMessagesParameterDic:@{@"type":@(1),@"topid":maxNewFriendId}//0 聊天消息，1 好友请求
                                           success:^(id JSON) {
                                               if ([JSON count] > 0) {
                                                   for(NSDictionary *newFriendDic in JSON){
                                                       NSMutableDictionary *dictData = [NSMutableDictionary dictionaryWithDictionary:newFriendDic];
                                                       
                                                       NSNumber *toUser = dictData[@"uid"];
                                                       LogInUser *loginUser = [LogInUser getLogInUserWithUid:toUser];
                                                       //如果本地数据库没有当前登陆用户，不处理
                                                       if (loginUser == nil) {
                                                           return;
                                                       }
                                                       
                                                       //设置请求方式
                                                       [dictData setObject:@"friendRequest" forKey:@"type"];
                                                       //设置用户信息
                                                       NSDictionary *userDict = dictData[@"fromuser"];
                                                       [dictData setObject:userDict[@"uid"] forKey:@"uid"];
                                                       [dictData setObject:userDict[@"name"] forKey:@"name"];
                                                       [dictData setObject:userDict[@"avatar"] forKey:@"avatar"];
                                                       
                                                       //别人请求的
                                                       [self getNewFriendMessage:dictData LoginUserId:toUser];
                                                   }
                                               }
                                               
                                               //保存最新的最大id
                                               NSString *maxNewFriendId = [loginUser getMaxNewFriendUserMessageId];
                                               [[NSUserDefaults standardUserDefaults] setObject:maxNewFriendId forKey:@"MaxNewFriendId"];
                                           } fail:^(NSError *error) {
                                               DLog(@"service friendMsg error:%@",error.description);
                                           }];
    }
}

@end
