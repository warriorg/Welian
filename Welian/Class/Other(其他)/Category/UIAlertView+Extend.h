//
//  UIAlertView+Extend.h
//  The Dragon
//
//  Created by yangxh on 12-7-17.
//  Copyright (c) 2012年 杭州引力网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CSAlert1(MSG) [UIAlertView showWithMessage:MSG]
#define CSAlert2(TITLE,MSG) [UIAlertView showWithTitle:TITLE message:MSG]
#define CSAlert3(ERROR) [UIAlertView showWithError:ERROR]

@interface UIAlertView (Extend)

+ (void)showWithError:(NSError *)error;
+ (void)showWithMessage:(NSString *)message;
+ (void)showWithTitle:(NSString *)title message:(NSString *)message;

@end
