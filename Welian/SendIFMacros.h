//
//  SendIFMacros.h
//  TravelHeNan
//
//  Created by Apple on 13-12-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLHttpTool.h"
#import "UserInfoTool.h"
#import "WLHUDView.h"
#import "WLDataDBTool.h"
#import "UIColor+_6jinzhi.h"
#import "LogInUser.h"


#ifndef SendIFMacros_h
#define SendIFMacros_h

/*
//  支付宝配置信息
 //合作身份者id，以2088开头的16位纯数字
 #define PartnerID @"2088111741145515"
 //收款支付宝账号
 #define SellerID  @"zhangqi@codans.com"
 
 //安全校验码（MD5）密钥，以数字和字母组成的32位字符
 #define MD5_KEY @"wvtdlvrab98tots56mv5xx53sjk74y4r"
 
 //商户私钥，自助生成
 #define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBANu86LBhn0iKoFrUOyVOXDEWx0E7dV2y8ShK5QdR3qI3PM60CFOjqGFjs+vdL/nbUTRYW+sQzqY0WD3Bi88mqxVL9Uo9sRIPzmJZ4So2Qoar8IzoxRuN1yZw/Yyd0YdpwWmcUQstVsln2o/FOt8OT2vTVSZOasNvFoucQ/I0xmFfAgMBAAECgYBmdfTOYgbizXkuQS3/HEXSwftRSIdWlJzsm9eljSBR5Y3eGIaVcYePOe1oeu/nAsQfs1/RATpKt7e5vCkUA8TbwRN+RWXQtwucNCmN1nQPz0zPGGdvLWTTs/GOMizWSM+BCHpDiiyWvaxedW4a1C4xjUT3uGW0JAltNtqLo2q4YQJBAPQBlZNMXlwqXhVz1MSMlONxAT/PJcdkCO5NCGfNUlzLvTYf6TKJRs8+T2HlY/rBVTy5ITn5iP191NC76vJFC7ECQQDmifLVgH0CBhY/Kw+6j112D59R0PpiVVEOvO4rJqAdWw5auJNlPAggidqffpgVmVDj193uEiz3iRJW0lr/vFIPAkBsYb/Em6lWGuOLd9XML/16QRmi9Cn9tOtanhDbupGY8k5rGiWE8wDm0PCFtVSBbxqjTD/79mDo59l9ldq4Hf8hAkEA3JyoF+20MsqWYW6Yx6PIAWGjyYyc/pq8Tck4dWyqDk2DqAc3bcoL0O96meRwL0MfKFn704XrKBowxYrZcB7LuwJATGI5nzsu3MKYEN2Z7OkkqI25lPh83QfGEWYKUOItvS1Xq00ZrhX/LPB6vdCIf3bMYV1CL7yMRq50h6ldsxcCFw=="
 
 //把支付宝公钥和RSA私钥配置到代码里面，RSA私钥如果不是php语言签名的，都要用pkcs8转码后再配置到代码里面，php语言签名的直接用rsa_private的pem文件 RSA公钥上传地址：登录b.alipay.com，点我的商家服务，点查询PID和KEY->合作伙伴密钥管理，RSA密钥->查看密钥或者添加密钥
 
 //支付宝商户生成的公钥
 #define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"
*/

