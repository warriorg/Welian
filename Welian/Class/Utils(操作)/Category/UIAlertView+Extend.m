//
//  UIAlertView+Extend.m
//  The Dragon
//
//  Created by yangxh on 12-7-17.
//  Copyright (c) 2012年 杭州引力网络技术有限公司. All rights reserved.
//

#import "UIAlertView+Extend.h"

@implementation UIAlertView (Extend)

+ (void)showWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"信息提示"
                               message:[error localizedDescription]
                              delegate:nil
                     cancelButtonTitle:@"确定"
                     otherButtonTitles:nil] show];
}

+ (void)showWithMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:message
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil] show];
}

+ (void)showWithTitle:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil] show];
}

@end
