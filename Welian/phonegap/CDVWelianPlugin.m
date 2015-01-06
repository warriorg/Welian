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
#import "ActivityDetailViewController.h"
#import "ActivityOrderViewController.h"

@interface CDVWelianPlugin ()

@end

@implementation CDVWelianPlugin



//页面预加载成功
//- (void)pageOnComplete:(CDVInvokedUrlCommand *)command
//{
//    DLog(@"pageOnComplete : %@",command.arguments);
//    //预加载结束隐藏头部和加载条
////    ActivityViewController *activityVC = (ActivityViewController *)self.viewController;
////    [activityVC hideHeader];
//}


//返回头部高度
//- (void)getHeadHeight:(CDVInvokedUrlCommand *)command
//{
//    DLog(@"getHeadHeight : %@",command.arguments);
//    [self send:command backInfo:@"64"];
//}

////分享
//- (void)share:(CDVInvokedUrlCommand *)command
//{
//    // 这是classid,在下面的PluginResult进行数据的返回时,将会用到它
//    self.callbackID = command.callbackId;
//    NSDictionary *commandDic = (NSDictionary *)[command.arguments[0] JSONValue];
//    
//    DLog(@"share : %@",commandDic);
//    
//    //当前controller返回主页面
//    ActivityViewController *activityVC = (ActivityViewController *)self.viewController;
//    [activityVC shareWithInfo:commandDic];
//}

//返回用户信息
//- (void)getUserInfo:(CDVInvokedUrlCommand *)command
//{
//    DLog(@"getUserInfo : %@",command.arguments);
//    
//    NSDictionary *userinfo = [[LogInUser getNowLogInUser] keyValues];
//    NSString *jsonString = userinfo.toJSONString;
//    [self send:command backInfo:jsonString];
//
//}

//返回上一个页面
//- (void)backToDiscover:(CDVInvokedUrlCommand *)command
//{
//    DLog(@"backToDiscover : %@",command.arguments);
//    
//    //当前controller返回主页面
//    ActivityViewController *activityVC = (ActivityViewController *)self.viewController;
//    [activityVC backToFindVC];
//}


/**
 * 获取sessionid
 *
 * @param callbackContext
 */
- (void)getSessionId:(CDVInvokedUrlCommand *)command
{
    DLog(@"getSessionId : %@",command.arguments);
    NSString *sessionId = [LogInUser getNowLogInUser].sessionid;
    [self send:command backInfo:sessionId];
}

/**
 * 获取当前登录用户信息
 * @param callbackContext
 */
- (void)getUserInfo:(CDVInvokedUrlCommand *)command
{
    //('{"name":"夏显林","mobile":"15068114669","company":"杭州传送门网络科技有限公司","position":"前端开发工程师"}')
    DLog(@"getUserInfo : %@",command.arguments);
    LogInUser *loginUser = [LogInUser getNowLogInUser];
    NSDictionary *userinfo = @{@"name":loginUser.name,@"mobile":loginUser.mobile,@"company":loginUser.company,@"position":loginUser.position};//[[LogInUser getNowLogInUser] keyValues];
    NSString *jsonString = userinfo.toJSONString;
    [self send:command backInfo:jsonString];
}

/**
 * 调用原生弹窗
 * @param msg 显示信息
 * @param callbackContext
 */
- (void)showDialog:(CDVInvokedUrlCommand *)command
{
    DLog(@"showDialog : %@",command.arguments);
    [UIAlertView bk_alertViewWithTitle:@"系统提示" message:command.arguments[0]];
}

/**
 * 侧面滑入报名人员列表
 * @param aid 活动id
 * @param count 报名总人数
 */
- (void)showEntry:(CDVInvokedUrlCommand *)command
{
    DLog(@"showEntry : %@",command.arguments);
    ActivityDetailViewController *activityVC = (ActivityDetailViewController *)self.viewController;
    [activityVC showEntry:command.arguments];
}

/**
 * 跳转详情页
 * @param aid 活动id
 * @param msg 分享内容
 */
- (void)goToDetail:(CDVInvokedUrlCommand *)command
{
    DLog(@"goToDetail : %@",command.arguments);
    ActivityViewController *activityVC = (ActivityViewController *)self.viewController;
    [activityVC toActivityDetailVC:command.arguments];
}

/**
 * 跳转订单页
 * @param aid 活动id
 */
- (void)goToOrder:(CDVInvokedUrlCommand *)command
{
    DLog(@"goToOrder : %@",command.arguments);
    ActivityDetailViewController *activityVC = (ActivityDetailViewController *)self.viewController;
    [activityVC toOrderVC:command.arguments];
}

/**
 * 微信支付
 * @param money
 * @param callbackContext
 */
- (void)wechatPay:(CDVInvokedUrlCommand *)command
{
    DLog(@"wechatPay : %@",command.arguments);
    [self send:command backInfo:@"微信支付"];
}

/**
 * 跳转地图
 * @param city 城市
 * @param address 地址
 */
- (void)goToMap:(CDVInvokedUrlCommand *)command
{
    DLog(@"goToMap : %@  -- %@",command.arguments[0],command.arguments[1]);
    ActivityDetailViewController *activityVC = (ActivityDetailViewController *)self.viewController;
    [activityVC toMapVC:command.arguments];
//    if ([self.viewController isKindOfClass:[ActivityDetailViewController class]]) {
//        [(ActivityDetailViewController *)self.viewController toMapVC:command.arguments];
//    }
}

/**
 * 获取当前订单信息
 * @param callbackContext
 */
- (void)getOrderInfo:(CDVInvokedUrlCommand *)command
{
    DLog(@"getOrderInfo : %@",command.arguments);
    ActivityOrderViewController *orderVC = (ActivityOrderViewController *)self.viewController;
    [self send:command backInfo:orderVC.orderInfo];
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
