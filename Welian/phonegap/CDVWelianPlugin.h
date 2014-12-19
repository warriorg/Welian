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

//2.91版本调用
//- (void)print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
//- (void)pageOnComplete:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
//- (void)getSessionId:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
//- (void)getHeadHeight:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
//- (void)share:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
//- (void)getUserInfo:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
//- (void)backToDiscover:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
//- (void)wechatPay:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;


//最新版本调用
- (void)pageOnComplete:(CDVInvokedUrlCommand *)command;
- (void)getSessionId:(CDVInvokedUrlCommand *)command;
- (void)getHeadHeight:(CDVInvokedUrlCommand *)command;
- (void)share:(CDVInvokedUrlCommand *)command;
- (void)getUserInfo:(CDVInvokedUrlCommand *)command;
- (void)backToDiscover:(CDVInvokedUrlCommand *)command;
- (void)wechatPay:(CDVInvokedUrlCommand *)command;


@end
