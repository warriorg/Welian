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

- (void)print:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    
    // 这是classid,在下面的PluginResult进行数据的返回时,将会用到它
    self.callbackID = [arguments pop];
    
    // 得到Javascript端发送过来的字符串
    NSString *stringObtainedFromJavascript = [arguments objectAtIndex:0];
    
    // 创建我们要返回给js端的字符串
    NSMutableString *stringToReturn = [NSMutableString stringWithString: @"我是返回的:"];
    
    [stringToReturn appendString: stringObtainedFromJavascript];
    
    // Create Plugin Result
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: stringToReturn];
    
    NSLog(@"------%@",stringToReturn);
    
    // 检查发送过来的字符串是否等于"HelloWorld",如果不等,就以PluginResult的Error形式返回
    if ([stringObtainedFromJavascript isEqualToString:@"HelloWorld"] == YES){
        NSLog(@"在这里调用oc的数据");
        
        // Call the javascript success function
        [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
    } else{
        // Call the javascript error function
        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
    }
}

//预加载结束
- (void)pageOnComplete:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options
{
    NSLog(@"pageOnComplete");
}

//反悔sessionids
- (void)getSessionId:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options
{
    NSLog(@"getSessionId");
    NSString *sessionId = [[UserInfoTool sharedUserInfoTool] getUserInfoModel].sessionid;
    [self writeToJavascript:arguments withDict:options backInfo:sessionId];
}

//返回头部高度
- (void)getHeadHeight:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options
{
    NSLog(@"getHeadHeight: %@",arguments);
    
    [self writeToJavascript:arguments withDict:options backInfo:@"64"];
}

//分享
- (void)share:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options
{
    NSLog(@"share 返回内容 : %@",arguments);
    // 这是classid,在下面的PluginResult进行数据的返回时,将会用到它
    self.callbackID = [arguments pop];
    // 得到Javascript端发送过来的字符串
//    NSString *stringObtainedFromJavascript = [arguments objectAtIndex:0];
    NSLog(@"分享内容 ----\n  标题 : %@ \n 内容:%@  \n 图片地址：%@ \n 链接地址：%@",arguments[0],arguments[1],arguments[2],arguments[3]);
//    NSString *shareInfo = [NSString stringWithFormat:@"标题 : %@ \n内容:%@\n 图片地址：%@ \n 链接地址：%@",arguments[0],arguments[1],arguments[2],arguments[3]];
    
//    [[[UIAlertView alloc] initWithTitle:@"分享"
//                               message:shareInfo
//                              delegate:self
//                     cancelButtonTitle:@"取消"
//                      otherButtonTitles:@"确定", nil] show];
    
    //当前controller返回主页面
    ActivityViewController *activityVC = (ActivityViewController *)self.viewController;
    [activityVC shareWithInfo];
    
    // 创建我们要返回给js端的字符串
//    NSMutableString *stringToReturn = [NSMutableString stringWithString: @"我是返回的信息"];
    
    // Create Plugin Result
//    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: stringToReturn];
    
//    NSLog(@"------%@",stringToReturn);
    
    // Call the javascript success function
//    [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];

}

//获取用户信息
- (void)getUserInfo:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options
{
    NSLog(@"getUserInfo :%@",arguments);
    NSDictionary *userinfo = [[[UserInfoTool sharedUserInfoTool] getUserInfoModel] keyValues];
    NSString *jsonString = userinfo.toJSONString;
    [self writeToJavascript:arguments withDict:options backInfo:jsonString];
}

//返回上一个页面
- (void)backToDiscover:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options
{
    NSLog(@"backToDiscover : %@",arguments);
    //当前controller返回主页面
    ActivityViewController *activityVC = (ActivityViewController *)self.viewController;
    [activityVC backToFindVC];
    
    [self writeToJavascript:arguments withDict:options backInfo:@"返回上一个页面"];
}

//微信支付
- (void)wechatPay:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options
{
    NSLog(@"wechatPay : %@",arguments);
    [self writeToJavascript:arguments withDict:options backInfo:@"微信支付"];
}


- (void)writeToJavascript:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options backInfo:(NSString *)backInfo
{
    // 这是classid,在下面的PluginResult进行数据的返回时,将会用到它
    self.callbackID = [arguments pop];
    
    // 得到Javascript端发送过来的字符串
//    NSString *stringObtainedFromJavascript = [arguments objectAtIndex:0];
    
    // 创建我们要返回给js端的字符串
//    NSMutableString *stringToReturn = [NSMutableString stringWithString: @"我是返回的信息"];
    
//    [stringToReturn appendString: stringObtainedFromJavascript];
    
    // Create Plugin Result
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: backInfo];
    
//    NSLog(@"------%@",stringToReturn);
    
    // Call the javascript success function
    [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
    
    // 检查发送过来的字符串是否等于"HelloWorld",如果不等,就以PluginResult的Error形式返回
//    if ([stringObtainedFromJavascript isEqualToString:@"HelloWorld"] == YES){
//        NSLog(@"在这里调用oc的数据");
//        
//        // Call the javascript success function
//        [self writeJavascript: [pluginResult toSuccessCallbackString:self.callbackID]];
//    } else{
//        // Call the javascript error function
//        [self writeJavascript: [pluginResult toErrorCallbackString:self.callbackID]];
//    }
}

@end
