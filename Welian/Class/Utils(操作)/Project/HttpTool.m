//
//  HttpTool.m
//  Welian
//
//  Created by dong on 14-9-19.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "HttpTool.h"
#import "WLHUDView.h"
#import "AppDelegate.h"

@interface HttpTool()

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
            engine.requestSerializer = [AFHTTPRequestSerializer serializer];
            engine.responseSerializer = [AFHTTPResponseSerializer serializer];
        });
    }
    return engine;
}


- (void)reqestParameters:(NSDictionary *)parameterDic successBlock:(HttpSuccessBlock)success failure:(HttpFailureBlock)failureBlock withHUD:(BOOL)isHUD andDim:(BOOL)isDim
{
    if (isHUD) {
        [WLHUDView showHUDWithStr:@"加载中..." dim:isDim];
    }
    NSString *parameterStr = [self dicTostring:parameterDic];
    NSDictionary *parmetDic = @{@"json":parameterStr};
    
    [self formatUrlAndParameters:parameterDic];
    
    [engine POST:@"server/index" parameters:parmetDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [WLHUDView hiddenHud];
        DLog(@"%@",[operation responseString]);
        if (![operation responseData]) {
            [WLHUDView showErrorHUD:@"网络连接失败！"];
            failureBlock ([NSError errorWithDomain:@"网络连接失败！" code:-1 userInfo:nil]);
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:0 error:nil];
        DLog(@"%@",dic);
        if ([[dic objectForKey:@"state"] integerValue]==0) { // 成功

            success([dic objectForKey:@"data"]);
        }else if([[dic objectForKey:@"state"] integerValue]==1){ // 失败
            failureBlock ([NSError errorWithDomain:[dic objectForKey:@"errorcode"] code:1 userInfo:nil]);
        }else if ([[dic objectForKey:@"state"] integerValue]==2){ // ID超时
            failureBlock ([NSError errorWithDomain:[dic objectForKey:@"errorcode"] code:2 userInfo:nil]);
        }else if ([[dic objectForKey:@"state"] integerValue]==-1){// 系统错误
            failureBlock ([NSError errorWithDomain:[dic objectForKey:@"errorcode"] code:-1 userInfo:nil]);
        }else if ([[dic objectForKey:@"state"] integerValue]==-2){// 微信没登陆过
            failureBlock ([NSError errorWithDomain:[dic objectForKey:@"errorcode"] code:-2 userInfo:[dic objectForKey:@"data"]]);
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

//    LogInUser *mode = [LogInUser getCurrentLoginUser];
    NSString *sessid = [UserDefaults objectForKey:kSessionId];
    if (!sessid) {
        [[self operationQueue] cancelAllOperations];
        return;
    }
//    NSDictionary *parmetDic = @{@"json":parameterStr,@"sessionid":sessid};
    NSDictionary *parmetDic = @{@"json":parameterStr,@"sessionid":sessid};
    [self formatUrlAndParameters:parmetDic];

    [engine POST:path parameters:parmetDic success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if (!dic) {
            [WLHUDView showErrorHUD:@"连接错误，请稍后再试"];
            failureBlock ([NSError errorWithMsg:nil]);
            return;
        }
//        NSData *doubi = responseObject;
//        NSString *shabi =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
        
        DLog(@"%@",dic);
        if ([[dic objectForKey:@"state"] integerValue]==0) { // 成功
            [WLHUDView hiddenHud];
            success([dic objectForKey:@"data"]);
            
        }else if([[dic objectForKey:@"state"] integerValue]==1){ // 失败
            [WLHUDView showErrorHUD:[dic objectForKey:@"errorcode"]];
            failureBlock ([[NSError alloc] init]);
        }else if ([[dic objectForKey:@"state"] integerValue]==2){ // ID超时
            [[self operationQueue] cancelAllOperations];
//            [[AppDelegate sharedAppDelegate] logout];
            failureBlock ([NSError errorWithDomain:[dic objectForKey:@"errorcode"] code:2 userInfo:nil]);
        }else if ([[dic objectForKey:@"state"] integerValue]== -1){ // 已经不在是好友关系
            [WLHUDView showErrorHUD:[dic objectForKey:@"errorcode"]];
            success(@{@"state":@"-1"});
        }else{
            [WLHUDView hiddenHud];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"%@",error);
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
