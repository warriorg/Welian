//
//  ShareEngine.m
//  weLian
//
//  Created by dong on 14-10-15.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "ShareEngine.h"
#import "UIImage+ImageEffects.h"

@implementation ShareEngine
single_implementation(ShareEngine)

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

/**
 * @description 存储内容读取
 */
- (void)registerApp
{
    //向微信注册
    [WXApi registerApp:kWeChatAppId];
    DLog(@"%@",kWeChatAppId);
}

- (NSUInteger)getBytesLengthWithSring:(NSString *)str{
    NSUInteger len = 0;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    len = [str lengthOfBytesUsingEncoding:enc];
    
    return len;
}

- (void)sendWeChatMessage:(NSString*)message andDescription:(NSString *)descriptStr WithUrl:(NSString*)appUrl andImage:(UIImage *)thumbImage WithScene:(WeiboType)weiboType;
{
    if (!([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi])) {
        [WLHUDView showErrorHUD:@"微信未安装！"];
        return;
    }
    UIImage *scaledImage = [thumbImage scaleFromImage:thumbImage scaledToSize:CGSizeMake(180, 180)];
    
    NSData * imageData = UIImageJPEGRepresentation(scaledImage,1);
    NSInteger length = [imageData length]/1024;
    if (length>30) {
        NSData *thum = UIImageJPEGRepresentation(scaledImage, 30/length);
        scaledImage = [UIImage imageWithData:thum];
    }
    NSInteger meLength = message.length;
    if (meLength>50) {
        message = [message substringWithRange:NSMakeRange(0, 50)];
    }
    NSInteger desLength = descriptStr.length;
    if (desLength>50) {
        descriptStr = [descriptStr substringWithRange:NSMakeRange(0, 50)];
    }
//    NSUInteger titlength =[self getBytesLengthWithSring:message];
//    NSUInteger desclength = [self getBytesLengthWithSring:descriptStr];
//    NSUInteger appUrllength = [self getBytesLengthWithSring:appUrl];
    
    if(weChat == weiboType)
    {
        [self sendAppContentWithMessage:message andDescription:descriptStr WithUrl:appUrl andImage:scaledImage WithScene:WXSceneSession];
        return;
    } else if(weChatFriend == weiboType)
    {
        [self sendAppContentWithMessage:message andDescription:descriptStr WithUrl:appUrl andImage:scaledImage WithScene:WXSceneTimeline];
        return;
    }
}

#pragma mark - wechat delegate
- (void)weChatPostStatus:(NSString*)message
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void)weChatFriendPostStatus:(NSString*)message
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

- (void)sendAppContentWithMessage:(NSString*)appMessage andDescription:(NSString *)descriptStr WithUrl:(NSString*)appUrl andImage:(UIImage *)thumbImage WithScene:(int)scene
{
    // 发送内容给微信
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = appMessage;
    
    if (descriptStr) {
        message.description = descriptStr;
    }
    if (thumbImage) {
        
        message.thumbData = UIImageJPEGRepresentation(thumbImage, 1);
    }
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = appUrl;
    if (!appUrl) {
        DLog(@"分享的链接地址为空，无法分享！");
    }
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}


-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (0 == resp.errCode)
        {
            [WLHUDView showSuccessHUD:@"分享成功！"];
        }else if (-2 == resp.errCode){
            [WLHUDView showErrorHUD:@"取消分享"];
        }else
        {
            [WLHUDView showErrorHUD:resp.errStr];
        }
    }

}

-(void) onShowMediaMessage:(WXMediaMessage *) message
{
//     微信启动， 有消息内容。
        WXAppExtendObject *obj = message.mediaObject;
        NSString *strTitle = [NSString stringWithFormat:@"消息来自微信"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", message.title, message.description, obj.extInfo, message.thumbData.length];
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
}

-(void) onRequestAppMessage
{
    // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
}

-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        [self onRequestAppMessage];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        [self onShowMediaMessage:temp.message];
    }
    
}


@end
