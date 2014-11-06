//
//  WLHttpTool.h
//  Welian
//
//  Created by dong on 14-9-21.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WLHttpSuccessBlock)(id JSON);
typedef void (^WLHttpFailureBlock)(NSError *error);

@interface WLHttpTool : NSObject

#pragma mark - 版本号更新提示
+ (void)updateParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 忘记密码
+ (void)forgetPasswordParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 登陆获取验证码/密码
+ (void)getCheckCodeParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 验证 验证码
+ (void)checkCodeParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 用户登陆
+ (void)loginParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 用户注册填写信息
+ (void)registerParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 上传所有通讯录
+ (void)uploadPhonebookParameterDic:(NSMutableArray *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 修改用户信息
+ (void)saveProfileParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 修改用户头像
+ (void)uploadAvatarParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;


#pragma mark - 发布状态
+ (void)addFeedParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 删除自己动态
+ (void)deleteFeedParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;


#pragma mark - 加载好友最新动态
+ (void)loadFeedParameterDic:(NSDictionary *)parameterDic andLoadType:(NSNumber *)uid success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 关键字搜索职位
+ (void)getJobParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 关键字搜索学校
+ (void)getSchoolParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 关键字搜索公司
+ (void)getCompanyParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 投资者认证
+ (void)investAuthParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 取投资者认证信息
+ (void)getInvestAuthParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 取动态评论
+ (void)loadFeedCommentParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 添加动态评论
+ (void)addFeedCommentParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 转发评论
+ (void)forwardFeedParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 删除评论
+ (void)deleteFeedCommentParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 添加动态赞
+ (void)addFeedZanParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 取动态赞列表
+ (void)loadFeedZanParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 取消赞
+ (void)deleteFeedZanParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 根据uid取用户信息  0取自己
+ (void)loadProfileParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 根据uid取用户好友列表  0取自己
+ (void)loadFriendWithSQL:(BOOL)isSQL ParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 请求添加为好友
+ (void)requestFriendParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 根据fid取一条动态信息
+ (void)loadOneFeedParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 取发现
+ (void)loadFoundParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 取投资人列表
+ (void)loadInvestorUserParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 添加教育经历
+ (void)addSchoolParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;
#pragma mark - 删除教育经历
+ (void)deleteUserSchoolParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 取教育经历
+ (void)loadUserSchoolParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 取工作经历
+ (void)loadUserCompanyParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 添加工作经历
+ (void)addCompanyParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 删除工作经历
+ (void)deleteUserCompanyParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 取用户详细信息
+ (void)loadUserInfoParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 取共同好友
+ (void)loadSameFriendParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;


#pragma mark - 搜索用户
+(void)searchUserParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 取新好友请求列表
+ (void)loadFriendRequestParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 删除好友请求
+ (void)deleteFriendRequestParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 确认添加好友
+ (void)addFriendParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 删除好友
+ (void)deleteFriendParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 取好友的好友（二度好友）
+ (void)loadUser2FriendParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

#pragma mark - 取最新动态更新数量
+ (void)loadNewFeedCountParameterDic:(NSDictionary *)parameterDic success:(WLHttpSuccessBlock)succeBlock fail:(WLHttpFailureBlock)failurBlock;

@end

