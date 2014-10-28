//
//  LogInController.m
//  Welian
//
//  Created by dong on 14-9-10.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "LogInController.h"
#import "UIImage+ImageEffects.h"
#import "UserInfoController.h"
#import "NavViewController.h"
#import "NSString+val.h"
#import "MainViewController.h"
#import "CodeNumberView.h"
#import "ForgetAlertView.h"
#import "ForgetCodeAlertView.h"
#import "LoginAlertView.h"
#import "SigninAlertView.h"
#import "MJExtension.h"

//#define KTimes 20;

@interface LogInController ()
//{
//    __block int timeout;
//    dispatch_source_t _timer;
//}
//@property (nonatomic, strong) loginView *trendView;
//@property (nonatomic, strong) UIImageView *bgblurImage;
//@property (nonatomic, strong) AuthCodeView *verificationView;
//@property (nonatomic, strong)  UIButton *backBut;

@end

@implementation LogInController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setbuttonimage];
}

- (void)setbuttonimage
{
    [self.signInButton setBackgroundImage:[UIImage resizedImage:@"login_btn.png"] forState:UIControlStateNormal];
    [self.signInButton setBackgroundImage:[UIImage resizedImage:@"login_btn_pre"] forState:UIControlStateHighlighted];
    [self.LogInButtoon setBackgroundImage:[UIImage resizedImage:@"login_btn.png"] forState:UIControlStateNormal];
    [self.LogInButtoon setBackgroundImage:[UIImage resizedImage:@"login_btn_pre"] forState:UIControlStateHighlighted];
}


/**
 *  注册
 *
 *  @param sender
 */
- (IBAction)signInClick:(UIButton *)sender {
    SigninAlertView *signinView = [[SigninAlertView alloc] init];
    [signinView show];
    signinView.rightBlock = ^(NSString *phoneStr){
        [WLHttpTool getCheckCodeParameterDic:@{@"type":@"register",@"mobile":phoneStr,@"platform":@"ios",@"clientid":[UserDefaults objectForKey:BPushRequestChannelIdKey],@"baiduuid":[UserDefaults objectForKey:BPushRequestUserIdKey]} success:^(id JSON) {
            
            UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
            [mode setMobile:phoneStr];
            [[UserInfoTool sharedUserInfoTool] saveUserInfo:mode];
            
            if ([[JSON objectForKey:@"flag"] integerValue]==0) {         // 未注册
                
                CodeNumberView *codeCodeView = [[CodeNumberView alloc] initWithPhoneNumber:phoneStr];
                [codeCodeView show];
                __weak CodeNumberView *codeWeak = codeCodeView;
                codeCodeView.rightBlock = ^(NSString *codeStr){
                    if ([codeWeak.nextBtn.titleLabel.text isEqualToString:@"重新发送"]) {
                        [self chongxingfasong:phoneStr];
                        return ;
                    }
                    
                    if ([[JSON objectForKey:@"checkcode"] isEqualToString:codeStr]) {
                        [WLHttpTool checkCodeParameterDic:@{@"code":codeStr} success:^(id JSON) {
                            if ([[JSON objectForKey:@"flag"] integerValue]==0) {
                                
                                UserInfoController *userInfoVC = [[UserInfoController alloc] init];
                                [self.view.window setRootViewController:[[NavViewController alloc] initWithRootViewController:userInfoVC]];
                                
                            }else if([[JSON objectForKey:@"flag"] integerValue]==1){
                                [WLHUDView showErrorHUD:@"验证失败！"];
                            }
                        } fail:^(NSError *error) {
                            
                        }];
                    }else{
                        [WLHUDView showErrorHUD:@"验证码错误！"];
                    }
                };
                
            }else if([[JSON objectForKey:@"flag"] integerValue]==1){     // 已注册
                [WLHUDView showErrorHUD:@"该号码已注册，直接登陆！"];
                [self logInClick:self.LogInButtoon];
            }
        } fail:^(NSError *error) {
            
        }];
    };
    
}


// 注册重新发送验证码
- (void)chongxingfasong:(NSString *)phoneStr
{
    [WLHttpTool getCheckCodeParameterDic:@{@"type":@"register",@"mobile":phoneStr,@"platform":@"ios",@"clientid":[UserDefaults objectForKey:BPushRequestChannelIdKey],@"baiduuid":[UserDefaults objectForKey:BPushRequestUserIdKey]} success:^(id JSON) {
        if ([[JSON objectForKey:@"flag"] integerValue] == 0) {
            
        }else if ([[JSON objectForKey:@"flag"] integerValue]==1){
            [WLHUDView showErrorHUD:@"该号码已经注册，请直接登陆！"];
        }
    } fail:^(NSError *error) {
        
    }];
}