//  支付宝配置信息
//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088611088140964"
//收款支付宝账号
#define SellerID  @"wx@welian.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"9ztmliltn7r93e3wz31dee780eme05rj"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALoophIkcpw8SAgNtPCoK7dC3igETE8m227BiFUi7fUQbJMFG+yfnwH/Q0zR+zuKScLjB81EAqwYBjU+d7S+Lr4h+VqixRtUL56jXyL4oK6sg7JO5RdkVjmih+/k5f4NlFTSpPPlv4gqON7NLqnoXUmR5K5M7qfJva8ppNbpzTCZAgMBAAECgYAwWqSga8U1Xdcb+Gt6Y0RPqtfHry4fFSnEQBLoglUq5aQ+IAKb2O5Vd3eEubo3Qflc3NnG8JZ9GxRpuhsf4JKFMRS4OqnRHhZNwLugpTCrt6XnukDS69bsmH2li6zXkJ9SHJLhQzkqpZ7gSTd7nkxFy39bmsMqzjK1nNqPR/FhnQJBAOI8yt6wS3DhBmk5leMKKvMMNm1lzd6LLr2vV6RiwEVzlrtli/9VLeRiHP5YUYHTIqN/qGQIyT0O7prFNJtx1LMCQQDSphblXFp4C9dbrUCtM3zRKHN40jTsy0L3VvpAv1i1a/gQ041ni10xh3IOuWYS5bR2OEg2bLnR8S4TKho+08ODAkBnXk9zICnYEXjUazNI4URueI4FvhYqMH3SvWLWASjIkt+0D9m/eDPXvdxxefkD0GxrN9DApCMOetwaazB2NbRxAkB+urWjn4A+IMGbwgvbJ9K78t4lnjGBFHhhXc6JDZVM8Hv5g4za8plKpvYTra6fR9reFNY9CARzLepOVVIc4kIJAkEAltBchwK3mueIOOWW2SN3CMk5NnB/2jzaLNZtAJd9P9wu63dyPETYTmH1OiUMbtdy93Fe7kSPi90AMz1yyxYqfg=="

//把支付宝公钥和RSA私钥配置到代码里面，RSA私钥如果不是php语言签名的，都要用pkcs8转码后再配置到代码里面，php语言签名的直接用rsa_private的pem文件 RSA公钥上传地址：登录b.alipay.com，点我的商家服务，点查询PID和KEY->合作伙伴密钥管理，RSA密钥->查看密钥或者添加密钥
//支付宝商户生成的公钥
#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"


//iphone5适配
// 1.判断是否为iPhone5的宏
#define Iphone5Size [[UIScreen mainScreen] bounds].size
//检测iphone5(bool)
#define Iphone5 (Iphone5Size.height==568)
//检测iphone6(bool)
#define Iphone6 (Iphone5Size.height==667)
//检测iphone6p(bool)
#define Iphone6plus (Iphone5Size.height==736)

#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)

//输出详细log,显示方法及所在的行数
// 2.日志输出宏定义
#ifdef DEBUG
// 调试状态
#define DLog(format, ...) do {                                              \
fprintf(stderr, ">------------------------------\n<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-----------------------------------\n");                                               \
} while (0)
#else
// 发布状态
#define DLog(...)
#endif

// 配置文件

#define KNSNotification   [NSNotificationCenter defaultCenter]

#define KINFODic(key) [[[NSBundle mainBundle] infoDictionary] objectForKey:key]

#define XcodeAppVersion KINFODic(@"CFBundleShortVersionString")
//本地数据存储
#define SaveLoginMobile(mobile) [NSUserDefaults setString:mobile forKey:@"kLastLoginMobile"]
#define lastLoginMobile [NSUserDefaults stringForKey:@"kLastLoginMobile"]

#define SaveLoginPassWD(pass) [NSUserDefaults setString:pass forKey:@"kLastLoginPassWord"]
#define lastLoginPassWD [NSUserDefaults stringForKey:@"kLastLoginPassWord"]

// 百度地图key
#define KBMK_Key                 KINFODic(@"KBMK_Key")

// 微信appid
#define kWeChatAppId             KINFODic(@"KWeChatAppId")
#define KWeChatAppSecret         KINFODic(@"KWeChatAppSecret")
//
//
// ShareSDK
#define KShareSDKAppKey         KINFODic(@"ShareSDKAppKey")

// 友盟Appkey
#define UMENG_APPKEY             KINFODic(@"UMENG_APPKEY")
#define UMENG_ChannelId          KINFODic(@"UMENG_ChannelId")

// 个推appid
#define KGTAppId                 KINFODic (@"KGTAppId")
#define KGTAppKey                KINFODic (@"KGTAppKey")
#define kGTAppSecret             KINFODic (@"KGTAppSecret")
#define KPlatformType            KINFODic (@"KPlatformType")


