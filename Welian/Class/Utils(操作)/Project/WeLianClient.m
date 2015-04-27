//
//  WeLianClient.m
//  Welian
//
//  Created by weLian on 15/4/21.
//  Copyright (c) 2015年 chuansongmen. All rights reserved.
//

#import "WeLianClient.h"

@implementation WeLianClient

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        //设置传输为json格式
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        //设置sessionid
//        LogInUser *mode = [LogInUser getCurrentLoginUser];
//        NSString *sessid = mode.sessionid;
//        if (!sessid) {
//            sessid = [UserDefaults objectForKey:kSidkey];
//        }
//        if (!sessid) {
//            [[self operationQueue] cancelAllOperations];
//            return;
//        }
//        if (sessid) {
//            //header 里面放入sessionid
//            [self.requestSerializer setValue:sessid forHTTPHeaderField:@"sessionid"];
//        }
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

//post请求
+ (void)reqestPostWithParams:(NSDictionary *)params Path:(NSString *)path Success:(SuccessBlock)success
                            Failed:(FailedBlock)failed
{
    //设置sessionid
    LogInUser *mode = [LogInUser getCurrentLoginUser];
    NSString *sessid = mode.sessionid;
    if (!sessid) {
        sessid = [UserDefaults objectForKey:kSidkey];
    }
    
    NSString *pathInfo = path;
    if (sessid) {
        pathInfo = [NSString stringWithFormat:@"%@?sessionid=%@",path,sessid];
    }
    
    [[WeLianClient sharedClient] POST:pathInfo
                           parameters:params
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  DLog(@"reqest Result ---- %@",[operation responseString]);
                                  
                                  IBaseModel *result = [IBaseModel objectWithDict:responseObject];
                                  //如果sessionid有的话放入data
                                  NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithDictionary:result.data];
                                  
                                  if (result.isSuccess) {
                                      if (result.sessionid.length > 0) {
                                          [UserDefaults setObject:result.sessionid forKey:kSidkey];
//                                          [resultDict setObject:result.sessionid forKey:@"sessionid"];
                                      }
                                      
                                      SAFE_BLOCK_CALL(success, resultDict);
                                  }else{
                                      if (result.state.integerValue > 1000 && result.state.integerValue < 2000) {
                                          //可以提醒的错误
                                          SAFE_BLOCK_CALL(failed, result.error);
                                      }else if(result.state.integerValue >= 2000 && result.state.integerValue < 3000){
                                          //系统级错误，直接打印错误信息
                                          DLog(@"Result System ErroInfo-- : %@",result.errormsg);
                                      }else{
                                          //打印错误信息 ，返回操作
                                          DLog(@"Result ErroInfo-- : %@",result.errormsg);
                                          SAFE_BLOCK_CALL(success, resultDict);
                                      }
                                  }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                  SAFE_BLOCK_CALL(failed, error);
                                  //打印错误信息
                                  DLog(@"SystemErroInfo-- : %@",error.description);
                              }];
}

