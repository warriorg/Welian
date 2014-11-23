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
//#import "LogInController.h"
#import "NavViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ShareEngine.h"
#import "WLTool.h"
#import "LoginViewController.h"
#import "NewFriendModel.h"
#import "MJExtension.h"
#import "WLDataDBTool.h"
#import "MobClick.h"
#import "MessageHomeModel.h"
#import "AFNetworkActivityIndicatorManager.h"

// production
#define kAppId           @"CgF0UHbnv0827eFprsyYT9"
#define kAppKey          @"eAJBPqawMhAi406E0FcSh3"
#define kAppSecret       @"rOSsO1iPvj6H39gltxdDJ6"

@interface AppDelegate() <BMKGeneralDelegate,UITabBarControllerDelegate>
{
    NSString *_upURL;
    MainViewController *mainVC;
}
@end

@implementation AppDelegate

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


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /**
     *  设置状态栏颜色
     */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    if (mode.sessionid&&mode.mobile&&mode.checkcode) {
        
        /** 已登陆 */
        mainVC = [[MainViewController alloc] init];
        [mainVC setDelegate:self];
        [self.window setRootViewController:mainVC];

    }else{
        /** 未登陆 */
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        NavViewController *nav = [[NavViewController alloc] initWithRootViewController:loginVC];
        [self.window setRootViewController:nav];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DLog(@"====沙盒路径=======%@",paths);
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    
    // [2]:注册APNS
    [self registerRemoteNotification];
    
    // [2-EXT]: 获取启动时收到的APN
//    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (message) {
//        NSString *payloadMsg = [message objectForKey:@"payload"];
//        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
//    }
    
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 版本更新
    [self detectionUpdataVersionDic];
    return YES;
}


#pragma mark - 检测版本更新
- (void)detectionUpdataVersionDic
{
    [WLTool updateVersions:^(NSDictionary *versionDic) {
        if ([[versionDic objectForKey:@"flag"] integerValue]==1) {
            NSString *msg = [versionDic objectForKey:@"msg"];
            _upURL = [versionDic objectForKey:@"url"];
            
            [[[UIAlertView alloc] initWithTitle:@"更新提示" message:msg  delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"立即更新", nil] show];
        }else{
        }
    }];
}

#pragma mark - 版本更新跳转
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_upURL]];
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
                                         appVersion:@"0.0.0"
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
    
    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:@"www.welian.com"];
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
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[userInfo objectForKey:@"data"]];
    [dataDic setObject:type forKey:@"type"];
    
    if ([type isEqualToString:@"feedZan"]||[type isEqualToString:@"feedComment"]||[type isEqualToString:@"feedForward"]) {     // 动态消息推送

        [[WLDataDBTool sharedService] putObject:dataDic withId:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"commentid"]] intoTable:KMessageHomeTableName];
        NSInteger badge = [[UserDefaults objectForKey:KMessagebadge] integerValue];
        badge++;
        [UserDefaults setObject:[NSString stringWithFormat:@"%d",badge] forKey:KMessagebadge];
        [[NSNotificationCenter defaultCenter] postNotificationName:KMessageHomeNotif object:self];
        
    }else if([type isEqualToString:@"friendRequest"]||[type isEqualToString:@"friendAdd"]||[type isEqualToString:@"friendCommand"]){   // 好友消息推送
        NewFriendModel *newfrendM = [NewFriendModel objectWithKeyValues:dataDic];
        if ([type isEqualToString:@"friendAdd"]) {
            [newfrendM setIsAgree:@"1"];
            [[NSNotificationCenter defaultCenter] postNotificationName:KupdataMyAllFriends object:self];
        }else{
            
            NSInteger badge = [[UserDefaults objectForKey:KFriendbadge] integerValue];
            badge++;
            [UserDefaults setObject:[NSString stringWithFormat:@"%d",badge] forKey:KFriendbadge];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KNewFriendNotif object:self];
        }
        
        [[WLDataDBTool sharedService] putObject:[newfrendM keyValues] withId:[NSString stringWithFormat:@"%@",newfrendM.uid] intoTable:KNewFriendsTableName];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    DLog(@"应用程序将要进入非活动状态，即将进入后台");
    if (!([UserDefaults objectForKey:KFriendbadge]||[UserDefaults objectForKey:KMessagebadge])) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    if (!([UserDefaults objectForKey:KFriendbadge]||[UserDefaults objectForKey:KMessagebadge])) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[ShareEngine sharedShareEngine] handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[ShareEngine sharedShareEngine] handleOpenURL:url];
}

#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    _sdkStatus = SdkStatusStarted;
    _clientId = clientId;
    [UserDefaults setObject:clientId forKey:BPushRequestChannelIdKey];
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


@end
