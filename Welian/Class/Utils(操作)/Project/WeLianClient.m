//
//  WeLianClient.m
//  Welian
//
//  Created by weLian on 15/4/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WeLianClient.h"

@interface WeLianClient ()
{
    NSOperationQueue *_operationQ;
}

@end


@implementation WeLianClient

- (NSOperationQueue *)getOperationQ
{
    if (_operationQ==nil) {
        _operationQ = [[NSOperationQueue alloc] init];
        _operationQ.maxConcurrentOperationCount = 1;
    }
    return _operationQ;
}


- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        //设置传输为json格式
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }
    return self;
}

+ (instancetype)sharedClient
{
    static WeLianClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WeLianClient alloc] initWithBaseURL:[NSURL URLWithString:WLHttpServer]];
    });
    return _sharedClient;
}

+ (void)formatUrlAndParameters:(NSDictionary*)parameters WithpathInfo:(NSString *)pathInfo{
    //格式化url和参数
    NSString *paraString=@"";
    NSArray *keyArray = [parameters allKeys];
    int index = 0;
    for (NSString *key in keyArray) {
        NSString *value = [parameters objectForKey:key];
        paraString = [NSString stringWithFormat:@"%@%@=%@%@",paraString,key,value, ++index == keyArray.count ? @"" : @"&"];
    }
    NSString *api = [NSString stringWithFormat:@"====\n%@/%@?%@\n=======", WLHttpServer,pathInfo, paraString];
    DLog(@"api:%@", api);
}


//post请求
+ (void)reqestPostWithParams:(NSDictionary *)params Path:(NSString *)path Success:(SuccessBlock)success
                            Failed:(FailedBlock)failed
{
    //设置sessionid
    NSString *sessid = [UserDefaults objectForKey:kSessionId];
    
    NSString *pathInfo = path;
    if (sessid.length) {
        pathInfo = [NSString stringWithFormat:@"%@?sessionid=%@",path,sessid];
    }
    //打印
//    [self formatUrlAndParameters:params WithpathInfo:pathInfo];
    [[WeLianClient sharedClient] POST:pathInfo
                           parameters:params
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  DLog(@"reqest Result ---- %@",[operation responseString]);
                                  
                                  IBaseModel *result = [IBaseModel objectWithDict:responseObject];
                                  //如果sessionid有的话放入data
                                  if (result.isSuccess) {
                                      if (result.sessionid.length > 0) {
                                          //保存session
                                          [UserDefaults setObject:result.sessionid forKey:kSessionId];
                                      }
                                      SAFE_BLOCK_CALL(success, result.data);
                                  }else{
                                      if (result.state.integerValue > 1000 && result.state.integerValue < 2000) {
                                          //可以提醒的错误
                                          SAFE_BLOCK_CALL(failed, result.error);
                                      }else if(result.state.integerValue >= 2000 && result.state.integerValue < 3000){
                                          //系统级错误，直接打印错误信息
                                          DLog(@"Result System ErroInfo-- : %@",result.errormsg);
                                          SAFE_BLOCK_CALL(failed, nil);
                                      }else if(result.state.integerValue>=3000){
                                          //打印错误信息 ，返回操作
                                          DLog(@"Result ErroInfo-- : %@",result.errormsg);
                                          SAFE_BLOCK_CALL(success, result.data);
                                      }else{
                                          DLog(@"Result ErroInfo-- : %@",result.errormsg);
                                          SAFE_BLOCK_CALL(failed, nil);
                                      }
                                  }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  //打印错误信息
                                  SAFE_BLOCK_CALL(failed, nil);
                                  DLog(@"SystemErroInfo-- : %@",error.description);
                              }];
}

