//
//  WLHUDView.h
//  Welian
//
//  Created by dong on 14-9-22.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MBProgressHUD;

@interface WLHUDView : NSObject

+(UIWindow*)window;

+ (void)showSuccessHUD:(NSString *)labeltext;
+ (void)showErrorHUD:(NSString *)labeltext;

+ (void)showCustomHUD:(NSString *)labeltext imageview:(NSString *)imageName;

+ (MBProgressHUD*)showHUDWithStr:(NSString*)title dim:(BOOL)dim;
// 
+ (void)hiddenHud;
@end
