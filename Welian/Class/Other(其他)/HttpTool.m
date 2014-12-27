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
            failureBlock ([[NSError alloc] init]);
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
    [self reqestWithSessIDParameters:parameterDic path:@"server/index" successBlock:success failure:failureBlock withHUD:isHUD andDim:isDim];
}

- (void)reqestWithSessIDParameters:(NSDictionary *)parameterDic path:(NSString *)path successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock withHUD:(BOOL)isHUD andDim:(BOOL)isDim
{
    if (isHUD) {
        [WLHUDView showHUDWithStr:@"加载中" dim:isDim];
    }
    
    NSString *parameterStr = [self dicTostring:parameterDic];

    LogInUser *mode = [LogInUser getNowLogInUser];
    NSString *sessid = mode.sessionid;
    if (!sessid) {
        sessid = [UserDefaults objectForKey:@"SID"];
    }
    NSDictionary *parmetDic = @{@"json":parameterStr,@"sessionid":sessid};
    [self formatUrlAndParameters:parmetDic];
    //添加头部字段
    [engine.requestSerializer setValue:sessid forHTTPHeaderField:@"jsessionid"];
    [engine POST:path parameters:parmetDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        DLog(@"%@",[operation responseString]);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:0 error:nil];
        DLog(@"%@",dic);
        if ([[dic objectForKey:@"state"] integerValue]==0) { // 成功
            [WLHUDView hiddenHud];
            success([dic objectForKey:@"data"]);
            
        }else if([[dic objectForKey:@"state"] integerValue]==1){ // 失败
            [WLHUDView showErrorHUD:[dic objectForKey:@"errorcode"]];
            failureBlock ([[NSError alloc] init]);
        }else if ([[dic objectForKey:@"state"] integerValue]==2){ // ID超时
            _seleDic = parameterDic;
            
            
        }else{
            [WLHUDView hiddenHud];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"%@",error);
        //        [WLHUDView showErrorHUD:error.localizedDescription];
        failureBlock(error);
    }];
}

#pragma mark - Get请求
- (void)reqestGetWithPath:(NSString *)path successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock withHUD:(BOOL)isHUD andDim:(BOOL)isDim
{
    if (isHUD) {
        [WLHUDView showHUDWithStr:@"加载中" dim:isDim];
    }
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.weibo.com/"]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDictionary *param = @{@"url_short" : path,@"access_token":@"2.00HxKmmFXflFGDae47a42e3ciWDcPE"};
    [manager GET:@"2/short_url/expand.json" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WLHUDView hiddenHud];
        NSDictionary *dic = [[operation responseString] JSONValue];
        DLog(@"reqestGetWithPath :--%@",dic);
        NSDictionary *urls = dic[@"urls"][0];
    
        //返回 解析后的长链接
        success([urls objectForKey:@"url_long"]);
        
        /*
         {"urls":[
         {"result":true,"url_short":"http://t.cn/Rz1XA2l","url_long":"http://my.welian.com/event/info/117","type":0,"transcode":0}
         ]}
         url_short:短链接
         url_long:原始长链接
         result: 短链的可用状态，true：可用、false：不可用
         type:链接的类型，0：普通网页、1：视频、2：音乐、3：活动、5、投票
         */
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(error);
    }];
}


- (void)againConnectParameters:(NSDictionary *)parameterDic successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock withHUD:(BOOL)isHUD andDim:(BOOL)isDim
{
//    UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
    LogInUser *mode = [LogInUser getNowLogInUser];
    NSMutableDictionary *loginDicM = [NSMutableDictionary dictionary];
    [loginDicM setObject:mode.mobile forKey:@"mobile"];
    [loginDicM setObject:mode.checkcode forKey:@"password"];
    [loginDicM setObject:KPlatformType forKey:@"platform"];
    if ([UserDefaults objectForKey:BPushRequestChannelIdKey]) {
        
        [loginDicM setObject:[UserDefaults objectForKey:BPushRequestChannelIdKey] forKey:@"clientid"];
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
//                UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
                [LogInUser setUserSessionid:[dataDic objectForKey:@"sessionid"]];
//                [[UserInfoTool sharedUserInfoTool] saveUserInfo:mode];
                
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
//    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return str;
}


@end
