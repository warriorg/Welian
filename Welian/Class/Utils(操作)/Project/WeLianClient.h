//
//  WeLianClient.h
//  Welian
//
//  Created by weLian on 15/4/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface WeLianClient : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;


#pragma mark - 注册，登录
//微信注册
+ (void)wxRegisterWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//手机注册
+ (void)registerWithName:(NSString *)name
                  Mobile:(NSString *)mobile
                 Company:(NSString *)company
                Position:(NSString *)position
                Password:(NSString *)password
                  Avatar:(NSString *)avatar
                 Success:(SuccessBlock)success
                  Failed:(FailedBlock)failed;

//获取验证码
+ (void)getCodeWithMobile:(NSString *)mobile
                     Type:(NSString *)type      //"register","forgetpassword"
                  Success:(SuccessBlock)success
                   Failed:(FailedBlock)failed;

//验证验证码
+ (void)checkCodeWithMobile:(NSString *)mobile
                       Code:(NSString *)code
                    Success:(SuccessBlock)success
                     Failed:(FailedBlock)failed;

//忘记密码
+ (void)changePasswordWithPassWd:(NSString *)password
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed;

//登陆
+ (void)loginWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed;

// 上传平台，clientid
+ (void)updateclientID;

#pragma mark - 用户模块
//修改用户信息
+ (void)saveUserInfoWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//增加教育经历
+ (void)saveSchoolWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//删除教育经历
+ (void)deleteSchoolWithID:(NSNumber *)usid
                   Success:(SuccessBlock)success
                    Failed:(FailedBlock)failed;

//增加工作经历
+ (void)saveCompanyWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//删除工作经历
+ (void)deleteCompanyWithID:(NSNumber *)ucid
                    Success:(SuccessBlock)success
                     Failed:(FailedBlock)failed;

// 取用户详细
+ (void)getUserDetailInfoWithUid:(NSNumber *)uid Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//认证投资人
+ (void)investWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed;

//取用户认证信息
+ (void)loadInvestorWithID:(NSNumber *)uid
                   Success:(SuccessBlock)success
                    Failed:(FailedBlock)failed;

//修改用户密码
+ (void)changeUserPassWdWithOldpassword:(NSString *)oldpassword
                            Newpassword:(NSString *)newpassword
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed;

#pragma mark - 认证手机号码
//取验证码接口
+ (void)getUserMobileCodeWithMobile:(NSString *)mobile
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed;

//验证手机号码
+ (void)checkUserMobileCodeWithCode:(NSString *)code
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed;


#pragma mark - 动态Feed模块
//添加动态
+ (void)saveFeedWithParameterDic:(NSDictionary *)params
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed;

//删除动态
+ (void)deleteFeedWithID:(NSNumber *)fid
                 Success:(SuccessBlock)success
                  Failed:(FailedBlock)failed;
//评论动态
+ (void)commentFeedWithID:(NSNumber *)fid
                  Comment:(NSString *)comment
                    Touid:(NSNumber *)touid
                  Success:(SuccessBlock)success
                   Failed:(FailedBlock)failed;

//删除动态评论评论
+ (void)deleteFeedCommentWithID:(NSNumber *)cid
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed;

//赞
+ (void)feedZanWithID:(NSNumber *)fid
              Success:(SuccessBlock)success
               Failed:(FailedBlock)failed;

//取消赞
+ (void)deleteFeedZanWithID:(NSNumber *)fid
                    Success:(SuccessBlock)success
                     Failed:(FailedBlock)failed;

//转推
+ (void)feedForwardWithID:(NSNumber *)fid
                  Success:(SuccessBlock)success
                   Failed:(FailedBlock)failed;

//取消转推
+ (void)deleteFeedForwardWithID:(NSNumber *)fid
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed;

//取动态列表
+ (void)getFeedListWithStart:(NSNumber *)start
                        Size:(NSNumber *)size
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed;

//取动态评论列表
+ (void)getFeedCommentListWithID:(NSNumber *)fid
                            Page:(NSNumber *)page
                            Size:(NSNumber *)size
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed;

//取赞的用户列表
+ (void)getFeedZanListWithID:(NSNumber *)fid
                        Page:(NSNumber *)page
                        Size:(NSNumber *)size
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed;

//取转推的用户列表
+ (void)getFeedForwardListWithID:(NSNumber *)fid
                            Page:(NSNumber *)page
                            Size:(NSNumber *)size
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed;

//取动态详情
+ (void)getFeedDetailInfoWithID:(NSNumber *)fid
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed;
//举报
+ (void)reportFeedWithID:(NSNumber *)fid
                 Success:(SuccessBlock)success
                  Failed:(FailedBlock)failed;


#pragma mark - 好友模块 friends
//取好友列表
+ (void)getFriendListWithID:(NSNumber *)uid
                    Success:(SuccessBlock)success
                     Failed:(FailedBlock)failed;

//二度好友列表
+ (void)getFriend2ListWithID:(NSNumber *)uid
                        Page:(NSNumber *)page
                        Size:(NSNumber *)size
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed;

//取共同好友
+ (void)getSameFriendListWithID:(NSNumber *)uid
                           Page:(NSNumber *)page
                           Size:(NSNumber *)size
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed;