// 忘记密码重新发送验证码
- (void)forgetChongxingfasong:(NSString*)phoneStr
{
    [WLHttpTool getCheckCodeParameterDic:@{@"type":@"forgetPassword",@"mobile":phoneStr,@"platform":@"ios",@"clientid":[UserDefaults objectForKey:BPushRequestChannelIdKey],@"baiduuid":[UserDefaults objectForKey:BPushRequestUserIdKey]} success:^(id JSON) {
        if ([[JSON objectForKey:@"flag"] integerValue] == 1) {
        
        }else if ([[JSON objectForKey:@"flag"] integerValue]==0){
            [WLHUDView showErrorHUD:@"该号码未注册，请先注册！"];
        }
    } fail:^(NSError *error) {
        
    }];
}


/**
 *  登陆
 *
 *  @param sender
 */
- (IBAction)logInClick:(UIButton *)sender {
    LoginAlertView *loginView = [[LoginAlertView alloc] init];
    [loginView show];
    
    //  登陆
    loginView.rightBlock = ^(NSString *phoneStr,NSString *passwordStr){
        
        [WLHttpTool loginParameterDic:@{@"mobile":phoneStr,@"password":passwordStr,@"platform":@"ios",@"clientid":[UserDefaults objectForKey:BPushRequestChannelIdKey]?[UserDefaults objectForKey:BPushRequestChannelIdKey]:@"",@"baiduuid":[UserDefaults objectForKey:BPushRequestUserIdKey]?[UserDefaults objectForKey:BPushRequestUserIdKey]:@""} success:^(id JSON) {
            NSDictionary *dataDic = JSON;
            if (dataDic) {
                UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
                [mode setKeyValues:dataDic];
                [[UserInfoTool sharedUserInfoTool] saveUserInfo:mode];
                MainViewController *mainVC = [[MainViewController alloc] init];
                [[UIApplication sharedApplication].keyWindow setRootViewController:mainVC];
            }
        } fail:^(NSError *error) {
            
        }];
        
    };
    
    // 忘记密码
    loginView.leftBlock = ^(){
        ForgetAlertView *forgetView = [[ForgetAlertView alloc] initWithDeputStr:@"请输入你的手机号码" andTextFidePlesh:@"手机号码"];
        [forgetView show];
        forgetView.rightBlock = ^(NSString *phoneStr){   // 获取验证码
            [WLHttpTool getCheckCodeParameterDic:@{@"type":@"forgetPassword",@"mobile":phoneStr,@"platform":@"ios",@"clientid":[UserDefaults objectForKey:BPushRequestChannelIdKey],@"baiduuid":[UserDefaults objectForKey:BPushRequestUserIdKey]} success:^(id JSON) {
                NSDictionary *dicjson = JSON;
                if ([[dicjson objectForKey:@"flag"] integerValue] == 1) {
                    
                    ForgetCodeAlertView *forgetCodeView = [[ForgetCodeAlertView alloc] init];
                    [forgetCodeView show];
                    __weak ForgetCodeAlertView *forgetWeak = forgetCodeView;
                    forgetCodeView.rightBlock = ^(NSString *codeStr){  // 验证验证码
                        if ([forgetWeak.nextBtn.titleLabel.text isEqualToString:@"重新发送"]) {
                            [self forgetChongxingfasong:phoneStr];
                        }
                        if ([[dicjson objectForKey:@"checkcode"] isEqualToString:codeStr]) {
                            [WLHttpTool checkCodeParameterDic:@{@"code":codeStr} success:^(id JSON) {
                                if ([[JSON objectForKey:@"flag"] integerValue]==0) {
                                    
                                    ForgetAlertView *forgetPhoneView = [[ForgetAlertView alloc] initWithDeputStr:@"请重设你登陆密码" andTextFidePlesh:@"请设置6-18位字符为密码"];
                                    [forgetPhoneView show];
                                    forgetPhoneView.rightBlock = ^(NSString *passwordStr){
                                        [WLHttpTool forgetPasswordParameterDic:@{@"newpassword":passwordStr} success:^(id JSON) {
                                            
                                            if ([[JSON objectForKey:@"flag"] integerValue]==0) {
                                                [WLHUDView showSuccessHUD:@"密码修改成功！"];
                                                
                                                [self logInClick:self.LogInButtoon];
                                            }else{
                                                [WLHUDView showErrorHUD:@"密码修改失败！"];
                                            }
                                            
                                        } fail:^(NSError *error) {
                                            
                                        }];
                                    };
                                    
                                }else{
                                    [WLHUDView showErrorHUD:@"验证失败，请重试！"];
                                }
                                
                            } fail:^(NSError *error) {
                                
                            }];
                            
                        }else{
                            [WLHUDView showErrorHUD:@"验证码错误！"];
                        }
                    };

                }else{
                    [WLHUDView showErrorHUD:@"该号码未注册！"];
                }
                
            } fail:^(NSError *error) {
                
            }];
            
        };
    };
    
    
}



