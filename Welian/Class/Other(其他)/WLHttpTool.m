//
//  WLHttpTool.m
//  Welian
//
//  Created by dong on 14-9-21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "WLHttpTool.h"
#import "HttpTool.h"
#import "WLHUDView.h"
#import "WLUserStatusesResult.h"
#import "MJExtension.h"

@implementation WLHttpTool

#pragma mark - 登陆获取验证码/密码
+ (void)loginGetCheckCodeParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [WLHUDView showHUDWithStr:@"获取验证码" dim:NO];
    [[HttpTool sharedService] reqestParameters:parameterDic successBlock:^(id JSON) {
        if ([JSON objectForKey:@"checkcode"]) {
            UserInfoModel *mod = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
            [mod setCheckcode:[JSON objectForKey:@"checkcode"]];
            [[UserInfoTool sharedUserInfoTool] saveUserInfo:mod];
        }
        [WLHUDView hiddenHud];
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];

}

#pragma mark - 验证 验证码
+ (void)checkCodeParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestParameters:parameterDic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}


#pragma mark - 用户注册填写信息
+ (void)saveProfileAvatarParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"saveProfileAvatar",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock (error);
    }];
}

#pragma mark - 发布状态
+ (void)addFeedParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"addFeed",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock (error);
    }];
}

#pragma mark - 加载好友最新动态
+ (void)loadFeedParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
//    [WLHUDView showHUDWithStr:@"玩命加载..." dim:NO];
    NSDictionary *dic = @{@"type":@"loadFeed",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
//        [WLHUDView showSuccessHUD:@""];
        WLUserStatusesResult *result = [WLUserStatusesResult objectWithKeyValues:@{@"data":JSON}];
        
        
        succeBlock (result);
    } failure:^(NSError *error) {
        
        failurBlock(error);
    }];
}

@end