#pragma mark - 注册，登录
//微信注册
+ (void)wxRegisterWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:params
                          Path:kWXRegisterPath
                       Success:^(id resultInfo) {
                           DLog(@"wxRegister ---- %@",resultInfo);
                           if ([resultInfo objectForKey:@"flag"]) {
                               SAFE_BLOCK_CALL(success, resultInfo);
                           }else if(resultInfo){
                               ILoginUserModel *result = [ILoginUserModel objectWithDict:resultInfo];
                               //记录最后一次登陆的手机号
                               SaveLoginMobile(result.mobile);
                               SAFE_BLOCK_CALL(success, result);
                           }
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//手机注册
+ (void)registerWithName:(NSString *)name
                  Mobile:(NSString *)mobile
                 Company:(NSString *)company
                Position:(NSString *)position
                Password:(NSString *)password
                  Avatar:(NSString *)avatar
                 Success:(SuccessBlock)success
                  Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"name":name
                             ,@"mobile":mobile
                             ,@"company":company
                             ,@"position":position
                             ,@"avatar":@"1417496795301_x.png"
                             ,@"password":password};
    [self reqestPostWithParams:params
                          Path:kRegisterPath
                       Success:^(id resultInfo) {
                           DLog(@"register ---- %@",resultInfo);
                           ILoginUserModel *result = [ILoginUserModel objectWithDict:resultInfo];
                           //记录最后一次登陆的手机号
                           SaveLoginMobile(result.mobile);
                           SAFE_BLOCK_CALL(success, result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//获取验证码
+ (void)getCodeWithMobile:(NSString *)mobile
                     Type:(NSString *)type      //"register","forgetpassword"
                  Success:(SuccessBlock)success
                   Failed:(FailedBlock)failed
{
    //"register","forgetpassword"
    NSDictionary *params = @{@"mobile":mobile
                             ,@"type":type};
    [self reqestPostWithParams:params
                          Path:kGetcodePath
                       Success:^(id resultInfo) {
                           DLog(@"getCode ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//验证验证码
+ (void)checkCodeWithMobile:(NSString *)mobile
                       Code:(NSString *)code
                    Success:(SuccessBlock)success
                     Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"mobile":mobile
                             ,@"code":code};
    [self reqestPostWithParams:params
                          Path:kCheckcodePath
                       Success:^(id resultInfo) {
                           DLog(@"checkCode ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//忘记密码
+ (void)changePasswordWithPassWd:(NSString *)password
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"password":password};
    [self reqestPostWithParams:params
                          Path:kChanagePasswordPath
                       Success:^(id resultInfo) {
                           DLog(@"changePassword ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

// 登陆
+ (void)loginWithParameterDic:(NSDictionary *)params
                      Success:(SuccessBlock)success
                       Failed:(FailedBlock)failed
{
//    NSDictionary *params = @{@"mobile":mobile
//                             ,@"unionid":unionid
//                             ,@"password":password};
    [self reqestPostWithParams:params
                          Path:kLoginPath
                       Success:^(id resultInfo) {
                           DLog(@"login ---- %@",resultInfo);
                           if ([[resultInfo objectForKey:@"flag"] integerValue]==0&&[resultInfo objectForKey:@"flag"]) {
                              SAFE_BLOCK_CALL(success, resultInfo);
                           }else{
                               ILoginUserModel *result = [ILoginUserModel objectWithDict:[resultInfo objectForKey:@"profile"]];
                               //记录最后一次登陆的手机号
                               SaveLoginMobile(result.mobile);
                               SAFE_BLOCK_CALL(success, result);
                           }
                           
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

// 上传平台，clientid
+ (void)updateclientID
{
    if ([[UserDefaults objectForKey:kBPushRequestChannelIdKey] length]&& ![UserDefaults boolForKey:kneedChannelId]) {
        [self reqestPostWithParams:@{@"platform":KPlatformType,@"clientid":[UserDefaults objectForKey:kBPushRequestChannelIdKey],@"version":XcodeAppVersion} Path:kUpdateclient Success:^(id resultInfo) {
            DLog(@"%@",resultInfo);
            [UserDefaults setBool:YES forKey:kneedChannelId];
        } Failed:^(NSError *error) {
        }];
    }
}

//退出登录
+ (void)logoutWithSuccess:(SuccessBlock)success
                   Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:nil
                          Path:kLogoutPath
                       Success:^(id resultInfo) {
                           DLog(@"logout ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success, resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

#pragma mark - 用户模块
//修改用户信息
+ (void)saveUserInfoWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:params
                          Path:kSaveUserInfoPath
                       Success:^(id resultInfo) {
                           DLog(@"saveUserInfo ---- %@",resultInfo);
                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//增加教育经历
+ (void)saveSchoolWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:params
                          Path:kSaveSchoolPath
                       Success:^(id resultInfo) {
                           DLog(@"saveSchool ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//删除教育经历
+ (void)deleteSchoolWithID:(NSNumber *)usid
                   Success:(SuccessBlock)success
                    Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"usid":usid};
    [self reqestPostWithParams:params
                          Path:kDeleteSchoolPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteSchool ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//增加工作经历
+ (void)saveCompanyWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed

{
    [self reqestPostWithParams:params
                          Path:kSaveCompanyPath
                       Success:^(id resultInfo) {
                           DLog(@"saveCompany ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];

}

//删除工作经历
+ (void)deleteCompanyWithID:(NSNumber *)ucid
                    Success:(SuccessBlock)success
                     Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"ucid":ucid};
    [self reqestPostWithParams:params
                          Path:kDeleteCompanyPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteCompany ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

// 取用户详细
+ (void)getUserDetailInfoWithUid:(NSNumber *)uid Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"uid":uid};
    [self reqestPostWithParams:params Path:kUserUrl(@"get") Success:^(id resultInfo) {
        SAFE_BLOCK_CALL(success,resultInfo);
    } Failed:^(NSError *error) {
        SAFE_BLOCK_CALL(failed, error);
    }];
}

//认证投资人
+ (void)investWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:params
                          Path:kInvestPath
                       Success:^(id resultInfo) {
                           DLog(@"invest ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取用户认证信息
+ (void)loadInvestorWithID:(NSNumber *)uid
                   Success:(SuccessBlock)success
                    Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"uid":uid};
    [self reqestPostWithParams:params
                          Path:kLoadInvestorPath
                       Success:^(id resultInfo) {
                           DLog(@"loadInvestor ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//修改用户密码
+ (void)changeUserPassWdWithOldpassword:(NSString *)oldpassword
                            Newpassword:(NSString *)newpassword
                                Success:(SuccessBlock)success
                                 Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"oldpassword":oldpassword
                             ,@"newpassword":newpassword};
    [self reqestPostWithParams:params
                          Path:kChangePassWDPath
                       Success:^(id resultInfo) {
                           DLog(@"changeUserPassWd ---- %@",resultInfo);
                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取投资人列表
+ (void)getInvestListWithParameterDic:(NSDictionary *)params
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:params
                          Path:kInvestorsListPath
                       Success:^(id resultInfo) {
                           DLog(@"getInvestList ---- %@",resultInfo);
                           NSArray *result = [InvestorUserM objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//修改用户头像
+ (void)changeUserAvatarWithAvatar:(NSString *)avatar
                           Success:(SuccessBlock)success
                            Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"avatar":avatar};
    [self reqestPostWithParams:params
                          Path:kChangeAvatarPath
                       Success:^(id resultInfo) {
                           DLog(@"changeUserAvatar ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//修改用户地理位置
+ (void)changeUserLocationWithLatitude:(NSString *)latitude
                            Longtitude:(NSString *)longtitude
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"latitude":latitude,
                             @"longtitude":longtitude};
    [self reqestPostWithParams:params
                          Path:kChangeLocationPath
                       Success:^(id resultInfo) {
                           DLog(@"changeUserLocation ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//查找用户信息
+ (void)searchUserWithKeyword:(NSString *)keyword
                         Page:(NSNumber *)page
                         Size:(NSNumber *)size
                      Success:(SuccessBlock)success
                       Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"keyword":keyword,
                             @"page":page,
                             @"size":size};
    [self reqestPostWithParams:params
                          Path:kSearchUserPath
                       Success:^(id resultInfo) {
                           DLog(@"searchUser ---- %@",resultInfo);
                           NSArray *result = [IBaseUserM objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

#pragma mark - 认证手机号码
//取验证码接口
+ (void)getUserMobileCodeWithMobile:(NSString *)mobile
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"mobile":mobile};
    [self reqestPostWithParams:params
                          Path:kMobileCodePath
                       Success:^(id resultInfo) {
                           DLog(@"getUserMobileCode ---- %@",resultInfo);
//                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//验证手机号码
+ (void)checkUserMobileCodeWithCode:(NSString *)code
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"code":code};
    [self reqestPostWithParams:params
                          Path:kCheckMobileCodePath
                       Success:^(id resultInfo) {
                           DLog(@"checkUserMobileCode ---- %@",resultInfo);
//                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}


#pragma mark - 动态Feed模块
//添加动态
+ (void)saveFeedWithParameterDic:(NSDictionary *)params
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:params
                          Path:kSaveFeedPath
                       Success:^(id resultInfo) {
                           DLog(@"saveFeed ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//删除动态
+ (void)deleteFeedWithID:(NSNumber *)fid
                 Success:(SuccessBlock)success
                  Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"fid":fid};
    [self reqestPostWithParams:params
                          Path:kDeleteFeedPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteFeed ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//评论动态
+ (void)commentFeedWithParams:(NSDictionary *)params
                  Success:(SuccessBlock)success
                   Failed:(FailedBlock)failed
{
//    NSDictionary *params = @{@"fid":fid,@"comment":comment,@"touid":touid};
    [self reqestPostWithParams:params
                          Path:kFeedCommentPath
                       Success:^(id resultInfo) {
                           DLog(@"commentFeed ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//删除动态评论评论
+ (void)deleteFeedCommentWithID:(NSNumber *)cid
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"cid":cid};
    [self reqestPostWithParams:params
                          Path:kDeleteFeedCommentPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteFeedComment ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//赞
+ (void)feedZanWithID:(NSNumber *)fid
              Success:(SuccessBlock)success
               Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"fid":fid};
    [self reqestPostWithParams:params
                          Path:kFeedZanPath
                       Success:^(id resultInfo) {
                           DLog(@"feedZan ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取消赞
+ (void)deleteFeedZanWithID:(NSNumber *)fid
                    Success:(SuccessBlock)success
                     Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"fid":fid};
    [self reqestPostWithParams:params
                          Path:kDeleteFeedZanPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteFeedZan ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//转推
+ (void)feedForwardWithID:(NSNumber *)fid
                  Success:(SuccessBlock)success
                   Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"fid":fid};
    [self reqestPostWithParams:params
                          Path:kFeedForwardPath
                       Success:^(id resultInfo) {
                           DLog(@"feedForward ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取消转推
+ (void)deleteFeedForwardWithID:(NSNumber *)fid
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"fid":fid};
    [self reqestPostWithParams:params
                          Path:kDeleteFeedForwardPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteFeedForward ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取创业圈动态列表
+ (void)getFeedListWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    
    // 有uid表示是某用户的动态 否则是创业圈
    NSString *path = kFeedListPath;
    if ([params objectForKey:@"uid"]) {
        path = kFeedUrl(@"userlist");
    }
    [self reqestPostWithParams:params
                          Path:path
                       Success:^(id resultInfo) {
                           DLog(@"getFeedList ---- %@",resultInfo);
                           NSArray *jsonarray = [NSArray arrayWithArray:resultInfo];
                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                               if (jsonarray.count) {
                                   BOOL isok = NO;
                                   if ([params objectForKey:@"start"]&&[[params objectForKey:@"start"] integerValue]==0) {
                                       isok = YES;
                                       [[WLDataDBTool sharedService] clearTable:KHomeDataTableName];
                                   }
                                   for (NSDictionary *dicJson in jsonarray) {
                                       if (isok) {
                                           [[WLDataDBTool sharedService] putObject:dicJson  withId:[dicJson objectForKey:@"fid"] intoTable:KHomeDataTableName];
                                       }
                                       [[WLDataDBTool sharedService] putObject:dicJson withId:[NSString stringWithFormat:@"%@",[dicJson objectForKey:@"fid"]] intoTable:KWLStutarDataTableName];
                                   }
                               }

                           
                           });
                        SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

// 取某一个用户的动态列表
+ (void)getFeedUserListParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:params
                          Path:kFeedUrl(@"userlist")
                       Success:^(id resultInfo) {
                           DLog(@"getFeedList ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取动态评论列表
+ (void)getFeedCommentListWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
//    NSDictionary *params = @{@"fid":fid,@"page":page,@"size":size};
    [self reqestPostWithParams:params
                          Path:kFeedListCommentPath
                       Success:^(id resultInfo) {
                           DLog(@"getFeedCommentList ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取赞的用户列表
+ (void)getFeedZanListWithID:(NSNumber *)fid
                        Page:(NSNumber *)page
                        Size:(NSNumber *)size
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"fid":fid,@"page":page,@"size":size};
    [self reqestPostWithParams:params
                          Path:kFeedListZanPath
                       Success:^(id resultInfo) {
                           DLog(@"getFeedZanList ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取转推的用户列表
+ (void)getFeedForwardListWithID:(NSNumber *)fid
                            Page:(NSNumber *)page
                            Size:(NSNumber *)size
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"fid":fid,@"page":page,@"size":size};
    [self reqestPostWithParams:params
                          Path:kFeedListForwardPath
                       Success:^(id resultInfo) {
                           DLog(@"getFeedForwardList ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取动态详情
+ (void)getFeedDetailInfoWithID:(NSNumber *)fid
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"fid":fid};
    [self reqestPostWithParams:params
                          Path:kFeedDetailInfoPath
                       Success:^(id resultInfo) {
                           DLog(@"getFeedDetailInfo ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//举报
+ (void)reportFeedWithID:(NSNumber *)fid
                 Success:(SuccessBlock)success
                  Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"fid":fid};
    [self reqestPostWithParams:params
                          Path:kFeedReportPath
                       Success:^(id resultInfo) {
                           DLog(@"reportFeed ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取最新动态数量
+ (void)getNewFeedCountsWithID:(NSNumber *)fid
                       Success:(SuccessBlock)success
                        Failed:(FailedBlock)failed;
{
    NSDictionary *params = @{@"fid":fid};
    [self reqestPostWithParams:params
                          Path:kFeedNewCountPath
                       Success:^(id resultInfo) {
                           DLog(@"getNewFeedCounts ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}


#pragma mark - 好友模块 friends
//取好友列表
+ (void)getFriendListWithID:(NSNumber *)uid
                    Success:(SuccessBlock)success
                     Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"uid":uid};
    [self reqestPostWithParams:params
                          Path:kFriendListPath
                       Success:^(id resultInfo) {
                           DLog(@"getFriendList ---- %@",resultInfo);
                           NSArray *result = [IBaseUserM objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//上传通讯录，获取系统好友列表
+ (void)uploadFriendWithPhonebooks:(NSArray *)phoneBooks
                           Success:(SuccessBlock)success
                            Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"data":phoneBooks};
    [self reqestPostWithParams:params
                          Path:kFriendUploadphonebookPath
                       Success:^(id resultInfo) {
                           DLog(@"uploadFriendWithPhonebooks ---- %@",resultInfo);
                           NSArray *result = [IBaseUserM objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取微信好友列表
+ (void)getFriendWXListWithSuccess:(SuccessBlock)success
                            Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:nil
                          Path:kFriendWXListPath
                       Success:^(id resultInfo) {
                           DLog(@"getFriendWXList ---- %@",resultInfo);
                           NSArray *result = [IBaseUserM objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//二度好友列表
+ (void)getFriend2ListWithID:(NSNumber *)uid
                        Page:(NSNumber *)page
                        Size:(NSNumber *)size
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"uid":uid,@"page":page,@"size":size};
    [self reqestPostWithParams:params
                          Path:kFriendList2Path
                       Success:^(id resultInfo) {
                           DLog(@"getFriend2List ---- %@",resultInfo);
                           IFriend2Model *result = [IFriend2Model objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取共同好友
+ (void)getSameFriendListWithID:(NSNumber *)uid
                           Page:(NSNumber *)page
                           Size:(NSNumber *)size
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"uid":uid,@"page":page,@"size":size};
    [self reqestPostWithParams:params
                          Path:kFriendSamelistPath
                       Success:^(id resultInfo) {
                           DLog(@"getSameFriendList ---- %@",resultInfo);
//                           NSArray *result = [IBaseUserM objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//请求添加好友
+ (void)requestAddFriendWithID:(NSNumber *)uid
                       Message:(NSString *)message
                       Success:(SuccessBlock)success
                        Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"uid":uid,@"message":(message ? : @"")};
    [self reqestPostWithParams:params
                          Path:kFriendRequestPath
                       Success:^(id resultInfo) {
                           DLog(@"requestAddFriend ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//确认添加好友
+ (void)confirmAddFriendWithID:(NSNumber *)uid
                       Success:(SuccessBlock)success
                        Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"uid":uid};
    [self reqestPostWithParams:params
                          Path:kFriendConfirmPath
                       Success:^(id resultInfo) {
                           DLog(@"confirmAddFriend ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//删除好友
+ (void)deleteFriendWithID:(NSNumber *)uid
                   Success:(SuccessBlock)success
                    Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"uid":uid};
    [self reqestPostWithParams:params
                          Path:kDeleteFriendPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteFriend ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//邀请微信好友
+ (void)inviteFriendWithWXId:(NSNumber *)wxid
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"wxid":wxid};
    [self reqestPostWithParams:params
                          Path:kInviteWXFriendPath
                       Success:^(id resultInfo) {
                           DLog(@"inviteFriend ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//上传通讯录，获取好友关系，包括微信好友
+ (void)uploadFriendWithPhonebookRelation:(NSArray *)phoneBooks
                                  Success:(SuccessBlock)success
                                   Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"data":phoneBooks};
    [self reqestPostWithParams:params
                          Path:kFriendPhonebookRelationPath
                       Success:^(id resultInfo) {
                           DLog(@"uploadFriendPhonebookRelation ---- %@",resultInfo);
                           NSArray *result = [FriendsAddressBook objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}


#pragma mark - 项目 project 模块
//检测项目是否同名存在
+ (void)checkProjectWithName:(NSString *)name
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"name":name};
    [self reqestPostWithParams:params
                          Path:kCheckProjectPath
                       Success:^(id resultInfo) {
                           DLog(@"checkProject ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取我收藏的项目列表
+ (void)getProjectFavoriteListWithPage:(NSNumber *)page
                                  Size:(NSNumber *)size
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"page":page,@"size":size};
    [self reqestPostWithParams:params
                          Path:kProjectFavoriteListPath
                       Success:^(id resultInfo) {
                           DLog(@"getProjectFavoriteList ---- %@",resultInfo);
                           NSArray *result = [IProjectInfo objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取项目列表
+ (void)getProjectListWithUid:(NSNumber *)uid
                         Page:(NSNumber *)page
                         Size:(NSNumber *)size
                      Success:(SuccessBlock)success
                       Failed:(FailedBlock)failed
{
    //大于零取某个用户的，-1取自己的，不传或者0取全部
    NSDictionary *params = @{@"uid":uid,@"page":page,@"size":size};
    [self reqestPostWithParams:params
                          Path:kProjectListPath
                       Success:^(id resultInfo) {
                           DLog(@"getProjectList ---- %@",resultInfo);
                           NSArray *result = [IProjectInfo objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取项目详情
+ (void)getProjectDetailInfoWithID:(NSNumber *)pid
                           Success:(SuccessBlock)success
                            Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"pid":pid};
    [self reqestPostWithParams:params
                          Path:kProjectDetailInfoPath
                       Success:^(id resultInfo) {
                           DLog(@"getProjectDetailInfo ---- %@",resultInfo);
                           IProjectDetailInfo *result = [IProjectDetailInfo objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//添加项目，修改
+ (void)saveProjectWithParameterDic:(NSDictionary *)params
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:params
                          Path:kSaveProjectPath
                       Success:^(id resultInfo) {
                           DLog(@"saveProject ---- %@",resultInfo);
                           IProjectDetailInfo *result = [IProjectDetailInfo objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//添加项目成员
+ (void)saveProjectMembersWithParameterDic:(NSDictionary *)params
                                   Success:(SuccessBlock)success
                                    Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:params
                          Path:kSaveProjectMembersPath
                       Success:^(id resultInfo) {
                           DLog(@"saveProjectMembers ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//删除项目成员
+ (void)deleteProjectMembersWithUid:(NSNumber *)uid
                                Pid:(NSNumber *)pid
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"uid":uid,@"pid":pid};
    [self reqestPostWithParams:params
                          Path:kDeleteProjectMembersPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteProjectMembers ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取项目成员
+ (void)getProjectMembersWithPid:(NSNumber *)pid
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"pid":pid};
    [self reqestPostWithParams:params
                          Path:kProjectMembersPath
                       Success:^(id resultInfo) {
                           DLog(@"getProjectMembers ---- %@",resultInfo);
                           NSArray *result = [IBaseUserM objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//项目 赞
+ (void)zanProjectWithPid:(NSNumber *)pid
                  Success:(SuccessBlock)success
                   Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"pid":pid};
    [self reqestPostWithParams:params
                          Path:kProjectZanPath
                       Success:^(id resultInfo) {
                           DLog(@"zanProject ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//项目 评论
+ (void)commentProjectWithParameterDic:(NSDictionary *)params
                               Success:(SuccessBlock)success
                                Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:params
                          Path:kProjectCommentPath
                       Success:^(id resultInfo) {
                           DLog(@"commentProject ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取赞的用户列表
+ (void)getProjectZanListWithPid:(NSNumber *)pid
                            Page:(NSNumber *)page
                            Size:(NSNumber *)size
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"pid":pid,
                             @"page":page,
                             @"size":size};
    [self reqestPostWithParams:params
                          Path:kProjectZanListPath
                       Success:^(id resultInfo) {
                           DLog(@"getProjectZanList ---- %@",resultInfo);
                           NSArray *result = [IBaseUserM objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取评论列表
+ (void)getProjectCommentListWithPid:(NSNumber *)pid
                                Page:(NSNumber *)page
                                Size:(NSNumber *)size
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"pid":pid,
                             @"page":page,
                             @"size":size};
    [self reqestPostWithParams:params
                          Path:kProjectCommentListPath
                       Success:^(id resultInfo) {
                           DLog(@"getProjectCommentList ---- %@",resultInfo);
                           NSArray *result = [CommentMode objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//删除项目赞
+ (void)deleteProjectZanWithPid:(NSNumber *)pid
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"pid":pid};
    [self reqestPostWithParams:params
                          Path:kDeleteProjectZanPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteProjectZan ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//删除项目评论
+ (void)deleteProjectCommentWithCid:(NSNumber *)cid
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"cid":cid};
    [self reqestPostWithParams:params
                          Path:kDeleteProjectCommentPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteProjectComment ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//删除项目图片
+ (void)deleteProjectPhotoWithPhotoid:(NSNumber *)photoid
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"photoid":photoid};
    [self reqestPostWithParams:params
                          Path:kDeleteProjectPhotoPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteProjectPhoto ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//添加项目图片
+ (void)saveProjectPhotoWithParameterDic:(NSDictionary *)params
                                 Success:(SuccessBlock)success
                                  Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:params
                          Path:kSaveProjectPhotoPath
                       Success:^(id resultInfo) {
                           DLog(@"saveProjectPhoto ---- %@",resultInfo);
                           NSArray *result = [IPhotoInfo objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//项目 收藏
+ (void)favoriteProjectWithPid:(NSNumber *)pid
                       Success:(SuccessBlock)success
                        Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"pid":pid};
    [self reqestPostWithParams:params
                          Path:kProjectFavoritePath
                       Success:^(id resultInfo) {
                           DLog(@"favoriteProject ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取消收藏
+ (void)deleteProjectFavoriteWithPid:(NSNumber *)pid
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"pid":pid};
    [self reqestPostWithParams:params
                          Path:kDeleteProjectFavoritePath
                       Success:^(id resultInfo) {
                           DLog(@"deleteProjectFavorite ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//删除项目
+ (void)deleteProjectWithPid:(NSNumber *)pid
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"pid":pid};
    [self reqestPostWithParams:params
                          Path:kDeleteProjectPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteProject ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}


#pragma mark - 活动 active 模块
//取活动列表
+ (void)getActiveListWithDate:(NSNumber *)date      //-1 全部，0今天，1明天，7最近一周，-2 周末
                       Cityid:(NSNumber *)cityid    //0 全国
                         Page:(NSNumber *)page
                         Size:(NSNumber *)size
                      Success:(SuccessBlock)success
                       Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"date":date,      //-1 全部，0今天，1明天，7最近一周，-2 周末
                             @"cityid":cityid,  //0 全国
                             @"page":page,
                             @"size":size};
    [self reqestPostWithParams:params
                          Path:kActiveListPath
                       Success:^(id resultInfo) {
                           DLog(@"getActiveList ---- %@",resultInfo);
                           NSArray *result = [IActivityInfo objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取活动详情
+ (void)getActiveDetailInfoWithID:(NSNumber *)activeid
                          Success:(SuccessBlock)success
                           Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"activeid":activeid};
    [self reqestPostWithParams:params
                          Path:kActiveDetailInfoPath
                       Success:^(id resultInfo) {
                           DLog(@"getActiveDetailInfo ---- %@",resultInfo);
                           IActivityInfo *result = [IActivityInfo objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//已报名用户列表
+ (void)getActiveRecordersWithID:(NSNumber *)activeid
                            Page:(NSNumber *)page
                            Size:(NSNumber *)size
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"activeid":activeid,
                             @"page":page,
                             @"size":size};
    [self reqestPostWithParams:params
                          Path:kActiveRecordersPath
                       Success:^(id resultInfo) {
                           DLog(@"getActiveRecorders ---- %@",resultInfo);
                           NSArray *result = [IBaseUserM objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取票务信息
+ (void)getActiveTicketsWithID:(NSNumber *)activeid
                       Success:(SuccessBlock)success
                        Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"activeid":activeid};
    [self reqestPostWithParams:params
                          Path:kActiveTicketsPath
                       Success:^(id resultInfo) {
                           DLog(@"getActiveTickets ---- %@",resultInfo);
                           NSArray *result = [IActivityTicket objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//收藏活动
+ (void)favoriteActiveWithID:(NSNumber *)activeid
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"activeid":activeid};
    [self reqestPostWithParams:params
                          Path:kActiveFavoritePath
                       Success:^(id resultInfo) {
                           DLog(@"favoriteActive ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取消收藏
+ (void)deleteActiveFavoriteWithID:(NSNumber *)activeid
                           Success:(SuccessBlock)success
                            Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"activeid":activeid};
    [self reqestPostWithParams:params
                          Path:kDeleteActiveFavoritePath
                       Success:^(id resultInfo) {
                           DLog(@"deleteActiveFavorite ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取用户相关活动
+ (void)getActiveUserActivesWithType:(NSNumber *)type   ////1 收藏，2参加的
                                Page:(NSNumber *)page
                                Size:(NSNumber *)size
                             Success:(SuccessBlock)success
                              Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"type":type,  ///1 收藏，2参加的
                             @"page":page,
                             @"size":size};
    [self reqestPostWithParams:params
                          Path:kActiveUserActivesPath
                       Success:^(id resultInfo) {
                           DLog(@"getActiveUserActives ---- %@",resultInfo);
                           NSArray *result = [IActivityInfo objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//报名，购票
+ (void)orderActiveWithID:(NSNumber *)activeid
                  Tickets:(NSArray *)tickets
                  Success:(SuccessBlock)success
                   Failed:(FailedBlock)failed
{
    NSDictionary *params = [NSDictionary dictionary];
    if (tickets.count > 0) {
        //1：收费
        params = @{@"activeid":activeid,
                   @"tickets":tickets};
    }else{
        //0:免费
        params = @{@"activeid":activeid};
    }

    [self reqestPostWithParams:params
                          Path:kActiveOrderPath
                       Success:^(id resultInfo) {
                           DLog(@"orderActive ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//修改订单状态
+ (void)updateActiveOrderStatusWithID:(NSString *)orderid
                              Success:(SuccessBlock)success
                               Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"orderid":orderid};
    [self reqestPostWithParams:params
                          Path:kActiveOrderStatusPath
                       Success:^(id resultInfo) {
                           DLog(@"updateActiveOrderStatus ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取消报名
+ (void)deleteActiveRecordWithID:(NSNumber *)activeid
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"activeid":activeid};
    [self reqestPostWithParams:params
                          Path:kDeleteActiveRecordPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteActiveRecord ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取已经购买的票
+ (void)getActiveBuyedTicketsWithID:(NSNumber *)activeid
                            Success:(SuccessBlock)success
                             Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"activeid":activeid};
    [self reqestPostWithParams:params
                          Path:kActiveBuyedTicketsPath
                       Success:^(id resultInfo) {
                           DLog(@"getActiveBuyedTickets ---- %@",resultInfo);
                           NSArray *result = [IActivityTicket objectsWithInfo:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取活动城市列表
+ (void)getActiveCitiesSuccess:(SuccessBlock)success
                        Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:nil
                          Path:kActiveCitiesPath
                       Success:^(id resultInfo) {
                           DLog(@"getActiveCities ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}


#pragma mark - 系统模块
//版本更新检测
+ (void)checkUpdateWithPlatform:(NSString *)platform
                        Version:(NSString *)version
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"platform":platform,  //ios,ios-app,android
                             @"version":version};   //,必须三位
    [self reqestPostWithParams:params
                          Path:kCheckUpdatePath
                       Success:^(id resultInfo) {
                           DLog(@"checkUpdate ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//获取城市列表
+ (void)getAllCityListWithSuccess:(SuccessBlock)success
                           Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:nil
                          Path:kAllCityListPath
                       Success:^(id resultInfo) {
                           DLog(@"getAllCityList ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取行业列表
+ (void)getAllIndustryListWithSuccess:(SuccessBlock)success
                               Failed:(FailedBlock)failed
{
    [self reqestPostWithParams:nil
                          Path:kAllIndustryListPath
                       Success:^(id resultInfo) {
                           DLog(@"getAllIndustryList ---- %@",resultInfo);
                           //保存到本地数据库
                           [[WLDataDBTool sharedService] putObject:resultInfo withId:KInvestIndustryTableName intoTable:KInvestIndustryTableName];
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//搜索学校
+ (void)searchSchoolWithKeyword:(NSString *)keyword
                        Success:(SuccessBlock)success
                         Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"keyword":keyword};
    [self reqestPostWithParams:params
                          Path:kSearchSchoolPath
                       Success:^(id resultInfo) {
                           DLog(@"searchSchool ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//搜索公司
+ (void)searchCompanyWithKeyword:(NSString *)keyword
                         Success:(SuccessBlock)success
                          Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"keyword":keyword};
    [self reqestPostWithParams:params
                          Path:kSearchCompanyPath
                       Success:^(id resultInfo) {
                           DLog(@"searchCompany ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//搜索职位
+ (void)searchPositionWithKeyword:(NSString *)keyword
                          Success:(SuccessBlock)success
                           Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"keyword":keyword};
    [self reqestPostWithParams:params
                          Path:kSearchPositionPath
                       Success:^(id resultInfo) {
                           DLog(@"searchPosition ---- %@",resultInfo);
                           SAFE_BLOCK_CALL(success,resultInfo);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}






#pragma mark - Other  自定义接口
//下载图片
+ (void)downLoadImageWithMemberId:(NSMutableDictionary *)photos
                         ToFolder:(NSString *)toFolder
                          success:(SuccessBlock)success
                           failed:(FailedBlock)failed
{
    if (photos.allKeys.count == 0) {
        SAFE_BLOCK_CALL(success, nil);
        return ;
    }
    
    NSString *folder = [[ResManager userResourcePath] stringByAppendingPathComponent:toFolder];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folder]) {
        DLog(@"创建home cover 目录!");
        [[NSFileManager defaultManager] createDirectoryAtPath:folder
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    NSEnumerator *localFilesEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:folder];
    NSString *localFile;
    while (localFile = [localFilesEnumerator nextObject]) {
        if ([localFile pathExtension].length == 0) {
            continue;
        }
        NSDictionary *remoteFile = [photos objectForKey:localFile];
        if (remoteFile) {
            //如果本地存在同名文件删除
            [[NSFileManager defaultManager] removeItemAtPath:[folder stringByAppendingPathComponent:localFile]
                                                       error:nil];
        } else {
            //            [photos removeObjectForKey:localFile];
        }
    }
    // begin download
    NSInteger totalCount = photos.allKeys.count;
    __block int count = 0;
    for (NSString *key in photos) {
        NSString *path = [folder stringByAppendingPathComponent:key];
        
        NSURL *url = [NSURL URLWithString:[photos objectForKey:key]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            //把文件写入本地
            [operation.responseData writeToFile:path atomically:YES];
            
            count++;
            DLog(@"Download success");
            if (count == totalCount) {
                SAFE_BLOCK_CALL(success, nil);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            count++;
            DLog(@"Download failed:%@", error);
            SAFE_BLOCK_CALL(failed, error);
//            if (count == totalCount) {
//                SAFE_BLOCK_CALL(success, nil);
//            }else{
//                SAFE_BLOCK_CALL(failed, error);
//            }
        }];
        
        [operation start];
    }
}

#pragma mark - 上传图片
//  type : avatar 头像, feed 动态,investor 投资人名片,project 项目
//  FeedID : 只有动态才有 每个动态的唯一标示
- (void)uploadImageWithImageData:(NSArray *)imageDataArray Type:(NSString *)type FeedID:(NSString *)feedID Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
    //设置sessionid
    NSString *sessid = [UserDefaults objectForKey:kSessionId];
    
    NSString *pathInfo = @"upload/index";
    if (imageDataArray.count > 1) {
        pathInfo = @"upload/indexs";
    }
    if (sessid.length) {
        pathInfo = [NSString stringWithFormat:@"%@?sessionid=%@",pathInfo,sessid];
    }
    NSString *fileName = @"file.jpg";
    if (feedID) {
        fileName = [NSString stringWithFormat:@"%@.jpg",feedID];
    }

    [[self getOperationQ] addOperationWithBlock:^{
        [[WeLianClient sharedClient] POST:pathInfo parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //  type : avatar 头像, feed 动态,investor 投资人名片,project 项目
            [formData appendPartWithFormData:[type dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
            for (NSData *imageData in imageDataArray) {
                //参数
                [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpg"];
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            DLog(@"reqest Result ---- %@",[operation responseString]);
            IBaseModel *result = [IBaseModel objectWithDict:responseObject];
            //如果sessionid有的话放入data
            if (result.isSuccess) {
                if (result.sessionid.length > 0) {
                    //保存session
                    [UserDefaults setObject:result.sessionid forKey:kSessionId];
                }
                SAFE_BLOCK_CALL(success, result.data);
            }else{
                if (result.state.integerValue > 1000 && result.state.integerValue < 2000) {
                    //可以提醒的错误
                    SAFE_BLOCK_CALL(failed, result.error);
                }else if(result.state.integerValue >= 2000 && result.state.integerValue < 3000){
                    //系统级错误，直接打印错误信息
                    DLog(@"Result System ErroInfo-- : %@",result.errormsg);
                    SAFE_BLOCK_CALL(failed, nil);
                }else if(result.state.integerValue>=3000){
                    //打印错误信息 ，返回操作
                    DLog(@"Result ErroInfo-- : %@",result.errormsg);
                    SAFE_BLOCK_CALL(success, result.data);
                }else{
                    DLog(@"Result ErroInfo-- : %@",result.errormsg);
                    SAFE_BLOCK_CALL(failed, nil);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"Failure: %@", error);
            SAFE_BLOCK_CALL(failed, nil);
        }];
    }];

    

}



@end