//- (AuthCodeView*)verificationView
//{
//    if (_verificationView == nil) {
//        _verificationView = [[[NSBundle mainBundle] loadNibNamed:@"AuthCodeView" owner:self options:nil] lastObject];
//        CGPoint cente = CGPointMake(self.view.center.x, -90);
//        [_verificationView setCenter:cente];
//        [self.view addSubview:_verificationView];
//        [_verificationView setHidden:YES];
//        [_verificationView.nextButton setEnabled:YES];
//        [_verificationView.nextButton addTarget:self action:@selector(setVerificationNmb:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    UserInfoModel *userM = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
//    
//    [_verificationView.tsLabel setText:[NSString stringWithFormat:@"我们已将验证码发至：%@ 请输入您收到的验证码",userM.mobile]];
//    return _verificationView;
//}
//
//- (loginView *)trendView
//{
//    if (nil== _trendView) {
//        
//        _trendView = [[[NSBundle mainBundle]loadNibNamed:@"loginView" owner:self options:nil] lastObject];
//        CGPoint cente = CGPointMake(self.view.center.x, -90);
//        [_trendView setCenter:cente];
//        [self.view addSubview:_trendView];
//        [_trendView setHidden:YES];
//        [_trendView.nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _trendView;
//}
//
//
//
//- (UIImageView *)bgblurImage
//{
//    if (nil == _bgblurImage) {
//        UIImage *background = [UIImage blurredSnapshot:self.view];
////        UIImage *background = [UIImage imageNamed:@"login_bg_big"];
//        _bgblurImage = [[UIImageView alloc] initWithImage:background];
//        [_bgblurImage setUserInteractionEnabled:YES];
//    
//        // 添加单击的手势
//        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
//        tapGestureRecognizer.numberOfTapsRequired = 1; // 设置单击几次才触发方法
//        [tapGestureRecognizer addTarget:self action:@selector(tapGestureAction:)]; // 添加点击手势的方法
//        [_bgblurImage addGestureRecognizer:tapGestureRecognizer];
//        [self.view addSubview:_bgblurImage];
//    }
//    return _bgblurImage;
//}
//
//- (UIButton*)backBut
//{
//    if (_backBut == nil) {
//        _backBut = [[UIButton alloc] initWithFrame:CGRectMake(20, 30, 50, 30)];
//        [_backBut setTitle:@"返回" forState:UIControlStateNormal];
////        [_backBut setBackgroundColor:[UIColor redColor]];
//        [_backBut addTarget:self action:@selector(hideVerificationViewShowTrendView) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:_backBut];
//        [_backBut setHidden:YES];
//    }
//    return _backBut;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // 设置按钮图片
//    [self setbuttonimage];
//    timeout = KTimes;
//    
//}
//
///**
// *  发送验证码
// */
//- (void)setVerificationNmb:(UIButton *)butt
//{
//    if ([butt.titleLabel.text isEqualToString:@"提交"]) {
//        UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
//        if ([mode.checkcode isEqualToString:self.verificationView.authTextF.text]) {
//            [WLHttpTool checkCodeParameterDic:@{@"mobile":mode.mobile,@"code":mode.checkcode} success:^(id JSON) {
//                if (JSON) {
//                UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
//                    if ([[JSON objectForKey:@"flag"] integerValue]==1) {  // 已注册
//                        
//                        [mode setName:[JSON objectForKey:@"name"]];
//                        [mode setCompany:[JSON objectForKey:@"company"]];
//                        [mode setMobile:[JSON objectForKey:@"mobile"]];
//                        [mode setPosition:[JSON objectForKey:@"position"]];
//                        [mode setUid:[JSON objectForKey:@"uid"]];
//                        [mode setSessionid:[JSON objectForKey:@"sessionid"]];
//                        [mode setAvatar:[JSON objectForKey:@"avatar"]];
//                        [mode setInvestorauth:[JSON objectForKey:@"investorauth"]];
//                        [mode setStartupauth:[JSON objectForKey:@"startupauth"]];
//                        [mode setEmail:[JSON objectForKey:@"email"]];
//                        [mode setShareurl:[JSON objectForKey:@"shareurl"]];
//                        [mode setAddress:[JSON objectForKey:@"address"]];
//                        [mode setProvinceid:[JSON objectForKey:@"provinceid"]];
//                        [mode setProvincename:[JSON objectForKey:@"provincename"]];
//                        [mode setCityid:[JSON objectForKey:@"cityid"]];
//                        [mode setCityname:[JSON objectForKey:@"cityname"]];
//                        [[UserInfoTool sharedUserInfoTool] saveUserInfo:mode];
//                        MainViewController *mainVC = [[MainViewController alloc] init];
//                        [self.view.window setRootViewController:mainVC];
//                    }else {
//                        [mode setSessionid:[JSON objectForKey:@"sessionid"]];
//                        UserInfoController *userInfoVC = [[UserInfoController alloc] init];
//                        [self.view.window setRootViewController:[[NavViewController alloc] initWithRootViewController:userInfoVC]];
//                    }
//                }
//            } fail:^(NSError *error) {
//                
//            }];
//        }else {
//            [[[UIAlertView alloc] initWithTitle:@"提示：验证码错误！" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil] show];
//            [butt setTitle:@"重新发送" forState:UIControlStateNormal];
//        }
//
//    }else if ([butt.titleLabel.text isEqualToString:@"重新发送"]){
//
//        timeout = KTimes;
//        [self startTime];
//    }
//    [self.verificationView.authTextF setText:nil];
//    [self.verificationView.authTextF.oneLabel setText:nil];
//    [self.verificationView.authTextF.twoLabel setText:nil];
//    [self.verificationView.authTextF.thirdLabel setText:nil];
//    [self.verificationView.authTextF.fourLabel setText:nil];
//    
//}
//
///**
// *  隐藏验证码view，显示电话号码view
// */
//- (void)hideVerificationViewShowTrendView
//{
//    [self.backBut setHidden:YES];
//    CGPoint cente = self.verificationView.center;
//    cente.y += 500;
////    [self.verificationView.phoneTextF resignFirstResponder];
//    [UIView animateWithDuration:0.4 animations:^{
//        [self.verificationView setCenter:cente];
//
//    } completion:^(BOOL finished) {
//        [self.verificationView setHidden:YES];
//        [self.verificationView setCenter:CGPointMake(self.view.center.x, -90)];
//        [self trendViewShow];
//        
//    }];
//}
//
//
///**
// *  隐藏验证码view
// */
//- (void)verificationViewHide
//{
//    [self.backBut setHidden:YES];
//    CGPoint cente = self.verificationView.center;
//    cente.y += 500;
////    [self.verificationView.phoneTextF resignFirstResponder];
//    [UIView animateWithDuration:0.4 animations:^{
//        [self.verificationView setCenter:cente];
//        [self.bgblurImage setHidden:YES];
//    } completion:^(BOOL finished) {
//        [self.verificationView setHidden:YES];
//        [self.verificationView setCenter:CGPointMake(self.view.center.x, -90)];
//    }];
//}
//
///**
// *  显示验证码输入
// */
//- (void)verificationViewshow
//{
//    [self.bgblurImage setHidden:NO];
//    [self.verificationView setHidden:NO];
//    [self.verificationView.authTextF becomeFirstResponder];
//    CGPoint cente = CGPointMake(self.view.center.x, -90);
//    cente.y += 250;
//    [self.view bringSubviewToFront:self.verificationView];
//    [UIView animateWithDuration:0.4 animations:^{
//        [self.verificationView setCenter:cente];
//
//    } completion:^(BOOL finished) {
//        //        [self.bgblurImage setUserInteractionEnabled:NO];
//        [self.backBut setHidden:NO];
//        [self.view bringSubviewToFront:self.backBut];
//    }];
//    
//    [self startTime];
//    
//}
//
///**
// *  隐藏手机号输入，显示验证码输入
// */
//- (void)nextClick
//{
//    if ([NSString phoneValidate:self.trendView.phoneTextF.text]) {
//        UserInfoModel *mode = [[UserInfoTool sharedUserInfoTool] getUserInfoModel];
//        
//        [mode setMobile:self.trendView.phoneTextF.text];
//        [[UserInfoTool sharedUserInfoTool] saveUserInfo:mode];
//        
//        CGPoint cente = self.trendView.center;
//        cente.y += 500;
//        [UIView animateWithDuration:0.4 animations:^{
//            [self.trendView setCenter:cente];
//        } completion:^(BOOL finished) {
//            [self.trendView setHidden:YES];
//            CGPoint cente = CGPointMake(self.view.center.x, -90);
//            [self.trendView setCenter:cente];
//            timeout = KTimes;
//            [self verificationViewshow];
//        }];
//    }else {
//        [_trendView.tsLabel setText:@"手机号码输入有误，请重新输入"];
//    }
//}
//
//
//
//
///**
// *  手势隐藏手机号输入view
// *
// *  @param tapges
// */
//- (void)tapGestureAction:(UITapGestureRecognizer *)tapges
//{
//    [self.view endEditing:YES];
//    if (!self.trendView.hidden) {
//        [self trendViewHide];
//    }
//    if (!self.verificationView.hidden) {
//        [self verificationViewHide];
//        
//    }
//}
//
///**
// *  显示手机号输入
// */
//- (void)trendViewShow
//{
//    [self.trendView.phoneTextF becomeFirstResponder];
//    [self.bgblurImage setHidden:NO];
////    [self.bgblurImage setUserInteractionEnabled:YES];
//    [self.trendView setHidden:NO];
//    CGPoint cente = CGPointMake(self.view.center.x, -90);
//    cente.y += 250;
//    [self.view bringSubviewToFront:self.trendView];
//    [UIView animateWithDuration:0.4 animations:^{
//        [self.trendView setCenter:cente];
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
///**
// *  隐藏手机号输入
// */
//- (void)trendViewHide
//{
//    CGPoint cente = self.trendView.center;
//    cente.y += 500;
//    [self.trendView.phoneTextF resignFirstResponder];
//    [UIView animateWithDuration:0.4 animations:^{
//        [self.trendView setCenter:cente];
//        [self.bgblurImage setHidden:YES];
//    } completion:^(BOOL finished) {
//        [self.trendView setHidden:YES];
//        CGPoint cente = CGPointMake(self.view.center.x, -90);
//        [self.trendView setCenter:cente];
//        
//    }];
//}
//
//
//- (void)setbuttonimage
//{
//    [self.signInButton setBackgroundImage:[UIImage resizedImage:@"login_btn.png"] forState:UIControlStateNormal];
//    [self.signInButton setBackgroundImage:[UIImage resizedImage:@"login_btn_pre"] forState:UIControlStateHighlighted];
//    [self.LogInButtoon setBackgroundImage:[UIImage resizedImage:@"login_btn.png"] forState:UIControlStateNormal];
//    [self.LogInButtoon setBackgroundImage:[UIImage resizedImage:@"login_btn_pre"] forState:UIControlStateHighlighted];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

