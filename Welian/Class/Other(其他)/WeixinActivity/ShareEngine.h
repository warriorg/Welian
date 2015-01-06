//
//  ShareEngine.h
//  weLian
//
//  Created by dong on 14-10-15.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "WXApi.h"

typedef enum
{
    sinaWeibo = 1,
    weChat = 2,
    weChatFriend = 3
}WeiboType;

//#define kWeChatAppId        @"wx4150b21797fa0a5e"

@protocol ShareEngineDelegate;

@interface ShareEngine : NSObject <WXApiDelegate>
single_interface(ShareEngine)
@property (nonatomic, assign) id<ShareEngineDelegate> delegate;

- (BOOL)handleOpenURL:(NSURL *)url;

- (void)registerApp;

/**
 *@description 发送微信消息
 *@param message:文本消息 url:分享链接 weibotype:微信消息类型
 */
- (void)sendWeChatMessage:(NSString*)message andDescription:(NSString *)descriptStr WithUrl:(NSString*)appUrl andImage:(UIImage *)thumbImage WithScene:(WeiboType)weiboType;

@end
