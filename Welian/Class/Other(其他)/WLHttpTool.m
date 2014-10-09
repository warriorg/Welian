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


#pragma mark - 用户登陆
+ (void)loginParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
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

#pragma mark - 修改用户信息
+ (void)saveProfileParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"saveProfile",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock (error);
    }];
}

#pragma mark - 修改用户头像
+ (void)uploadAvatarParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"uploadAvatar",@"data":parameterDic};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
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

#pragma mark - 关键字搜索公司
+ (void)getCompanyParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];

}


#pragma mark - 关键字搜索学校
+ (void)getSchoolParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 关键字搜索职位
+ (void)getJobParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 投资者认证
+ (void)investAuthParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 取投资者认证信息
+ (void)getInvestAuthParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 取动态评论
+ (void)loadFeedCommentParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 添加动态评论
+ (void)addFeedCommentParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 删除评论
+ (void)deleteFeedCommentParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 转发评论
+ (void)forwardFeedParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 添加动态赞
+ (void)addFeedZanParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];

}


#pragma mark - 取动态赞
+ (void)loadFeedZanParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 取消赞
+ (void)deleteFeedZanParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 根据uid取用户信息  0取自己
+ (void)loadProfileParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 根据uid取用户好友  0取自己
+ (void)loadFriendParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 根据fid取一条动态信息
+ (void)loadOneFeedParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 取发现
+ (void)loadFoundParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    [[HttpTool sharedService] reqestWithSessIDParameters:parameterDic successBlock:^(id JSON) {
        succeBlock (JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 添加教育经历
+ (void)addSchoolParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    
    NSDictionary *dic = @{@"type":@"addSchool",@"data":@[parameterDic]};
    
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 取教育经历
+ (void)loadUserSchoolParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadUserSchool",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        NSArray *dataA = [NSArray arrayWithArray:JSON];
        succeBlock(dataA);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}



#pragma mark - 取工作经历
+ (void)loadUserCompanyParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"loadUserCompany",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}

#pragma mark - 添加工作经历
+ (void)addCompanyParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock
{
    NSDictionary *dic = @{@"type":@"addCompany",@"data":parameterDic};
    [[HttpTool sharedService] reqestWithSessIDParameters:dic successBlock:^(id JSON) {
        
        succeBlock(JSON);
    } failure:^(NSError *error) {
        failurBlock(error);
    }];
}


@end