#pragma mark - 注册，登录
//微信注册
+ (void)wxRegisterWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
//    NSDictionary *params = @{@"name":name
//                             ,@"nickname":nickname
//                             ,@"mobile":mobile
//                             ,@"company":company
//                             ,@"position":position
//                             ,@"avatar":avatar
//                             ,@"platform":platform
//                             ,@"openid":openid
//                             ,@"unionid":unionid
//                             ,@"clientid":clientid};
    [self reqestPostWithParams:params
                          Path:kWXRegisterPath
                       Success:^(id resultInfo) {
                           DLog(@"wxRegister ---- %@",resultInfo);
                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
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
                Platform:(NSString *)platform
                Clientid:(NSString *)clientid
                 Success:(SuccessBlock)success
                  Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"name":name
                             ,@"mobile":mobile
                             ,@"company":company
                             ,@"position":position
                             ,@"avatar":avatar
                             ,@"platform":platform
                             ,@"password":password
                             ,@"clientid":clientid};
    [self reqestPostWithParams:params
                          Path:kRegisterPath
                       Success:^(id resultInfo) {
                           DLog(@"register ---- %@",resultInfo);
                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
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
//                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
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
                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
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
                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//登陆
+ (void)loginWithParameterDic:(NSDictionary *)params Success:(SuccessBlock)success Failed:(FailedBlock)failed
{
//    NSDictionary *params = @{@"mobile":mobile
//                             ,@"unionid":unionid
//                             ,@"password":password};
    [self reqestPostWithParams:@{@"unionid":@"fdsafdsfasdfdasfasdfsdfdseedsa"}
                          Path:kLoginPath
                       Success:^(id resultInfo) {
                           DLog(@"login ---- %@",resultInfo);
                           if ([resultInfo objectForKey:@"flag"]) {
                               SAFE_BLOCK_CALL(success, resultInfo);
                           }else{
                               ILoginUserModel *result = [ILoginUserModel objectWithDict:resultInfo];
                               //记录最后一次登陆的手机号
                               SaveLoginMobile(result.mobile);
                               SAFE_BLOCK_CALL(success, result);
                           }
                           
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}


#pragma mark - 用户模块
//修改用户信息
+ (void)saveUserInfoWithName:(NSString *)name
                      Mobile:(NSString *)mobile
                     Company:(NSString *)company
                    Position:(NSString *)position
                      Avatar:(NSString *)avatar
                      Cityid:(NSString *)cityid
                    Latitude:(NSString *)latitude
                  Langtitude:(NSString *)langtitude
                     Address:(NSString *)address
                       Email:(NSString *)email
                     Success:(SuccessBlock)success
                      Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"name":name
                             ,@"mobile":mobile
                             ,@"company":company
                             ,@"position":position
                             ,@"avatar":avatar
                             ,@"cityid":cityid
                             ,@"latitude":latitude
                             ,@"langtitude":langtitude
                             ,@"address":address
                             ,@"email":email};
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
+ (void)saveSchoolWithID:(NSNumber *)usid
                Schoolid:(NSNumber *)schoolid
              Schoolname:(NSString *)schoolname
             Specialtyid:(NSNumber *)specialtyid
               Startyear:(NSNumber *)startyear
              Startmonth:(NSNumber *)startmonth
                 Endyear:(NSNumber *)endyear
                Endmonth:(NSNumber *)endmonth
                 Success:(SuccessBlock)success
                  Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"usid":usid ? : @""
                             ,@"schoolid":schoolid ? : @""
                             ,@"schoolname":schoolname
                             ,@"specialtyid":specialtyid ? : @""
                             ,@"startyear":startyear
                             ,@"startmonth":startmonth
                             ,@"endyear":endyear
                             ,@"endmonth":endmonth};
    [self reqestPostWithParams:params
                          Path:kSaveSchoolPath
                       Success:^(id resultInfo) {
                           DLog(@"saveSchool ---- %@",resultInfo);
//                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
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
                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//增加工作经历
+ (void)saveCompanyWithID:(NSString *)ucid
                Companyid:(NSString *)companyid
              Companyname:(NSString *)companyname
               Positionid:(NSString *)positionid
                Startyear:(NSString *)startyear
               Startmonth:(NSString *)startmonth
                  Endyear:(NSString *)endyear
                 Endmonth:(NSString *)endmonth
                  Success:(SuccessBlock)success
                   Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"ucid":ucid
                             ,@"companyid":companyid
                             ,@"companyname":companyname
                             ,@"positionid":positionid
                             ,@"startyear":startyear
                             ,@"startmonth":startmonth
                             ,@"endyear":endyear
                             ,@"endmonth":endmonth};
    [self reqestPostWithParams:params
                          Path:kSaveCompanyPath
                       Success:^(id resultInfo) {
                           DLog(@"saveCompany ---- %@",resultInfo);
                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];

}

//删除工作经历
+ (void)deleteCompanyWithID:(NSString *)ucid
                    Success:(SuccessBlock)success
                     Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"ucid":ucid};
    [self reqestPostWithParams:params
                          Path:kDeleteCompanyPath
                       Success:^(id resultInfo) {
                           DLog(@"deleteCompany ---- %@",resultInfo);
                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//认证投资人
+ (void)investWithPhoto:(NSString *)photo
              Industrys:(NSArray *)industrys
                 Stages:(NSArray *)stages
                  Items:(NSArray *)items
                Success:(SuccessBlock)success
                 Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"photo":photo
                             ,@"industrys":industrys
                             ,@"stages":stages
                             ,@"items":items};
    [self reqestPostWithParams:params
                          Path:kInvestPath
                       Success:^(id resultInfo) {
                           DLog(@"invest ---- %@",resultInfo);
                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}

//取用户认证信息
+ (void)loadInvestorWithID:(NSString *)uid
                   Success:(SuccessBlock)success
                    Failed:(FailedBlock)failed
{
    NSDictionary *params = @{@"uid":uid};
    [self reqestPostWithParams:params
                          Path:kLoadInvestorPath
                       Success:^(id resultInfo) {
                           DLog(@"loadInvestor ---- %@",resultInfo);
                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
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
                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
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
                           IBaseModel *result = [IBaseModel objectWithDict:resultInfo];
                           SAFE_BLOCK_CALL(success,result);
                       } Failed:^(NSError *error) {
                           SAFE_BLOCK_CALL(failed, error);
                       }];
}









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
    int totalCount = photos.allKeys.count;
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


@end