// 服务器地址
//测试环境
#define WLHttpServer  @"http://test.welian.com:8080"
//本地调试
//#define WLHttpServer  @"http://192.168.1.122:80"
//正式环境
//#define WLHttpServer  @"http://www.welian.com:8080"


#define KupdataMyAllFriends @"KupdataMyAllFriends"

// 首页动态有 更新通知
#define KNEWStustUpdate  @"KNEWStustUpdate"

// 首页动态更新个数
//#define KNewStaustbadge @"KNewStaustbadge"

// 首页消息通知
#define KMessageHomeNotif @"KMessageHomeNotif"

// 新活动的通知
#define KNewactivitNotif  @"KNewactivitNotif"

// 投资人状态通知
#define KInvestorstateNotif @"KInvestorstateNotif"

// 首页消息提示个数
//#define KMessagebadge @"KMessagebadge"

// 好友页新好友提示个数
//#define KFriendbadge @"KFriendbadge"

// 新好友通知
#define KNewFriendNotif @"KNewFriendNotif"
// 发布动态成功
#define KPublishOK @"PublishStatusOK"
// 退出登录通知
#define KLogoutNotif @"KLogoutNotif"


#define KWLDataDBName @"wlDataDBName.db"

// 首页数据
#define KHomeDataTableName [NSString stringWithFormat:@"home%@",[LogInUser getCurrentLoginUser].uid]
// 所有动态数据
#define KWLStutarDataTableName [NSString stringWithFormat:@"stutarData%@",[LogInUser getCurrentLoginUser].uid]
// 所有用户详细信息
#define KWLUserInfoTableName [NSString stringWithFormat:@"UserInfo%@",[LogInUser getCurrentLoginUser].uid]
// 用户共同好友
#define KWLSamefriendsTableName [NSString stringWithFormat:@"Samefriends%@",[LogInUser getCurrentLoginUser].uid] 

// 投资领域数据 行业
#define KInvestIndustryTableName @"InvestIndustry"

// 文件路径
#define kFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"userInfo.data"]


#define SuperSize self.view.bounds.size
#define INPUT_HEIGHT 44.0f


#define KTableHeaderHeight 15.0
#define KTableRowH 47.0

#define KAddressBook @"AddressBok"


// 第一条微博fid
//#define KFirstFID @"firstFid"

// 主色透明效果
#define KBasesColor [UIColor colorWithRed:43/255.0 green:94/255.0 blue:171/255.0 alpha:0.98]

/**
 *  系统字体
 *
 *  @param X 字号
 *
 *  @return 返回字体对象
 */
#define WLFONT(X)                 [UIFont systemFontOfSize:X]

/**
 *  系统加粗字体
 *
 *  @param X 字号
 *
 *  @return 返回字体对象
 */
#define WLFONTBLOD(X)             [UIFont boldSystemFontOfSize:X]

/**
 *  系统颜色
 *
 *  @param r
 *  @param g
 *  @param b
 *  @param a
 *
 *  @return 系统颜色
 */
#define WLRGBA(r, g, b, a)        [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

/**
 *  系统颜色
 *
 *  @param r
 *  @param g
 *  @param b
 *
 *  @return
 */
#define WLRGB(r, g, b)       WLRGBA(r, g, b, 1)

// 3.全局背景色
#define IWGlobalBg WLRGB(246, 246, 246)

// 线条浅灰颜色
#define WLLineColor WLRGB(232, 234, 239)

/*
 7.一条微博上的字体
 */
// 昵称
#define IWNameFont [UIFont boldSystemFontOfSize:16]
// 时间
#define IWTimeFont [UIFont systemFontOfSize:12]
// 内容
#define IWContentFont [UIFont systemFontOfSize:16]

// 转发的昵称
#define IWRetweetNameFont [UIFont systemFontOfSize:16]
// 转发的内容
#define IWRetweetContentFont IWContentFont
// 赞，转发姓名
#define WLZanNameFont [UIFont systemFontOfSize:14]


