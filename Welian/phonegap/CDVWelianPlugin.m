//
//  CDVWelianPlugin.m
//  CordovaTests
//
//  Created by weLian on 14/12/18.
//
//

#import "CDVWelianPlugin.h"
#import "MJExtension.h"
#import "ActivityViewController.h"

@implementation CDVWelianPlugin



//页面预加载成功
- (void)pageOnComplete:(CDVInvokedUrlCommand *)command
{
    DLog(@"pageOnComplete : %@",command.arguments);
    //预加载结束隐藏头部和加载条
    ActivityViewController *activityVC = (ActivityViewController *)self.viewController;
    [activityVC hideHeader];
}

//返回sessionId
- (void)getSessionId:(CDVInvokedUrlCommand *)command
{
    DLog(@"getSessionId : %@",command.arguments);
    NSString *sessionId = [LogInUser getNowLogInUser].sessionid;
    [self send:command backInfo:sessionId];
}

//返回头部高度
- (void)getHeadHeight:(CDVInvokedUrlCommand *)command
{
    DLog(@"getHeadHeight : %@",command.arguments);
    [self send:command backInfo:@"64"];
}

//分享
- (void)share:(CDVInvokedUrlCommand *)command
{
    // 这是classid,在下面的PluginResult进行数据的返回时,将会用到它
    self.callbackID = command.callbackId;
    NSDictionary *commandDic = (NSDictionary *)[command.arguments[0] JSONValue];
    
    DLog(@"share : %@",commandDic);
    
    //当前controller返回主页面
    ActivityViewController *activityVC = (ActivityViewController *)self.viewController;
    [activityVC shareWithInfo:commandDic];
}

//返回用户信息
- (void)getUserInfo:(CDVInvokedUrlCommand *)command
{
    DLog(@"getUserInfo : %@",command.arguments);
    
    NSDictionary *userinfo = [[LogInUser getNowLogInUser] keyValues];
#warning dflasdkflskadlfklskdf;lkas;dlkf  kebeg=+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    NSString *jsonString = userinfo.toJSONString;
    [self send:command backInfo:jsonString];

}

//返回上一个页面
- (void)backToDiscover:(CDVInvokedUrlCommand *)command
{
    DLog(@"backToDiscover : %@",command.arguments);
    
    //当前controller返回主页面
    ActivityViewController *activityVC = (ActivityViewController *)self.viewController;
    [activityVC backToFindVC];
}

//调用微信支付
- (void)wechatPay:(CDVInvokedUrlCommand *)command
{
    DLog(@"wechatPay : %@",command.arguments);
    [self send:command backInfo:@"微信支付"];
}

//发送回复
- (void)send:(CDVInvokedUrlCommand *)command backInfo:(NSString *)backInfo
{
    self.callbackID = command.callbackId;
    CDVPluginResult* pluginResult = nil;
    //    NSString* myarg = [command.arguments objectAtIndex:0];
    
    //    if (myarg != nil) {
    //        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:backInfo];
    //    } else {
    //        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Arg was null"];
    //    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
