//
//  LoginPhoneVC.m
//  weLian
//
//  Created by dong on 14/10/29.
//  Copyright (c) 2014年 chuansongmen. All rights reserved.
//

#import "LoginPhoneVC.h"
#import "NSString+val.h"
#import "MainViewController.h"
#import "MJExtension.h"
#import "WLTextField.h"
#import "ForgetPhoneController.h"
#import "LogInUser.h"

@interface LoginPhoneVC ()<UITextFieldDelegate>

@property (strong, nonatomic)  WLTextField *phoneTextField;
@property (strong, nonatomic)  WLTextField *pwdTextField;

@end

@implementation LoginPhoneVC

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneTextField) {
        if (range.location>=11) return NO;
    }else if (textField == self.pwdTextField){
        if (range.location>=18) return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.phoneTextField) {
        [self.pwdTextField becomeFirstResponder];
    }else if (textField == self.pwdTextField){
        [self loginPhonePWD:nil];
    }
    
    return YES;
}

- (void)setPhoneString:(NSString *)phoneString
{
    _phoneString = phoneString;
    
    //设置手机号码
    _phoneTextField.text = _phoneString;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载页面数据
    [self loadUIView];
}

- (void)loadUIView
{
    [self setTitle:@"登录"];
    //设置背景色
    [self.view setBackgroundColor:WLLineColor];
    //设置右上角
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleBordered target:self action:@selector(loginPhonePWD:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(cancellVC)];
    
    //手机号码
    WLTextField *phoneTF = [[WLTextField alloc] initWithFrame:Rect(0, ViewCtrlTopBarHeight + kFirstMarginTop, self.view.width, TextFieldHeight)];
    phoneTF.placeholder = @"手机号码";
    phoneTF.text = lastLoginMobile;
    phoneTF.returnKeyType = UIReturnKeyNext;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.delegate = self;
    [self.view addSubview:phoneTF];
    self.phoneTextField = phoneTF;
    
    //密码
    WLTextField *pwdTF = [[WLTextField alloc] initWithFrame:Rect(0, phoneTF.bottom + 1, self.view.width, TextFieldHeight)];
    pwdTF.placeholder = @"密码";
    pwdTF.secureTextEntry = YES;
    pwdTF.returnKeyType = UIReturnKeyGo;
    pwdTF.keyboardType = UIKeyboardTypeDefault;
    pwdTF.delegate = self; 
    [self.view addSubview:pwdTF];
    self.pwdTextField = pwdTF;
    
    CGFloat butW = 75;
    UIButton *forgetBut = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - butW - 20, pwdTF.bottom + 15, butW, 30)];
    [forgetBut.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [forgetBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [forgetBut setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBut addTarget:self action:@selector(forgetPwd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBut];
}

- (void)cancellVC
{
    [self.view.findFirstResponder resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)forgetPwd:(UIButton *)sender {
    ForgetPhoneController *forgetVC = [[ForgetPhoneController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)loginPhonePWD:(UIBarButtonItem *)sender {
    [[self.view findFirstResponder] resignFirstResponder];
    
    if (![NSString phoneValidate:self.phoneTextField.text]) {
        [WLHUDView showErrorHUD:@"手机号码有误！"];
        return;
    }
    if (![NSString passwordValidate:self.pwdTextField.text]) {
        [WLHUDView showErrorHUD:@"密码有误！"];
        return;
    }
    NSMutableDictionary *reqstDic = [NSMutableDictionary dictionary];
    [reqstDic setObject:self.phoneTextField.text forKey:@"mobile"];
    [reqstDic setObject:self.pwdTextField.text forKey:@"password"];
    [reqstDic setObject:KPlatformType forKey:@"platform"];
    if ([UserDefaults objectForKey:BPushRequestChannelIdKey]) {
        
        [reqstDic setObject:[UserDefaults objectForKey:BPushRequestChannelIdKey] forKey:@"clientid"];
    }
    
    [WLHttpTool loginParameterDic:reqstDic success:^(id JSON) {
        NSDictionary *dataDic = JSON;
        if (dataDic) {
            UserInfoModel *mode = [UserInfoModel objectWithKeyValues:dataDic];
            [mode setCheckcode:self.pwdTextField.text];
            
            [UserDefaults setObject:mode.sessionid forKey:@"sessionid"];
            //记录最后一次登陆的手机号
            SaveLoginMobile(self.phoneTextField.text);
            SaveLoginPassWD(self.pwdTextField.text);
            [LogInUser createLogInUserModel:mode];

            //进入主页面
            MainViewController *mainVC = [[MainViewController alloc] init];
            [[UIApplication sharedApplication].keyWindow setRootViewController:mainVC];
        }

    } fail:^(NSError *error) {
        
    } isHUD:YES];
}

@end
