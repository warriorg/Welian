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
#import "LogInController.h"
#import "NavViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ShareEngine.h"
#import "BPush.h"
#import "JSONKit.h"
#import "OpenUDID.h"
#import "WLTool.h"
#import "LoginViewController.h"
#import "NewFriendModel.h"
#import "MJExtension.h"
#import "WLDataDBTool.h"
#import "MobClick.h"

#define SUPPORT_IOS8 1

@interface AppDelegate() <BMKGeneralDelegate,UITabBarControllerDelegate>
{
    NSString *_upURL;
    MainViewController *mainVC;
}
@end

@implementation AppDelegate

BMKMapManager* _mapManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 百度推送
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    
    // 友盟统计
    [self umengTrack];
    NSString *localVersion =[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    if ([localVersion isEqualToString:@"1.0.1"]) {
        [[WLDataDBTool sharedService] createTableWithName:KNewFriendsTableName];
    }
    
#if SUPPORT_IOS8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else
#endif
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }

    // 要使用百度地图，请先启动BaiduMapManager
	_mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [_mapManager start:KBMK_Key generalDelegate:self];
	if (!ret) {
        
	}
    
    // 添加微信分享
    [[ShareEngine sharedShareEngine] registerApp];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    /**
     *  设置状态栏颜色
     */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    if (mode.sessionid&&mode.mobile&&mode.checkcode) {
        
        /**
         *  已登陆
         */
        mainVC = [[MainViewController alloc] init];
        [mainVC setDelegate:self];
        [self.window setRootViewController:mainVC];

    }else{
        /**
         *  未登陆
         */
        
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        NavViewController *nav = [[NavViewController alloc] initWithRootViewController:loginVC];
        [self.window setRootViewController:nav];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    DLog(@"====沙盒路径=======%@",paths);
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSDictionary *userInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    
    NSDictionary *apsDict =  [userInfo objectForKey:@"aps"];
    NSString *alert = [apsDict objectForKey:@"alert"];
    if (alert) {
        
        NSString *type = [userInfo objectForKey:@"type"];
        NewFriendModel *newfrendM = [NewFriendModel objectWithKeyValues:userInfo];
        [newfrendM setMessage:alert];
        NSDictionary *newDic = [newfrendM keyValues];
        
        if ([type isEqualToString:@"friendAdd"]) {
            [newfrendM setIsAgree:@"1"];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:KNewFriendNotif object:self];
        }
        
        [[WLDataDBTool sharedService] putObject:newDic withId:[NSString stringWithFormat:@"%@",newfrendM.uid] intoTable:KNewFriendsTableName];
    }
    
    // 版本更新
    [WLTool updateVersions:^(NSDictionary *versionDic) {
        if ([[versionDic objectForKey:@"flag"] integerValue]==1) {
            NSString *msg = [versionDic objectForKey:@"msg"];
            _upURL = [versionDic objectForKey:@"url"];
            
            [[[UIAlertView alloc] initWithTitle:@"更新提示" message:msg  delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"立即更新", nil] show];
        }else{

        }
        
    }];
//    [self loadFriendRequest];
     application.applicationIconBadgeNumber =0;
    return YES;
}

#pragma mark - 友盟统计
- (void)umengTrack {
    
    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:@"www.welian.com"];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
//    [MobClick updateOnlineConfig];  //在线参数配置
//    
//    //    1.6.8之前的初始化方法
//    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}


#pragma mark - 版本更新跳转
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_upURL]];
    }
}

#if SUPPORT_IOS8
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BPush registerDeviceToken: deviceToken];
    if (![UserDefaults objectForKey:BPushRequestUserIdKey]) {
        
        [BPush bindChannel]; // 必须。可以在其它时机调用，只有在该方法返回（通过onMethod:response:回调）绑定成功时，app才能接收到Push消息。一个app绑定成功至少一次即可（如果access token变更请重新绑定）。
    }else{
                DLog(@"百度推送 ----------------加载成功");
    }
}

// 必须，如果正确调用了setDelegate，在bindChannel之后，结果在这个回调中返回。
// 若绑定失败，请进行重新绑定，确保至少绑定成功一次
- (void) onMethod:(NSString*)method response:(NSDictionary*)data
{
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
//        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
//        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        
        if (returnCode == BPushErrorCode_Success) {
            
            // 在内存中备份，以便短时间内进入可以看到这些值，而不需要重新bind
            [UserDefaults setObject:userid forKey:BPushRequestUserIdKey];
            [UserDefaults setObject:channelid forKey:BPushRequestChannelIdKey];
            DLog(@"百度推送 ----------------加载成功");
        }
    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
            
            [UserDefaults removeObjectForKey:BPushRequestChannelIdKey];
            [UserDefaults removeObjectForKey:BPushRequestUserIdKey];

        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *type = [userInfo objectForKey:@"type"];
//    NSString *uid = [userInfo objectForKey:@"uid"];
//    NSString *name = [userInfo objectForKey:@"name"];
//    NSString *avatar = [userInfo objectForKey:@"avatar"];
//    NSString *company = [userInfo objectForKey:@"company"];
//    NSString *position = [userInfo objectForKey:@"position"];
    
    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    
    NewFriendModel *newfrendM = [NewFriendModel objectWithKeyValues:userInfo];
    [newfrendM setMessage:alert];
    NSDictionary *newDic = [newfrendM keyValues];
    if ([type isEqualToString:@"friendAdd"]) {
        [newfrendM setIsAgree:@"1"];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:KNewFriendNotif object:self];
    }
    
    [[WLDataDBTool sharedService] putObject:newDic withId:[NSString stringWithFormat:@"%@",newfrendM.uid] intoTable:KNewFriendsTableName];

    [application setApplicationIconBadgeNumber:0];

    [BPush handleNotification:userInfo];
}




- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        DLog(@"百度地图-------------联网成功");
    }
    else{
        DLog(@"百度地图------------- %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        DLog(@"百度地图-------------授权成功");
    }
    else {
        DLog(@"百度地图------------- %d",iError);
    }
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 清除内存中的图片缓存
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    [mgr cancelAll];
    [mgr.imageCache clearMemory];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    DLog(@"应用程序将要进入非活动状态，即将进入后台");
    }

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLog(@"如果应用程序支持后台运行，则应用程序已经进入后台运行");
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNEWStustUpdate object:self];
    DLog(@"应用程序将要进入活动状态，即将进入前台运行");
    [self loadFriendRequest];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)loadFriendRequest
{
    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    if (!mode.sessionid) return;
    [WLHttpTool loadFriendRequestParameterDic:@{@"page":@(1),@"size":@(1000)} success:^(id JSON) {
        
        NSArray *jsonArray = [NSArray arrayWithArray:JSON];
        for (NSDictionary *dic  in jsonArray) {
            NSString *fid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fid"]];
           YTKKeyValueItem *item = [[WLDataDBTool sharedService] getYTKKeyValueItemById:fid fromTable:KNewFriendsTableName];
            if (![item.itemObject objectForKey:@"isLook"]) {
                NSMutableDictionary *mutablDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [mutablDic setObject:@"friendRequest" forKey:@"type"];
                [mutablDic setObject:fid forKey:@"uid"];
                [[WLDataDBTool sharedService] putObject:mutablDic withId:fid intoTable:KNewFriendsTableName];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:KNewFriendNotif object:self];
            }
        }
        
    } fail:^(NSError *error) {
        
    }];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLog(@"应用程序已进入前台，处于活动状态");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
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
@end
