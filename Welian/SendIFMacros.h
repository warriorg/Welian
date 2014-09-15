//
//  SendIFMacros.h
//  TravelHeNan
//
//  Created by Apple on 13-12-11.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef SendIFMacros_h
#define SendIFMacros_h


//iphone5适配
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

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

#define UserDefaults [NSUserDefaults standardUserDefaults]

#define UserIconImage @"UserIconImage"

//当前系统版本
#define isIOS6 [[UIDevice currentDevice].systemVersion intValue]==6?1:0

// 主色透明效果
#define KBasesColor [UIColor colorWithRed:8/255.0 green:61/255.0 blue:84/255.0 alpha:0.8]

//切换内外网，0表示内网，1表示外网
#ifndef SERVER_TYPE
#define SERVER_TYPE 1
#endif

//测试服务器
#if SERVER_TYPE == 0
static NSString *const SendIFServer = @"http://192.168.0.193:8080";
//static NSString *const SendIFServer = @"http://192.168.0.5:8386";

//正式服务器
#elif SERVER_TYPE == 1
static NSString *const SendIFServer = @"http://115.236.71.155:18386";
#endif


#endif