//
//-(void)startTime{
//    
//    [WLHttpTool loginGetCheckCodeParameterDic:@{@"mobile":self.trendView.phoneTextF.text,@"platform":@"ios",@"clientid":@""} success:^(id JSON) {
//        
//    } fail:^(NSError *error) {
//        
//    }];
//    
//    if (timeout< 20)  {
//        return;
//    }else{
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//        
//        dispatch_source_set_event_handler(_timer, ^{
//            if (self.verificationView.authTextF.oneLabel.text.length) {
//                timeout = 0;
//            }
//            if(timeout<=0){ //倒计时结束，关闭
//                dispatch_source_cancel(_timer);
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    //设置界面的按钮显示 根据自己需求设置
//                    [self.verificationView.nextButton setTitle:@"重新发送" forState:UIControlStateNormal];
//                    [self.verificationView.nextButton setEnabled:YES];
//
//                });
//            }else{
//                NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    //设置界面的按钮显示 根据自己需求设置
//                    [self.verificationView.nextButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateDisabled];
//
//                    [self.verificationView.nextButton setEnabled:NO];
//                    
//                });
//                timeout--;
//            }
//        });
//        dispatch_resume(_timer);
//    }
//}


//- (void)dealloc
//{
//    for (UIView *vie in self.view.subviews) {
//
//        [vie removeFromSuperview];
//    }
//    _trendView = nil;
//    _bgblurImage = nil;
//    _verificationView = nil;
//}



@end
