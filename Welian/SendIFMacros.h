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

#ifndef SendIFMacros_h
#define SendIFMacros_h


//iphone5适配
// 1.判断是否为iPhone5的宏
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)


//#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

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
// 服务器地址
#define WLHttpServer  @"http://test.welian.com:8080"

#define ww @"http://122.226.44.105:8080  http://test.welian.com:8080   http://www.welian.com:8080"

// 百度地图key
#define KBMK_Key @"cbtkHchgOfETh6dZdWi1rytI"
// 友盟Appkey
#define UMENG_APPKEY @"545c8c97fd98c59807006c67"

#define KupdataMyAllFriends @"KupdataMyAllFriends"

// 首页动态更新个数通知
#define KNEWStustUpdate  @"KNEWStustUpdate"

// 首页消息通知
#define KMessageHomeNotif @"KMessageHomeNotif"

#define KMessagebadge @"KMessagebadge"

#define KFriendbadge @"KFriendbadge"

#define KNewFriendNotif @"KNewFriendNotif"

#define KPublishOK @"PublishStatusOK"

#define KLogoutNotif @"KLogoutNotif"


#define KWLDataDBName @"wlDataDBName.db"

#define KMyAllFriendsKey [NSString stringWithFormat:@"allfriend%@",[[UserInfoTool sharedUserInfoTool] getUserInfoModel].uid]

#define KNewFriendsTableName [NSString stringWithFormat:@"newfriend%@",[[UserInfoTool sharedUserInfoTool] getUserInfoModel].uid]

#define KHomeDataTableName [NSString stringWithFormat:@"home%@",[[UserInfoTool sharedUserInfoTool] getUserInfoModel].uid]

#define KMessageHomeTableName [NSString stringWithFormat:@"messageHome%@",[[UserInfoTool sharedUserInfoTool] getUserInfoModel].uid]

#define KWLStutarDataTableName [NSString stringWithFormat:@"stutarData%@",[[UserInfoTool sharedUserInfoTool] getUserInfoModel].uid]


// 文件路径
#define kFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"userInfo.data"]


#define SuperSize self.view.bounds.size
#define INPUT_HEIGHT 44.0f


#define KTableHeaderHeight 15.0
#define KTableRowH 47.0

#define KAddressBook @"AddressBok"

#define UserDefaults [NSUserDefaults standardUserDefaults]

#define UserIconImage @"UserIconImage"

// 第一条微博fid
#define KFirstFID @"firstFid"

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


// 返回结果的键
#define BPushRequestChannelIdKey   @"channel_id"


#endif