// 每次加载cell的个数
#define KCellConut 15

/**
 8.常用的一些距离
 */
// cell的边框宽度（cell的内边距）
#define IWCellBorderWidth 10
// tableview的边框宽度（tableView的内边距）
#define IWTableBorderWidth 10
// 每个cell之间的间距
#define IWCellMargin 5
// 图片的最大个数
#define IWPhotoMaxCount 9
// 每张图片之间的间距
#define IWPhotoMargin 8

// 关系图标的宽度
#define WLFriendW 42
#define WLFriendsFriend 65

// 每张图片的尺寸
#define IWPhotoWH 70

// 微博工具条的高度
#define IWStatusDockH 35

// 认证图标的尺寸
#define IWVertifyWH 18

// 头像图片的尺寸
#define IWIconWHSmall 40

//每个controller 中第一个控件距离顶部的高度
#define kFirstMarginTop 20


// 返回结果的键
#define BPushRequestChannelIdKey   @"channel_id"



/////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Redefine

#define ApplicationDelegate                 ((BubblyAppDelegate *)[[UIApplication sharedApplication] delegate])
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define SelfNavBar                          self.navigationController.navigationBar
#define SelfTabBar                          self.tabBarController.tabBar
#define SelfNavBarHeight                    self.navigationController.navigationBar.bounds.size.height
#define SelfTabBarHeight                    self.tabBarController.tabBar.bounds.size.height
#define ScreenRect                          [[UIScreen mainScreen] bounds]
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define TouchHeightDefault                  44
#define TouchHeightSmall                    32
#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y
#define SelfViewHeight                      self.view.bounds.size.height
#define RectX(f)                            f.origin.x
#define RectY(f)                            f.origin.y
#define RectWidth(f)                        f.size.width
#define RectHeight(f)                       f.size.height
#define RectSetWidth(f, w)                  CGRectMake(RectX(f), RectY(f), w, RectHeight(f))
#define RectSetHeight(f, h)                 CGRectMake(RectX(f), RectY(f), RectWidth(f), h)
#define RectSetX(f, x)                      CGRectMake(x, RectY(f), RectWidth(f), RectHeight(f))
#define RectSetY(f, y)                      CGRectMake(RectX(f), y, RectWidth(f), RectHeight(f))
#define RectSetSize(f, w, h)                CGRectMake(RectX(f), RectY(f), w, h)
#define RectSetOrigin(f, x, y)              CGRectMake(x, y, RectWidth(f), RectHeight(f))
#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define DATE_COMPONENTS                     NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
#define TIME_COMPONENTS                     NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
#define FlushPool(p)                        [p drain]; p = [[NSAutoreleasePool alloc] init]
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define SelfDefaultToolbarHeight            self.navigationController.navigationBar.frame.size.height
#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define IsiOS7Later                         !(IOSVersion < 7.0)
#define IsiOS8Later                         (IOSVersion >= 8.0)

#define Size(w, h)                          CGSizeMake(w, h)
#define Point(x, y)                         CGPointMake(x, y)


#define TabBarHeight                        49.0f
#define NaviBarHeight                       44.0f
#define StatusBarHeight                     [UIApplication sharedApplication].statusBarFrame.size.height
#define ButtonHeight                        44.0f
#define TextFieldHeight                     44.0f
#define HeightFor4InchScreen                568.0f
#define HeightFor3p5InchScreen              480.0f

#define ViewCtrlTopBarHeight                (IsiOS7Later ? (NaviBarHeight + StatusBarHeight) : NaviBarHeight)
#define IsUseIOS7SystemSwipeGoBack          (IsiOS7Later ? YES : NO)


// block self
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

// device verson float value
#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// iPad
#define kIsiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// image STRETCH
#define WL_STRETCH_IMAGE(image, edgeInsets) (CURRENT_SYS_VERSION < 6.0 ? [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:edgeInsets.top] : [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch])

#endif
