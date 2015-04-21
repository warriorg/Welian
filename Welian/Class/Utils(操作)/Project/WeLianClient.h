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
+ (void)wxRegisterWithName:(NSString *)name
                  Nickname:(NSString *)nickname
                    Mobile:(NSString *)mobile
                   Company:(NSString *)company
                  Position:(NSString *)position
                    Avatar:(NSString *)avatar
                  Platform:(NSString *)platform
                    Openid:(NSString *)openid
                   Unionid:(NSString *)unionid
                  Clientid:(NSString *)clientid
                   Success:(SuccessBlock)success
                    Failed:(FailedBlock)failed;

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
+ (void)loginWithMobile:(NSString *)mobile
                Unionid:(NSString *)unionid
               Password:(NSString *)password
                Success:(SuccessBlock)success
                 Failed:(FailedBlock)failed;


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
                      Failed:(FailedBlock)failed;

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
                  Failed:(FailedBlock)failed;

//删除教育经历
+ (void)deleteSchoolWithID:(NSNumber *)usid
                   Success:(SuccessBlock)success
                    Failed:(FailedBlock)failed;

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
                   Failed:(FailedBlock)failed;

//删除工作经历
+ (void)deleteCompanyWithID:(NSString *)ucid
                    Success:(SuccessBlock)success
                     Failed:(FailedBlock)failed;

//认证投资人
+ (void)investWithPhoto:(NSString *)photo
              Industrys:(NSArray *)industrys
                 Stages:(NSArray *)stages
                  Items:(NSArray *)items
                Success:(SuccessBlock)success
                 Failed:(FailedBlock)failed;

//取用户认证信息
+ (void)loadInvestorWithID:(NSString *)uid
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






//下载图片
+ (void)downLoadImageWithMemberId:(NSMutableDictionary *)photos
                         ToFolder:(NSString *)toFolder
                          success:(SuccessBlock)success
                           failed:(FailedBlock)failed;



@end
