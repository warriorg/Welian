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

#ifndef SendIFMacros_h
#define SendIFMacros_h


//iphone5适配
// 1.判断是否为iPhone5的宏
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)

#define iPhone6 ([UIScreen mainScreen].bounds.size.height == 480)

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
#define WLHttpServer  @"http://192.168.118.14:80"

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

#endif
