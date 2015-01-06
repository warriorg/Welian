//
//  CDVWelianPlugin.h
//  CordovaTests
//
//  Created by weLian on 14/12/18.
//
//

#import <Cordova/CDVPlugin.h>

@class ActivityViewController;
@interface CDVWelianPlugin : CDVPlugin

@property (nonatomic, copy) NSString *callbackID;

//最新版本调用
//- (void)pageOnComplete:(CDVInvokedUrlCommand *)command;
//- (void)getHeadHeight:(CDVInvokedUrlCommand *)command;
//- (void)share:(CDVInvokedUrlCommand *)command;
//- (void)backToDiscover:(CDVInvokedUrlCommand *)command;


/**
 * 获取sessionid
 *
 * @param callbackContext
 */
- (void)getSessionId:(CDVInvokedUrlCommand *)command;
/**
 * 获取当前登录用户信息
 * @param callbackContext
 */
- (void)getUserInfo:(CDVInvokedUrlCommand *)command;
/**
 * 调用原生弹窗
 * @param msg 显示信息
 * @param callbackContext
 */
- (void)showDialog:(CDVInvokedUrlCommand *)command;
/**
 * 侧面滑入报名人员列表
 * @param aid 活动id
 * @param count 报名总人数
 */
- (void)showEntry:(CDVInvokedUrlCommand *)command;
/**
 * 跳转详情页
 * @param aid 活动id
 * @param msg 分享内容
 */
- (void)goToDetail:(CDVInvokedUrlCommand *)command;
/**
 * 跳转订单页
 * @param aid 活动id
 */
- (void)goToOrder:(CDVInvokedUrlCommand *)command;
/**
 * 微信支付
 * @param money
 * @param callbackContext
 */
- (void)wechatPay:(CDVInvokedUrlCommand *)command;
/**
 * 跳转地图
 * @param city 城市
 * @param address 地址
 */
- (void)goToMap:(CDVInvokedUrlCommand *)command;
/**
 * 获取当前订单信息
 * @param callbackContext
 */
- (void)getOrderInfo:(CDVInvokedUrlCommand *)command;


@end
