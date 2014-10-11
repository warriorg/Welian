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
#define WLHttpServer  @"http://122.226.44.105:8080"

#define ww @"http://192.168.1.191:80"

// 百度地图key
#define KBMK_Key @"cbtkHchgOfETh6dZdWi1rytI"


// 文件路径
#define kFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"userInfo.data"]


#define SuperSize self.view.bounds.size
#define INPUT_HEIGHT 64.0f


#define KTableHeaderHeight 15.0
#define KTableRowH 47.0

#define KAddressBook @"AddressBok"

#define UserDefaults [NSUserDefaults standardUserDefaults]

#define UserIconImage @"UserIconImage"

//当前系统版本
#define isIOS6 [[UIDevice currentDevice].systemVersion intValue]==6?1:0

// 主色透明效果
#define KBasesColor [UIColor colorWithRed:8/255.0 green:61/255.0 blue:84/255.0 alpha:0.8]


// 2.获得RGB颜色
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 3.全局背景色
#define IWGlobalBg IWColor(226, 226, 226)


/*
 6.一条微博上的颜色
 */
// 昵称
#define IWNameColor IWColor(88, 88, 88)
// 会员昵称颜色
#define IWMBNameColor IWColor(244, 103, 8)
// 时间
#define IWTimeColor IWColor(200, 200, 200)
// 内容
#define IWContentColor IWColor(52, 52, 52)
// 来源
#define IWSourceColor IWColor(153, 153, 153)
// 被转发昵称
#define IWRetweetNameColor IWColor(81, 126, 175)
// 被转发内容
#define IWRetweetContentColor IWColor(109, 109, 109)
// 线条浅灰颜色
#define WLLineColor IWColor(232, 234, 239)

/*
 7.一条微博上的字体
 */
// 昵称
#define IWNameFont [UIFont boldSystemFontOfSize:15]
// 时间
#define IWTimeFont [UIFont systemFontOfSize:12]
// 来源
//#define IWSourceFont IWTimeFont
// 内容
#define IWContentFont [UIFont systemFontOfSize:15]
// 转发的昵称
#define IWRetweetNameFont [UIFont systemFontOfSize:15]
// 转发的内容
#define IWRetweetContentFont IWRetweetNameFont


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
#define IWPhotoWH 87

// 微博工具条的高度
#define IWStatusDockH 40

// 认证图标的尺寸
#define IWVertifyWH 18

// 头像图片的尺寸
#define IWIconWHDefault 50
#define IWIconWHSmall 34
#define IWIconWHBig 85


#endif
