//
//  WLHUDView.m
//  Welian
//
//  Created by dong on 14-9-22.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLHUDView.h"
#import "MBProgressHUD.h"

#define Kerror     @"error"
#define Ksuccess   @"success"

@interface WLHUDView ()
@end

@implementation WLHUDView

+(UIWindow*)window
{
    
    return [UIApplication sharedApplication].keyWindow;
}

MBProgressHUD *HUD;


+ (void)showSuccessHUD:(NSString *)labeltext
{
    [self showCustomHUD:labeltext imageview:Ksuccess];
    [HUD hide:YES afterDelay:2];
}

+ (void)showErrorHUD:(NSString *)labeltext
{
    [self showCustomHUD:labeltext imageview:Kerror];
    [HUD hide:YES afterDelay:2];
}

+ (void)showCustomHUD:(NSString *)labeltext imageview:(NSString *)imageName
{
    [self showHUDWithStr:labeltext dim:NO];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    HUD.mode = MBProgressHUDModeCustomView;
}


+ (MBProgressHUD*)showHUDWithStr:(NSString*)title dim:(BOOL)dim
{
    [self hiddenHud];
    HUD = [MBProgressHUD showHUDAddedTo:[self window] animated:YES];
    [HUD setUserInteractionEnabled:dim];
    [HUD setDimBackground:dim];
    [HUD setLabelText:title];
    return HUD;
}

+ (void)hiddenHud
{
    [MBProgressHUD hideHUDForView:[self window] animated:NO];
}

@end
