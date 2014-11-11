//
//  HttpTool.m
//  Welian
//
//  Created by dong on 14-9-19.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "HttpTool.h"
#import "WLHUDView.h"

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