//请求添加好友
+ (void)requestAddFriendWithID:(NSNumber *)uid
                       Message:(NSString *)message
                       Success:(SuccessBlock)success
                        Failed:(FailedBlock)failed;

//确认添加好友
+ (void)confirmAddFriendWithID:(NSNumber *)uid
                       Success:(SuccessBlock)success
                        Failed:(FailedBlock)failed;

//删除好友
+ (void)deleteFriendWithID:(NSNumber *)uid
                   Success:(SuccessBlock)success
                    Failed:(FailedBlock)failed;


#pragma mark - 项目 project 模块
//取项目列表
+ (void)getProjectListWithPage:(NSNumber *)page
                          Size:(NSNumber *)size
                       Success:(SuccessBlock)success
                        Failed:(FailedBlock)failed;

//取项目详情
+ (void)getProjectDetailInfoWithID:(NSNumber *)pid
                           Success:(SuccessBlock)success
                            Failed:(FailedBlock)failed;

//添加项目，修改
+ (void)saveProjectWithParameterDic:(NSDictionary *)params
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed;

//添加项目成员
+ (void)saveProjectMembersWithParameterDic:(NSDictionary *)params
                                   Success:(SuccessBlock)success
                                    Failed:(FailedBlock)failed;

//删除项目成员
+ (void)deleteProjectMembersWithUid:(NSNumber *)uid
                                Pid:(NSNumber *)pid
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed;

//取项目成员
+ (void)getProjectMembersWithPid:(NSNumber *)pid
                            Page:(NSNumber *)page
                            Size:(NSNumber *)size
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed;

//项目 赞
+ (void)zanProjectWithPid:(NSNumber *)pid
                  Success:(SuccessBlock)success
                   Failed:(FailedBlock)failed;

//项目 评论
+ (void)commentProjectWithParameterDic:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed;

//取赞的用户列表
+ (void)getProjectZanListWithPid:(NSNumber *)pid
                            Page:(NSNumber *)page
                            Size:(NSNumber *)size
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed;

//取评论列表
+ (void)getProjectCommentListWithPid:(NSNumber *)pid
                                Page:(NSNumber *)page
                                Size:(NSNumber *)size
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed;

//删除项目赞
+ (void)deleteProjectZanWithPid:(NSNumber *)pid
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed;

//删除项目评论
+ (void)deleteProjectCommentWithCid:(NSNumber *)cid
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed;

//删除项目图片
+ (void)deleteProjectPhotoWithPhotoid:(NSNumber *)photoid
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed;

//添加项目图片
+ (void)saveProjectPhotoWithParameterDic:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed;

//项目 收藏
+ (void)favoriteProjectWithPid:(NSNumber *)pid
                       Success:(SuccessBlock)success
                        Failed:(FailedBlock)failed;

//取消收藏
+ (void)deleteProjectFavoriteWithPid:(NSNumber *)pid
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed;

//删除项目
+ (void)deleteProjectWithPid:(NSNumber *)pid
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed;


#pragma mark - 活动 active 模块
//取活动列表
+ (void)getActiveListWithDate:(NSNumber *)date      //-1 全部，0今天，1明天，7最近一周，-2 周末
                       Cityid:(NSNumber *)cityid    //0 全国
                         Page:(NSNumber *)page
                         Size:(NSNumber *)size
                      Success:(SuccessBlock)success
                       Failed:(FailedBlock)failed;

//取活动详情
+ (void)getActiveDetailInfoWithID:(NSNumber *)activeid
                          Success:(SuccessBlock)success
                           Failed:(FailedBlock)failed;

//已报名用户列表
+ (void)getActiveRecordersWithID:(NSNumber *)activeid
                            Page:(NSNumber *)page
                            Size:(NSNumber *)size
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed;

//取票务信息
+ (void)getActiveTicketsWithID:(NSNumber *)activeid
                       Success:(SuccessBlock)success
                        Failed:(FailedBlock)failed;

//收藏活动
+ (void)favoriteActiveWithID:(NSNumber *)activeid
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed;

//取消收藏
+ (void)deleteActiveFavoriteWithID:(NSNumber *)activeid
                           Success:(SuccessBlock)success
                            Failed:(FailedBlock)failed;

//取用户相关活动
+ (void)getActiveUserActivesWithType:(NSNumber *)type   ////1 收藏，2参加的
                                Page:(NSNumber *)page
                                Size:(NSNumber *)size
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed;

//报名，购票
+ (void)orderActiveWithID:(NSNumber *)activeid
                  Tickets:(NSArray *)tickets
                  Success:(SuccessBlock)success
                   Failed:(FailedBlock)failed;

//修改订单状态
+ (void)updateActiveOrderStatusWithID:(NSString *)orderid
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed;

//取消报名
+ (void)deleteActiveRecordWithID:(NSNumber *)activeid
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed;

//取已经购买的票
+ (void)getActiveBuyedTicketsWithID:(NSNumber *)activeid
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed;

//取活动城市列表
+ (void)getActiveCitiesSuccess:(SuccessBlock)success
                        Failed:(FailedBlock)failed;







#pragma mark - Other  自定义接口
//下载图片
+ (void)downLoadImageWithMemberId:(NSMutableDictionary *)photos
                         ToFolder:(NSString *)toFolder
                          success:(SuccessBlock)success
                           failed:(FailedBlock)failed;



@end
