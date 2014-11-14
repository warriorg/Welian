//
//  HttpTool.m
//  Welian
//
//  Created by dong on 14-9-19.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "HttpTool.h"
#import "WLHUDView.h"
#import "BPush.h"

@interface HttpTool()
{
    NSDictionary *_seleDic;
}
@end

@implementation HttpTool

static HttpTool *engine;

+ (HttpTool*)sharedService
{
    if (engine == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            engine = [[self alloc] initWithBaseURL:[NSURL URLWithString:WLHttpServer]];
            engine.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//            engine.responseSerializer = [AFHTTPResponseSerializer serializer];
        });
    }
    return engine;
}


- (void)reqestParameters:(NSDictionary *)parameterDic successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock withHUD:(BOOL)isHUD andDim:(BOOL)isDim
{
    if (isHUD) {
        [WLHUDView showHUDWithStr:@"加载中" dim:isDim];
    }
    NSString *parameterStr = [self dicTostring:parameterDic];
    NSDictionary *parmetDic = @{@"json":parameterStr};
    
    [self formatUrlAndParameters:parameterDic];
    
    [engine POST:@"server/index" parameters:parmetDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@",[operation responseString]);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:0 error:nil];
        DLog(@"%@",dic);
        if ([[dic objectForKey:@"state"] integerValue]==0) { // 成功
            [WLHUDView hiddenHud];
            success([dic objectForKey:@"data"]);
        }else if([[dic objectForKey:@"state"] integerValue]==1){ // 失败
            [WLHUDView showErrorHUD:[dic objectForKey:@"errorcode"]];
        }else if ([[dic objectForKey:@"state"] integerValue]==2){ // ID超时
            [WLHUDView showErrorHUD:@"senddidddd超时"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"%@",error);
        [WLHUDView showErrorHUD:error.localizedDescription];
        failureBlock(error);
    }];
}


- (void)reqestWithSessIDParameters:(NSDictionary *)parameterDic successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock withHUD:(BOOL)isHUD andDim:(BOOL)isDim
{
    
//    if (![UserDefaults objectForKey:BPushRequestUserIdKey]) {
//        
//        [BPush bindChannel]; // 必须。可以在其它时机调用，只有在该方法返回（通过onMethod:response:回调）绑定成功时，app才能接收到Push消息。一个app绑定成功至少一次即可（如果access token变更请重新绑定）。
//        
//        DLog(@"%@---%@---%@",[BPush getChannelId],[BPush getUserId],[BPush getAppId]);
//    }else{
//        DLog(@"百度推送 ----------------加载成功");
//    }
    
    if (isHUD) {
        [WLHUDView showHUDWithStr:@"加载中" dim:isDim];
    }
    
    NSString *parameterStr = [self dicTostring:parameterDic];
    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    
    NSDictionary *parmetDic = @{@"json":parameterStr,@"sessionid":mode.sessionid};
    [self formatUrlAndParameters:parmetDic];
    
    [engine POST:@"server/index" parameters:parmetDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:0 error:nil];
        DLog(@"%@",dic);
        if ([[dic objectForKey:@"state"] integerValue]==0) { // 成功
            [WLHUDView hiddenHud];
            success([dic objectForKey:@"data"]);
            
        }else if([[dic objectForKey:@"state"] integerValue]==1){ // 失败
          [WLHUDView showErrorHUD:[dic objectForKey:@"errorcode"]];
        }else if ([[dic objectForKey:@"state"] integerValue]==2){ // ID超时
            _seleDic = parameterDic;
//            [self againConnectParameters:parameterDic successBlock:^(id JSON) {
//                success(JSON);
//            } failure:^(NSError *error) {
//                failureBlock(error);
//            } withHUD:isHUD andDim:isDim];
            
//            [WLHUDView showErrorHUD:[dic objectForKey:@"errorcode"]];
        }else{
            [WLHUDView hiddenHud];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"%@",error);
//        [WLHUDView showErrorHUD:error.localizedDescription];
        failureBlock(error);
    }];
}

// 必须，如果正确调用了setDelegate，在bindChannel之后，结果在这个回调中返回。
// 若绑定失败，请进行重新绑定，确保至少绑定成功一次
- (void) onMethod:(NSString*)method response:(NSDictionary*)data
{
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        //        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        //        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        
        if (returnCode == BPushErrorCode_Success) {
            
            // 在内存中备份，以便短时间内进入可以看到这些值，而不需要重新bind
            [UserDefaults setObject:userid forKey:BPushRequestUserIdKey];
            [UserDefaults setObject:channelid forKey:BPushRequestChannelIdKey];
            DLog(@"百度推送 ----------------加载成功");
        }
    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
            
            [UserDefaults removeObjectForKey:BPushRequestChannelIdKey];
            [UserDefaults removeObjectForKey:BPushRequestUserIdKey];
            
        }
    }
}



- (void)againConnectParameters:(NSDictionary *)parameterDic successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock withHUD:(BOOL)isHUD andDim:(BOOL)isDim
{
    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    NSMutableDictionary *loginDicM = [NSMutableDictionary dictionary];
    [loginDicM setObject:mode.mobile forKey:@"mobile"];
    [loginDicM setObject:mode.checkcode forKey:@"password"];
    [loginDicM setObject:@"ios" forKey:@"platform"];
    if ([UserDefaults objectForKey:BPushRequestChannelIdKey]) {
        
        [loginDicM setObject:[UserDefaults objectForKey:BPushRequestChannelIdKey] forKey:@"clientid"];
        [loginDicM setObject:[UserDefaults objectForKey:BPushRequestUserIdKey] forKey:@"baiduuid"];
    }

    NSDictionary *loginDic = @{@"type":@"login",@"data":loginDicM};
    NSString *parameterStr = [self dicTostring:loginDic];
    NSDictionary *parmetDic = @{@"json":parameterStr};
    
    [engine POST:@"server/index" parameters:parmetDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:0 error:nil];
        DLog(@"%@",dic);
        if ([[dic objectForKey:@"state"] integerValue]==0) { // 成功
            [WLHUDView hiddenHud];
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            if (dataDic) {
                UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
                [mode setSessionid:[dataDic objectForKey:@"sessionid"]];
                [[UserInfoTool sharedUserInfoTool] saveUserInfo:mode];
                
                [self reqestWithSessIDParameters:_seleDic successBlock:^(id JSON) {
                    if (JSON) { // 成功
                        [WLHUDView hiddenHud];
                        success(JSON);
                        
                    }else{ // 失败
                        [WLHUDView showErrorHUD:[dic objectForKey:@"errorcode"]];
                    }
                    
                    
                } failure:^(NSError *error) {
                    failureBlock(error);
                } withHUD:isHUD andDim:isDim];
                
            }
            
        }else { // 失败
            [WLHUDView showErrorHUD:[dic objectForKey:@"errorcode"]];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)formatUrlAndParameters:(NSDictionary*)parameters{
    //格式化url和参数
    NSString *paraString=@"";
    NSArray *keyArray = [parameters allKeys];
    int index = 0;
    for (NSString *key in keyArray) {
        NSString *value = [parameters objectForKey:key];
        paraString = [NSString stringWithFormat:@"%@%@=%@%@",paraString,key,value, ++index == keyArray.count ? @"" : @"&"];
    }
    NSString *api = [NSString stringWithFormat:@"====\n%@/%@?%@\n=======", WLHttpServer,@"server/index", paraString];
    DLog(@"api:%@", api);
}

- (NSString*)dicTostring:(NSDictionary*)parameterDic
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameterDic options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return str;
}


@end
